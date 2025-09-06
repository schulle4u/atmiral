#!/bin/bash
# ATMIRAL File Browser
# A part of ATMIRAL - Accessible text-based menu interface for running applications on Linux
# Copyright (c) 2025 Steffen Schultz, released under the terms of the MIT license

set -uo pipefail

# Determine current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration values
ATMIRAL_LANG="de"
COMMAND_DEBUG=0
SHOW_HIDDEN=1

# Load config file
CONFIG_FILE=""
if [ -e "/etc/atmiral/atmiral.conf" ]; then
    CONFIG_FILE="/etc/atmiral/atmiral.conf"
elif [ -e "$HOME/.config/atmiral/atmiral.conf" ]; then
    CONFIG_FILE="$HOME/.config/atmiral/atmiral.conf"
elif [ -e "$SCRIPT_DIR/atmiral.conf" ]; then
    CONFIG_FILE="$SCRIPT_DIR/atmiral.conf"
fi

if [ -n "$CONFIG_FILE" ]; then
    # Check if config file is readable
    if [ -r "$CONFIG_FILE" ]; then
        if grep -q -vE '^\s*(#|$|[a-zA-Z_][a-zA-Z0-9_]*=)' "$CONFIG_FILE"; then
            echo "Error: Config file '$CONFIG_FILE' contains invalid lines." >&2
            exit 1
        fi
        if ! (set -e; source "$CONFIG_FILE") 2>/dev/null; then
            echo "Error: Invalid config file '$CONFIG_FILE'." >&2
            exit 1
        fi
    else
        echo "Error: Cannot read config file '$CONFIG_FILE'." >&2
        exit 1
    fi
fi

# Load language file
load_language_file() {
    local lang_file="$1"
    
    if [[ ! -f "$lang_file" ]]; then
        return 1
    fi
    
    if [[ ! -r "$lang_file" ]]; then
        echo "Error: Cannot read language file '$lang_file'." >&2
        return 1
    fi
    
    # Load the language file safely
    if ! bash -n "$lang_file" 2>/dev/null; then
        echo "Error: Invalid syntax in language file '$lang_file'." >&2
        return 1
    fi

    source "$lang_file"

    # Validate critical variables are set
    local required_vars=(
        "MSG_ERROR_DIALOG_MISSING"
        "UI_FM_TITLE"
        "UI_FM_MENU_PROMPT"
        "UI_OK_BUTTON"
        "UI_CANCEL_BUTTON"
        "UI_BACK_DESCRIPTION"
    )
    
    local missing_vars=()
    for var in "${required_vars[@]}"; do
        if [[ ! -v $var ]]; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        echo "Error: Language file '$lang_file' is missing required variables:" >&2
        printf "  %s\n" "${missing_vars[@]}" >&2
        return 1
    fi
    
    return 0
}

if [[ -d "/usr/local/share/atmiral/lang/" ]]; then
    LANGDIR="/usr/local/share/atmiral/lang/"
elif [[ -d "$HOME/.local/share/atmiral/lang/" ]]; then
    LANGDIR="$HOME/.local/share/atmiral/lang/"
else
    LANGDIR="$SCRIPT_DIR/lang/"
fi

LANG_FILE="${LANGDIR}/${ATMIRAL_LANG}.sh"
if ! load_language_file "$LANG_FILE"; then
    # Fallback to english
    LANG_FILE="${LANGDIR}/en.sh"
    if ! load_language_file "$LANG_FILE"; then
        echo "Error: No valid language file found." >&2
        exit 1
    fi
fi

# Dependency Check
check_dependencies() {
    if ! command -v dialog >/dev/null 2>&1; then
        printf "%s\n" "$MSG_ERROR_DIALOG_MISSING" >&2
        printf "%s\n" "$MSG_ERROR_DIALOG_INSTALL" >&2
        exit 1
    fi
    if ! command -v file >/dev/null 2>&1; then
        printf "%s\n" "$MSG_ERROR_FILE_MISSING" >&2
        exit 1
    fi
}

check_dependencies

# Set initial options for dialog
export DIALOGOPTS="--visit-items --no-lines \
    --ok-label \"$UI_OK_BUTTON\" \
    --cancel-label \"$UI_CANCEL_BUTTON\""

# Set starting directory and fallback
if [[ -n "${1:-}" && -d "$1" ]]; then
    CWD="$1"
elif [[ -d "$HOME" ]]; then
    CWD="$HOME"
else
    CWD=$SCRIPT_DIR
fi

# Get mimetype
get_safe_mimetype() {
    local filepath="$1"
    local mimetype=""
    
    # Check if path exists
    if [[ ! -e "$filepath" && ! -L "$filepath" ]]; then
        echo "$UI_FILE_NOT_FOUND"
        return 1
    fi
    
    # Handle symbolic links
    if [[ -L "$filepath" ]]; then
        local link_target
        link_target=$(readlink "$filepath" 2>/dev/null)
        if [[ $? -ne 0 || -z "$link_target" ]]; then
            echo "$UI_SYMLINK_BROKEN"
            return 1
        fi
        
        # Check if link is absolute or relative
        if [[ "$link_target" != /* ]]; then
            # Relative link - combine with original directory
            local dir=$(dirname "$filepath")
            link_target="$dir/$link_target"
        fi
        
        # Check link target
        if [[ ! -e "$link_target" ]]; then
            echo "$UI_SYMLINK_BROKEN"
            return 1
        elif [[ -d "$link_target" ]]; then
            echo "$UI_SYMLINK_TO_DIRECTORY"
            return 0
        elif [[ -f "$link_target" ]]; then
            echo "$UI_SYMLINK_TO_FILE"
            return 0
        else
            echo "$UI_SYMLINK_TO_SPECIAL"
            return 0
        fi
    fi
    
    # Handle special file types
    if [[ -d "$filepath" ]]; then
        echo "$UI_FM_FOLDER"
        return 0
    elif [[ -c "$filepath" ]]; then
        echo "$UI_SPECIAL_CHAR_DEVICE"
        return 0
    elif [[ -b "$filepath" ]]; then
        echo "$UI_SPECIAL_BLOCK_DEVICE"
        return 0
    elif [[ -p "$filepath" ]]; then
        echo "$UI_SPECIAL_NAMED_PIPE"
        return 0
    elif [[ -S "$filepath" ]]; then
        echo "$UI_SPECIAL_SOCKET"
        return 0
    elif [[ ! -f "$filepath" ]]; then
        echo "$UI_SPECIAL_UNKNOWN"
        return 1
    fi
    
    # Check read permissions for regular files
    if [[ ! -r "$filepath" ]]; then
        echo "$UI_FILE_NO_PERMISSION"
        return 1
    fi
    
    # Try to get mimetype
    if command -v file >/dev/null 2>&1; then
        # Timeout and error handling
        mimetype=$(timeout 5s file --mime-type -b "$filepath" 2>/dev/null)
        local exit_code=$?
        
        # Check if command successful
        if [[ $exit_code -eq 0 && -n "$mimetype" ]]; then
            # Clean unusual output
            mimetype=$(echo "$mimetype" | tr -d '\0\r\n' | cut -d';' -f1)
            
            # Validate MIME-Type Format (type/subtype)
            if [[ "$mimetype" =~ ^[a-zA-Z][a-zA-Z0-9][a-zA-Z0-9\!\#\$\&\-\^]*\/[a-zA-Z0-9][a-zA-Z0-9\!\#\$\&\-\^\.]*$ ]]; then
                echo "$mimetype"
                return 0
            fi
        elif [[ $exit_code -eq 124 ]]; then
            # Timeout exceded
            echo "$UI_FILE_TIMEOUT"
            return 1
        fi
    fi
    
    # Fallback: Check file extension
    get_mimetype_by_extension "$filepath"
    return $?
}

# Fallback for mimetype detection using file extension
get_mimetype_by_extension() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local extension="${filename##*.}"
    
    # Convert to lowercase
    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    
    case "$extension" in
        # Text files
        txt|text) echo "text/plain" ;;
        md|markdown) echo "text/markdown" ;;
        html|htm) echo "text/html" ;;
        css) echo "text/css" ;;
        js) echo "text/javascript" ;;
        json) echo "application/json" ;;
        xml) echo "text/xml" ;;
        csv) echo "text/csv" ;;
        
        # Images
        jpg|jpeg) echo "image/jpeg" ;;
        png) echo "image/png" ;;
        gif) echo "image/gif" ;;
        bmp) echo "image/bmp" ;;
        svg) echo "image/svg+xml" ;;
        webp) echo "image/webp" ;;
        
        # Audio
        mp3) echo "audio/mpeg" ;;
        wav) echo "audio/wav" ;;
        ogg) echo "audio/ogg" ;;
        flac) echo "audio/flac" ;;
        
        # Video
        mp4) echo "video/mp4" ;;
        avi) echo "video/x-msvideo" ;;
        mkv) echo "video/x-matroska" ;;
        webm) echo "video/webm" ;;
        
        # Archive
        zip) echo "application/zip" ;;
        tar) echo "application/x-tar" ;;
        gz) echo "application/gzip" ;;
        bz2) echo "application/x-bzip2" ;;
        
        # Documents
        pdf) echo "application/pdf" ;;
        doc) echo "application/msword" ;;
        docx) echo "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ;;
        
        # Executable
        sh|bash) echo "application/x-shellscript" ;;
        py) echo "text/x-python" ;;
        
        *) echo "application/octet-stream" ;;
    esac
    return 0
}

# Dialog wrapper
run_dialog() {
    local output
    if ! output=$(dialog "$@" 3>&1 1>&2 2>&3); then
        return 1
    fi
    printf '%s\n' "$output"
}

while true; do
    # List entries
    entries=()
    entries+=(".." "$UI_BACK_DESCRIPTION")

    # Command for finding directories (excluding . and ..)
    find_dirs=(find "$CWD" -maxdepth 1 -mindepth 1 -type d)

    # Command for finding regular files and special files
    find_files=(find "$CWD" -maxdepth 1 -mindepth 1 -not -type d)
    
    # Add hidden file exclusion
    if [[ "$SHOW_HIDDEN" != "1" ]]; then
        find_dirs+=(-not -name '.*')
        find_files+=(-not -name '.*')
    fi
    
    # Process directories
    # Sort them alphabetically
    while IFS= read -r -d '' dir_path; do
        # local name
        name=$(basename "$dir_path")
        if [[ -L "$dir_path" ]]; then
            entries+=("$name" "$UI_SYMLINK_GENERIC")
        else
            entries+=("$name" "$UI_FM_FOLDER")
        fi
    done < <("${find_dirs[@]}" -print0 | sort -z)

    # Process files
    # Sort them alphabetically
    while IFS= read -r -d '' file_path; do
        # local name
        name=$(basename "$file_path")
        if [[ -L "$file_path" ]]; then
            entries+=("$name" "$UI_SYMLINK_GENERIC")
        elif [[ -c "$file_path" || -b "$file_path" || -p "$file_path" || -S "$file_path" ]]; then
            entries+=("$name" "$UI_SPECIAL_GENERIC")
        else
            entries+=("$name" "$UI_FM_FILE")
        fi
    done < <("${find_files[@]}" -print0 | sort -z)

    # Main menu
    clear
    if ! choice=$(run_dialog --begin 3 1 \
        --backtitle "$UI_FM_TITLE - ${USER}@${HOSTNAME}:${CWD}" \
        --title "$UI_FM_LIST_TITLE" \
        --menu "$UI_FM_MENU_PROMPT" 0 0 0 \
        "${entries[@]}"); then
        break  # Exit on escape or cancel
    fi

    # Check read permissions
    if [[ ! -r "$CWD/$choice" ]]; then
        run_dialog --msgbox "$UI_FILE_NO_PERMISSION" 10 70
        continue
    fi
    
    if [ "$choice" = ".." ]; then
        # Back to parent
        CWD=$(dirname "$CWD")
        continue
    fi

    if [ -d "$CWD/$choice" ]; then
        # Jump into subfolder
        CWD="$CWD/$choice"
        continue
    else
        # Determine file type
        mimetype=$(file --mime-type -b "$CWD/$choice")

        actions=()
        if [[ $mimetype == text/* ]]; then
            if command -v nano >/dev/null 2>&1; then
                actions+=("Nano" "$ACTION_AS_TEXT")
            fi
            if command -v vim >/dev/null 2>&1; then
                actions+=("Vim" "$ACTION_AS_TEXT")
            fi
            if command -v less >/dev/null 2>&1; then
                actions+=("Less" "$ACTION_VIEW")
            fi
        fi
        if [[ $mimetype == audio/* || $mimetype == video/* ]]; then
            if command -v mpv >/dev/null 2>&1; then
                actions+=("MPV" "$ACTION_PLAY_MEDIA")
            fi
        fi
        if [[ $mimetype == image/* ]]; then
            if command -v feh >/dev/null 2>&1; then
                actions+=("Feh" "$ACTION_IMAGE")
            fi
        fi
        if [[ -x "$CWD/$choice" ]]; then
            actions+=("$ACTION_RUN" "$ACTION_RUN_DESCRIPTION")
        fi
        actions+=("$ACTION_CUSTOM" "$ACTION_CUSTOM_DESCRIPTION")
        actions+=("$ACTION_INFO" "$ACTION_INFO_DESCRIPTION")
        actions+=("$ACTION_CANCEL" "$ACTION_CANCEL_DESCRIPTION")

        # File actions menu
        clear
        if ! action=$(run_dialog --title "$(printf "$ACTION_FILE_TITLE" "$choice")" \
            --menu "$UI_FM_ACTION_PROMPT" 0 0 0 \
            "${actions[@]}"); then
                continue
            fi

        case $action in
            "Nano") (nano "$CWD/$choice") ;;
            "Vim") (vim "$CWD/$choice") ;;
            "Less") (less "$CWD/$choice") ;;
            "MPV") (mpv "$CWD/$choice") ;;
            "Feh") (feh "$CWD/$choice") ;;
            "$ACTION_RUN") ("$CWD/$choice") ;;
            "$ACTION_CUSTOM")
                clear
                if ! custom_cmd=$(run_dialog --title "$ACTION_CUSTOM" \
                    --inputbox "$UI_FM_CUSTOM_PROMPT" 10 60); then
                    continue
                fi

                if [ -n "$custom_cmd" ]; then
                    # Split into command and parameters
                    quoted_parts=()
                    for word in $custom_cmd; do
                        quoted_parts+=("$(printf '%q' "$word")")
                    done

                    # Quote and attach file safely
                    quoted_parts+=("$(printf '%q' "$CWD/$choice")")

                    # Re-build and run command
                    (bash -c "${quoted_parts[*]}")
                fi
                ;;
            "$ACTION_INFO")
                clear
                # Using get_safe_mimetype for the detailed information
                # local detailed_info
                detailed_info=$(get_safe_mimetype "$CWD/$choice")
                
                info_message=$(printf "$INFO_MSG_PATH" "$CWD/$choice\n")
                info_message+="---------------------------------\n"
                info_message+=$(printf "$INFO_MSG_TYPE" "$detailed_info\n")
                info_message+=$(printf "$INFO_MSG_SIZE" "$(du -sh "$CWD/$choice" 2>/dev/null | awk '{print $1}')\n")
                info_message+=$(printf "$INFO_MSG_PERMS" "$(stat -c '%A' "$CWD/$choice" 2>/dev/null)\n")

                if ! info=$(run_dialog --title "$ACTION_INFO" --msgbox "$info_message" 0 0); then
                    continue
                fi
                ;;
            *) : ;;
        esac
    fi
done

# Trap to handle cleanup on script exit
trap 'clear; printf "%s\n" "$MSG_EXIT"' EXIT