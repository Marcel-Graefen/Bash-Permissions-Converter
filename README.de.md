# 📋 Bash Permissions Converter

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/Marcel-Graefen/Bash-Permissions-Converter/releases/tag/0.1.0)
[![English](https://img.shields.io/badge/Sprache-English-blue)](./README.md)
![GitHub last commit](https://img.shields.io/github/last-commit/Marcel-Graefen/Bash-INI-Parser)
[![Author](https://img.shields.io/badge/author-Marcel%20Gr%C3%A4fen-green.svg)](#-author--contact)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

Eine schlanke und robuste Bash-Funktion zur Konvertierung von Dateiberechtigungen zwischen numerischer (oktaler) und symbolischer Darstellung.

-----

## 🚀 Inhaltsverzeichnis

  * [📋 Features](#-features)
  * [⚙️ Voraussetzungen](#%25EF%25B8%258F-voraussetzungen)
  * [🚀 Nutzung](#-nutzung)
    * [Beispiele](#-beispiele)
  * [📌 API-Referenz](#-api-referenz)
    * [`permconv`](#permconv)
    * [`Verwendete globale Variablen`](#verwendete-globale-variablen)
  * [👤 Autor & Kontakt](#-autor--kontakt)
  * [🤖 Generierungshinweis](#-generierungshinweis)
  * [📜 Lizenz](#-lizenz)

-----

## 📋 Features

  * **Bidirektionale Konvertierung:** Wandelt Berechtigungen von numerisch zu symbolisch und umgekehrt um.
  * **Unterstützung für Spezialberechtigungen:** Verarbeitet `setuid`, `setgid` und das Sticky Bit korrekt.
  * **Eingabevalidierung:** Prüft automatisch, ob die Eingabe ein gültiges Format hat.
  * **Hilfreiche Warnungen:** Gibt Warnmeldungen aus, wenn Spezialberechtigungen erkannt werden.
  * **Einfache Integration:** Die Funktion ist so konzipiert, dass sie leicht in bestehende Bash-Skripte eingebunden werden kann.

-----

## ⚙️ Voraussetzungen

  * **Bash** Version 3.0 oder höher.

-----

## 🚀 Nutzung

Die `permconv`-Funktion wird am besten in dein Skript eingebunden und dann mit dem gewünschten Berechtigungsstring aufgerufen. Das Ergebnis wird in einer globalen Variable gespeichert.

### Beispiele

**1. Numerisch (Oktal) zu Symbolisch**

Wandelt die Berechtigung `755` in `rwxr-xr-x` um und speichert sie in der Variable `PERMISSIONS_SYMBOLIC`.

```bash
#!/usr/bin/env bash

# Funktionsaufruf
permconv 755

# Ausgabe der resultierenden Variablen
echo "Symbolische Berechtigung: $PERMISSIONS_SYMBOLIC"
# Ausgabe: rwxr-xr-x
```

**2. Symbolisch zu Numerisch (Oktal)**

Wandelt die Berechtigung `rwsr-xr-x` (mit SetUID) in `4755` um und speichert sie in `PERMISSIONS_NUMERIC`.

```bash
#!/usr/bin/env bash

# Voreinstellungen
SHOW_WARNING="true"

# Funktionsaufruf
permconv rwsr-xr-x

# Ausgabe der resultierenden Variablen
echo "Numerische Berechtigung: $PERMISSIONS_NUMERIC"
# Ausgabe: 4755
# Konsole: "⚠️ WARNING: setuid detected: executable will run with the file owner's user ID"
```

**3. Ungültige Eingabe**

Ungültige Eingaben führen zu einer Fehlermeldung und beenden das Skript.

```bash
#!/usr/bin/env bash

# Funktionsaufruf mit ungültiger Eingabe
permconv rwx1r-x-x

# Ausgabe:
# ❌ ERROR: Invalid format: 'rwx1r-x-x'
# Das Skript wird an dieser Stelle beendet.
```

-----

## 📌 API-Referenz

### `permconv`

Konvertiert Berechtigungen zwischen numerischer und symbolischer Darstellung. Die Funktion benötigt ein Argument.

**Syntax:**

```bash
permconv <Berechtigungsstring>
```

  * `$1`: Ein Berechtigungsstring im Format `[0-7]{3,4}` (numerisch) oder `[-][rwxst-]{9}` (symbolisch).

### Verwendete globale Variablen

Die Funktion setzt die folgenden globalen Variablen:

  * **`PERMISSIONS_NUMERIC`**: Enthält die numerische Berechtigung, wenn eine symbolische Eingabe konvertiert wurde.
  * **`PERMISSIONS_SYMBOLIC`**: Enthält die symbolische Berechtigung, wenn eine numerische Eingabe konvertiert wurde.
  * **`SHOW_WARNING`**: Eine optionale Variable. Wenn auf `"false"` gesetzt, werden Warnmeldungen für Spezialberechtigungen unterdrückt.

-----

## 👤 Autor & Kontakt

  * **Marcel Gräfen**
  * 📧 [info@mgraefen.com](mailto:info@mgraefen.com)
 
-----

## 🤖 Generierungshinweis

Dieses Projekt wurde mithilfe einer Künstlichen Intelligenz (KI) entwickelt. Die KI hat bei der Erstellung des Skripts, der Kommentare und der Dokumentation (README.md) geholfen. Das endgültige Ergebnis wurde von mir überprüft und angepasst.

-----

## 📜 Lizenz

[MIT Lizenz](https://www.google.com/search?q=LICENSE)
