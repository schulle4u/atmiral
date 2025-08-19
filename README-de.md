# WhipLaunch
Linux-Programmstarter auf Whiptail-Basis

## Beschreibung

WhipLaunch ist ein benutzerfreundliches Startmenü für die Linux-Shell zum schnellen Aufrufen häufig verwendeter Programme und Befehle. Über eine Ordnerstruktur mit menschenlesbaren Textdateien kann das Menü individuell zusammengestellt werden und ist somit an jedes Linux-System anpassbar. Es eignet sich sowohl für Anfänger, um ihnen die Scheu vor Befehlseingaben zu nehmen, als auch für Menschen, die für bestimmte Abläufe bewusst eine eingeschränkte Arbeitsumgebung bevorzugen. Es soll dabei weder die Befehlseingabe noch eine komplette grafische Oberfläche auf Shellebene ersetzen.

## Installation

Das Repository clonen und `whiplaunch.sh` ausführbar machen. 

```
chmod +x ./whiplaunch.sh
```

TODO: Installationsscript erstellen.

## Verwendung

WhipLaunch sucht beim Aufruf im Verzeichnis `$HOME/.config/whiplaunch/menu` oder im eigenen Verzeichnis nach Menüdateien. Es sind einige Beispielordner und -Dateien im Repository, die sofort gefunden werden sollten. Eine Menüdatei besteht aus Konfigurationsabschnitten, die durch eine leerzeile voneinander getrennt sind. Jeder Konfigurationsabschnitt kann folgende Werte enthalten: 

* Name: Anzeigename des Programms oder Befehls (nicht der eigentliche Befehl)
* Beschreibung: Kurze Beschreibung, wird rechts neben dem Namen angezeigt.
* Befehl: Der eigentliche Befehl, welcher beim Bestätigen des Menüeintrags aufgerufen wird. 
* Argumente: jede Art von festen oder dynamischen Befehlsoptionen. Der Text zwischen `<` und `>` wird als Vorlage erkannt und im Menü beim Aufrufen abgefragt. 

**Hinweis**: Die oben genannten Feldnamen sind für jede Sprache übersetzbar. Wird WhipLaunch in einer anderen Sprache als deutch verwendet, müssen auch die Feldnamen in dieser Sprache angegeben werden, sofern sie in der Sprachdatei übersetzt wurden. 

## Beispiel

Hier ist eine Menüdatei mit verschiedenen Systembefehlen.

```
Name: Top
Beschreibung: Systemmonitor
Befehl: top

Name: Uptime
Beschreibung: Zeigt Systemlaufzeit
Befehl: uptime

Name: Updates
Beschreibung: Nach Updates suchen
Befehl: sudo apt update && sudo apt upgrade

# Im nachfolgenden Beispiel wird <Text> als Argumentvorlage hinterlegt und beim Aufruf abgefragt
Name: Sprachausgabe
Beschreibung: Eingegebenen Text sprechen
Befehl: espeak-ng
Argumente: -v de -a 100 -s 300 "<Text>"

# Es sind auch mehrere Platzhalter möglich, die dann nacheinander vor dem Befehlsaufruf abgefragt werden
Name: Dienststeuerung
Beschreibung: Dienststeuerung
Befehl: sudo systemctl
Argumente: <Aktion> <Dienst>
```

## Entwicklung

Copyright (C) 2025 Steffen Schultz, freigegeben unter den Bedingungen der MIT-Lizenz. 
