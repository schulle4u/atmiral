#!/bin/bash
# ATMIRAL - Accessible text-based menu interface for running applications on Linux)
# Copyright (c) 2025 Steffen Schultz, released under the terms of the MIT license

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default configuration values
ATMIRAL_LANG="de"
COMMAND_DEBUG=0

# Load config file
CONFIG_FILE=""
if [ -e "/etc/atmiral.conf" ]; then
    CONFIG_FILE="/etc/atmiral.conf"
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
    if ! (set -e; source "$lang_file" >/dev/null 2>&1); then
        echo "Error: Invalid syntax in language file '$lang_file'." >&2
        return 1
    fi

    source "$lang_file"

    # Validate critical variables are set
    local required_vars=(
        "MSG_ERROR_DIALOG_MISSING"
        "UI_TITLE"
        "UI_MENU_PROMPT"
        "UI_OK_BUTTON"
        "UI_CANCEL_BUTTON"
        "UI_BACK_OPTION"
        "UI_BACK_DESCRIPTION"
        "MSG_PRESS_ENTER"
        "FIELD_NAME_PATTERN"
        "FIELD_DESC_PATTERN"
        "FIELD_CMD_PATTERN"
        "FIELD_ARGS_PATTERN"
    )
    
    local missing_vars=()
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
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

# Load language file
LANG_FILE="${SCRIPT_DIR}/lang/${ATMIRAL_LANG}.sh"
if ! load_language_file "$LANG_FILE"; then
    # Fallback to english
    LANG_FILE="${SCRIPT_DIR}/lang/en.sh"
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
}

# Looking for menu list files
if [[ -n "${1:-}" && -d "$1" ]]; then
    MENUDIR="$1"
elif [[ -d "$HOME/.config/atmiral/menu/" ]]; then
    MENUDIR="$HOME/.config/atmiral/menu/"
else
    MENUDIR="$SCRIPT_DIR/menu/"
fi

# Validate if directory exists
if [[ ! -d "$MENUDIR" ]]; then
    printf "$MSG_ERROR_MENUDIR_NOT_EXISTS\n" "$MENUDIR" >&2
    exit 1
fi

# Parse text format menu files
parse_menufile() {
    local menufile="$1"
    
    if [[ ! -f "$menufile" ]]; then
        printf "$MSG_WARNING_FILE_NOT_FOUND\n" "$menufile" >&2
        return 1
    fi
    
    if [[ ! -r "$menufile" ]]; then
        printf "$MSG_WARNING_FILE_NOT_READABLE\n" "$menufile" >&2
        return 1
    fi
    
    PARSED=()
    local line_number=0
    local current_name=""
    local current_desc=""
    local current_cmd=""
    local current_args=""
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        line_number=$((line_number + 1))
        
        # Remove leading and trailing whitespace
        line=$(echo "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue
        
        # Parse key-value pairs using localized patterns
        if [[ "$line" =~ $FIELD_NAME_PATTERN ]]; then
            # Save previous entry if complete
            if [[ -n "$current_name" && -n "$current_cmd" ]]; then
                PARSED+=("$current_name" "$current_desc" "$current_cmd" "$current_args")
            fi
            # Start new entry
            current_name=$(echo "$line" | sed "s/$FIELD_NAME_PATTERN//")
            current_desc=""
            current_cmd=""
            current_args=""
            
        elif [[ "$line" =~ $FIELD_DESC_PATTERN ]]; then
            current_desc=$(echo "$line" | sed "s/$FIELD_DESC_PATTERN//")
            
        elif [[ "$line" =~ $FIELD_CMD_PATTERN ]]; then
            current_cmd=$(echo "$line" | sed "s/$FIELD_CMD_PATTERN//")
            
        elif [[ "$line" =~ $FIELD_ARGS_PATTERN ]]; then
            current_args=$(echo "$line" | sed "s/$FIELD_ARGS_PATTERN//")
            
        else
            printf "$MSG_WARNING_UNKNOWN_FORMAT\n" "$line_number" "$line" >&2
        fi
    done < "$menufile"
    
    # Don't forget the last entry
    if [[ -n "$current_name" && -n "$current_cmd" ]]; then
        PARSED+=("$current_name" "$current_desc" "$current_cmd" "$current_args")
    fi
    
    if [[ ${#PARSED[@]} -eq 0 ]]; then
        printf "$MSG_WARNING_NO_VALID_ENTRIES\n" "$menufile" >&2
        return 1
    fi
    
    return 0
}

# Safe command execution with argument handling
execute_command() {
    local cmd="$1"
    local args="$2"
    local full_command
    
    if [[ -n "$args" ]]; then
        # Check if arguments contain placeholders or if we should prompt
        if [[ "$args" == *"<"*">"* ]]; then
            # Interactive argument input
            local processed_args="$args"
            local placeholder
            
            # Find all placeholders like <filename>, <path>, etc.
            while [[ "$processed_args" =~ \<([^>]+)\> ]]; do
                placeholder="${BASH_REMATCH[1]}"
                local user_input
                
                # Prompt user for input
                if user_input=$(dialog --no-lines --inputbox "$(printf "$UI_INPUT_PROMPT" "$placeholder")" 10 60 3>&1 1>&2 2>&3); then
                    processed_args="${processed_args//<$placeholder>/$user_input}"
                else
                    clear
                    printf "%s\n" "$MSG_CANCELLED"
                    printf "%s" "$MSG_PRESS_ENTER"
                    read -r
                    return 1
                fi
            done
            full_command="$cmd $processed_args"
        else
            # Use arguments directly
            full_command="$cmd $args"
        fi
    else
        full_command="$cmd"
    fi
    clear
    if [[ "$COMMAND_DEBUG" == "1" ]]; then
        printf "$MSG_STARTING_COMMAND\n" "$full_command"
        printf "%s\n" "$MSG_SEPARATOR"
    fi
    
    # Use bash -c instead of eval for better safety
    if bash -c "$full_command"; then
        printf "%s\n" "$MSG_SEPARATOR"
        printf "%s\n" "$MSG_COMMAND_SUCCESS"
    else
        local exit_code=$?
        printf "%s\n" "$MSG_SEPARATOR"
        printf "$MSG_COMMAND_ERROR\n" "$exit_code"
    fi
    
    printf "\n"
    printf "%s" "$MSG_PRESS_ENTER"
    read -r
}

# Show menu for a .txt file
run_textmenu() {
    local menufile="$1"
    
    if ! parse_menufile "$menufile"; then
        dialog --no-lines --ok-label "$UI_OK_BUTTON" --msgbox "$(printf "$UI_ERROR_LOADING_FILE" "$menufile")" 10 70
        clear
        return 1
    fi
    
    if [[ ${#PARSED[@]} -eq 0 ]]; then
        dialog --no-lines --ok-label "$UI_OK_BUTTON" --msgbox "$(printf "$UI_ERROR_NO_ENTRIES" "$menufile")" 10 70
        clear
        return 1
    fi

    while true; do
        local menu_entries=()
        local display_entries=()

        for ((i=0; i<${#PARSED[@]}; i+=4)); do
            menu_entries+=("${PARSED[$i]}" "${PARSED[$((i+1))]}" "${PARSED[$((i+2))]}" "${PARSED[$((i+3))]}")
            display_entries+=("${PARSED[$i]}" "${PARSED[$((i+1))]}")
        done

        clear
        local choice
        choice=$(dialog --visit-items --no-lines --begin 1 1 --title "$UI_TITLE" \
            --ok-label "$UI_OK_BUTTON" --cancel-label "$UI_CANCEL_BUTTON" \
            --menu "$UI_MENU_PROMPT" 0 0 0 \
            "$UI_BACK_OPTION" "$UI_BACK_DESCRIPTION" \
            "${display_entries[@]}" \
            3>&1 1>&2 2>&3)

        # Handle exit on escape
        local status=$?
        if [[ $status -ne 0 ]]; then
            exit 0
        fi

        # Back to parent menu
        if [[ "$choice" == "$UI_BACK_OPTION" ]]; then
            return 0
        fi

        # Execute selected command
        for ((i=0; i<${#menu_entries[@]}; i+=4)); do
            if [[ "${menu_entries[$i]}" == "$choice" ]]; then
                clear
                execute_command "${menu_entries[$((i+2))]}" "${menu_entries[$((i+3))]}"
                break
            fi
        done
    done
}

# Folder menu
run_menu() {
    local current_dir="$1"
    
    if [[ ! -d "$current_dir" ]]; then
        printf "$MSG_ERROR_MENUDIR_NOT_EXISTS\n" "$current_dir" >&2
        return 1
    fi

    while true; do
        local menu_entries=()
        local display_entries=()

        # Subfolders as categories
        for dir in "$current_dir"/*/; do
            [[ -d "$dir" ]] || continue
            local base
            base=$(basename "$dir")
            menu_entries+=("$base" "$UI_FOLDER_PREFIX$base" "submenu:$dir")
            display_entries+=("$base" "$UI_FOLDER_PREFIX$base")
        done

        # Every .txt file as own submenu
        for file in "$current_dir"/*.txt; do
            [[ -e "$file" ]] || continue
            local base
            base=$(basename "$file" .txt)
            menu_entries+=("$base" "$UI_PROGRAMS_PREFIX$base" "textmenu:$file")
            display_entries+=("$base" "$UI_PROGRAMS_PREFIX$base")
        done

        clear
        if [[ ${#display_entries[@]} -eq 0 ]]; then
            dialog --no-lines --ok-label "$UI_OK_BUTTON" --msgbox "$(printf "$UI_ERROR_NO_ENTRIES_DIR" "$current_dir")" 10 70
            clear
            return 0
        fi

        local choice
        choice=$(dialog --visit-items --no-lines --begin 1 1 --title "$UI_TITLE" \
            --ok-label "$UI_OK_BUTTON" --cancel-label "$UI_CANCEL_BUTTON" \
            --menu "$UI_MENU_PROMPT" 0 0 0 \
            "$UI_BACK_OPTION" "$UI_BACK_DESCRIPTION" \
            "${display_entries[@]}" \
            3>&1 1>&2 2>&3)

        # Handle exit on escape
        local status=$?
        if [[ $status -ne 0 ]]; then
            exit 0
        fi

        # Back to parent menu
        if [[ "$choice" == "$UI_BACK_OPTION" ]]; then
            return 0
        fi

        # Handle menu selection
        for ((i=0; i<${#menu_entries[@]}; i+=3)); do
            if [[ "${menu_entries[$i]}" == "$choice" ]]; then
                local action="${menu_entries[$((i+2))]}"

                if [[ "$action" == submenu:* ]]; then
                    run_menu "${action#submenu:}"
                elif [[ "$action" == textmenu:* ]]; then
                    run_textmenu "${action#textmenu:}"
                fi
                break
            fi
        done
    done
}

# Main execution
main() {
    check_dependencies
    
    if ! run_menu "$MENUDIR"; then
        printf "%s\n" "$MSG_ERROR_MAIN_MENU_FAILED" >&2
        exit 1
    fi
}

# Trap to handle cleanup on script exit
trap 'clear; printf "%s\n" "$MSG_EXIT"' EXIT

# Start the application
main "$@"