# 📋 Bash Permissions Converter

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/Marcel-Graefen/Bash-Permissions-Converter/releases/tag/0.1.0)
[![German](https://img.shields.io/badge/Language-German-blue)](./README.de.md)
![GitHub last commit](https://img.shields.io/github/last-commit/Marcel-Graefen/Bash-INI-Parser)
[![Author](https://img.shields.io/badge/author-Marcel%20Gr%C3%A4fen-green.svg)](#-author--contact)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

A lean and robust Bash function for converting file permissions between numeric (octal) and symbolic representations.

-----

## 🚀 Table of Contents

  * [📋 Features](https://www.google.com/search?q=%23-features)
  * [⚙️ Prerequisites](https://www.google.com/search?q=%23%25EF%25B8%258F-prerequisites)
  * [🚀 Usage](https://www.google.com/search?q=%23-usage)
    * [Examples](https://www.google.com/search?q=%23-examples)
  * [📌 API Reference](https://www.google.com/search?q=%23-api-reference)
    * [`permconv`](https://www.google.com/search?q=%23permconv)
    * [`Global Variables Used`](https://www.google.com/search?q=%23global-variables-used)
  * [👤 Author & Contact](https://www.google.com/search?q=%23-author-and-contact)
  * [🤖 Generation Note](https://www.google.com/search?q=%23-generation-note)
  * [📜 License](https://www.google.com/search?q=%23-license)

-----

## 📋 Features

  * **Bidirectional Conversion:** Converts permissions from numeric to symbolic and vice versa.
  * **Special Permissions Support:** Correctly handles `setuid`, `setgid`, and the sticky bit.
  * **Input Validation:** Automatically checks if the input has a valid format.
  * **Helpful Warnings:** Outputs warning messages when special permissions are detected.
  * **Easy Integration:** The function is designed to be easily incorporated into existing Bash scripts.

-----

## ⚙️ Prerequisites

  * **Bash** version 3.0 or higher.

-----

## 🚀 Usage

The `permconv` function is best included in your script and then called with the desired permission string. The result is stored in a global variable.

### Examples

**1. Numeric (Octal) to Symbolic**

Converts the permission `755` to `rwxr-xr-x` and stores it in the `PERMISSIONS_SYMBOLIC` variable.

```bash
#!/usr/bin/env bash

# Function call
permconv 755

# Output the resulting variable
echo "Symbolic permission: $PERMISSIONS_SYMBOLIC"
# Output: rwxr-xr-x
```

**2. Symbolic to Numeric (Octal)**

Converts the permission `rwsr-xr-x` (with setuid) to `4755` and stores it in `PERMISSIONS_NUMERIC`.

```bash
#!/usr/bin/env bash

# Presets
SHOW_WARNING="true"

# Function call
permconv rwsr-xr-x

# Output the resulting variable
echo "Numeric permission: $PERMISSIONS_NUMERIC"
# Output: 4755
# Console: "⚠️ WARNING: setuid detected: executable will run with the file owner's user ID"
```

**3. Invalid Input**

Invalid inputs will result in an error message and exit the script.

```bash
#!/usr/bin/env bash

# Function call with invalid input
permconv rwx1r-x-x

# Output:
# ❌ ERROR: Invalid format: 'rwx1r-x-x'
# The script will exit at this point.
```

-----

## 📌 API Reference

### `permconv`

Converts permissions between numeric and symbolic representations. The function requires one argument.

**Syntax:**

```bash
permconv <permission_string>
```

  * `$1`: A permission string in the format `[0-7]{3,4}` (numeric) or `[-][rwxst-]{9}` (symbolic).

### Global Variables Used

The function sets the following global variables:

  * **`PERMISSIONS_NUMERIC`**: Contains the numeric permission if a symbolic input was converted.
  * **`PERMISSIONS_SYMBOLIC`**: Contains the symbolic permission if a numeric input was converted.
  * **`SHOW_WARNING`**: An optional variable. If set to `"false"`, warning messages for special permissions will be suppressed.

-----

## 👤 Author & Contact

  * **Marcel Gräfen**
  * 📧 [info@mgraefen.com](mailto:info@mgraefen.com)
 
-----

## 🤖 Generation Note

This project was developed with the help of Artificial Intelligence (AI). The AI assisted in creating the script, comments, and documentation (`README.md`). The final result was reviewed and adjusted by me.

-----

## 📜 License

[MIT License](https://www.google.com/search?q=LICENSE)
