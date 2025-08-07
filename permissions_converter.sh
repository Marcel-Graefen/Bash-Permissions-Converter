#!/usr/bin/env bash

# ========================================================================================
# Bash-Permissions Converter
#
# A lean and robust Bash function for converting file permissions between numeric (octal) and symbolic representations.
#
# @author      : Marcel Gräfen
# @version     : 0.0.1
# @date        : 2025-08-07
#
# @requires    : Bash 3.0+
#
# @see         : https://github.com/Marcel-Graefen/Bash-Permissions-Converter
#
# @copyright   : Copyright (c) 2025 Marcel Gräfen
# @license     : MIT License
# ========================================================================================

#----------------------- EXTERNAL GLOBAL VARIABLES --------------------------------------

# PERMISSIONS_NUMERIC   : Numeric permissions for created directories (default: 760)
# PERMISSIONS_SYMBOLIC  : Symbolic permissions for created directories (default: -rwxrw----)
# SHOW_WARNING          : treu or false (default: true)

: "${PERMISSIONS_NUMERIC:=760}"
: "${PERMISSIONS_SYMBOLIC:=-rwxrw----}"
: "${SHOW_WARNING:=return}"

#========================================================================================

# FUNCTION: permconv

# Converts between numeric (octal) and symbolic Unix permission formats.
#
# Arguments:
#   $1 - input permission string, either:
#        - Numeric octal (3 or 4 digits, e.g. 755 or 4755)
#        - Symbolic string (9 characters, e.g. rwxr-xr-x or rwxr-sr-t)
#
# Environment variables:
#   SHOW_WARNING - if set to "true", prints warnings about special bits (setuid, setgid, sticky)
#
# Returns:
#   Prints the converted permission:
#     - If input is numeric, prints symbolic permissions (e.g. -rwxr-xr-x)
#     - If input is symbolic, prints numeric permissions with leading zero (e.g. 0755)
#   Returns 0 on success.
#   Calls error_exit with code 2 on invalid input format.
#   Calls error_exit with code 3 on unexpected errors.
#

permconv() {

  if [[ -z "$1" ]]; then
    echo "❌ ERROR: Not set Parameter"
    exit 1
  fi

  #----------------------

  local input="$1"

  #----------------------

  # Early input validation: only allow octal (3-4 digits) or symbolic (9 chars)
  if ! [[ "$input" =~ ^(0?[0-7]{3,4}|-?[rwxst-]{9})$ ]]; then
    echo "❌ ERROR: Invalid format: '$input'"
    exit 1
  fi

  #----------------------

  # Handle octal input (e.g. 0755 or 4755)
  if [[ "$input" =~ ^0?[0-7]{3,4}$ ]]; then

    local perm="${input: -3}"  # last 3 digits only
    local special=0
    local modes=("---" "--x" "-w-" "-wx" "r--" "r-x" "rw-" "rwx")
    local out=""

    if [[ ${#input} -eq 4 ]]; then
      special="${input:0:1}"
    fi

    for ((i=0; i<3; i++)); do
      local digit="${perm:$i:1}"
      out+="${modes[digit]}"
    done

    if ((special & 4)); then
      [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: setuid active: executable runs with the owner's user ID"
      out="${out:0:2}s${out:3}"
    fi

    if ((special & 2)); then
      [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: setgid active: executable runs with owner's group ID (or directory enforces group inheritance)"
      out="${out:0:5}s${out:6}"
    fi

    if ((special & 1)); then
      [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: sticky bit active: only file owner (or root) can delete or rename files in the directory"
      out="${out:0:8}t"
    fi

    PERMISSIONS_SYMBOLIC="$out"  # Set global variable for symbolic permissions
    return 0
  fi

  #----------------------

  # Handle symbolic input (e.g. rwxr-sr-t or -rw-r--r--)
  if [[ "$input" =~ ^-?[rwxst-]{9}$ ]]; then

    local sym="${input#-}"
    local out=""
    local special=0

    for ((i=0; i<9; i+=3)); do
      local triplet="${sym:$i:3}"
      local val=0

      [[ $triplet == *r* ]] && ((val+=4))
      [[ $triplet == *w* ]] && ((val+=2))
      [[ $triplet == *x* ]] && ((val+=1))

      if [[ ${triplet:2:1} == "s" ]]; then
        if ((i == 0)); then
          ((special+=4))
          [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: setuid detected: executable will run with the file owner's user ID"
        elif ((i == 3)); then
          ((special+=2))
          [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: setgid detected: executable will run with the file owner's group ID (or directory enforces group ownership)"
        fi
        ((val+=1))
      fi

      if [[ ${triplet:2:1} == "t" ]]; then
        ((special+=1))
        [[ "$SHOW_WARNING" != "false" ]] && echo "⚠️ WARNING: sticky bit detected: only file owner can delete or rename files in the directory"
        ((val+=1))
      fi

      out+="$val"
    done

  #----------------------

    PERMISSIONS_NUMERIC="0${special}${out}"  # Set global variable for numeric permissions
    return 0
  fi

}

# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# EXAMPLE


# 1. Numeric (Octal) to Symbolic Conversion
# When you provide a 3 or 4-digit octal number, the function outputs the corresponding symbolic permission string.

# Standard Permissions:

# permconv 755
# echo $PERMISSIONS_SYMBOLIC

# Output: rwxr-xr-x

# Permissions with SetUID:
# The leading `4` sets the `s` bit for the user, which changes the user's execute permission to `s`.

# permconv 4755
# echo $PERMISSIONS_SYMBOLIC

# Output: rwsr-xr-x
 # A warning will also be printed if SHOW_WARNING is not "false".

#ermissions with SetGID:
# The leading `2` sets the `s` bit for the group, changing the group's execute permission to `s`.

# permconv 2755
# echo $PERMISSIONS_SYMBOLIC

# Output: rwxr-sr-x
# A warning will also be printed if SHOW_WARNING is not "false".


# Permissions with Sticky Bit:
# The leading `1` sets the `t` bit for others, changing the other's execute permission to `t`.

# permconv 1755
# echo $PERMISSIONS_SYMBOLIC

# Output: rwxr-x-t
# A warning will also be printed if SHOW_WARNING is not "false".

# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# 2. Symbolic to Numeric (Octal) Conversion**
# When you provide a 9-character symbolic string, the function outputs the corresponding octal number.

# Standard Permissions:

# permconv rwxr-xr-x
# echo $PERMISSIONS_NUMERIC

# Output: 0755


# Permissions with SetUID:
# The `s` in the user's permissions triplet is correctly converted to a `4` in the special permissions digit.

# permconv rwsr-xr-x
# echo $PERMISSIONS_NUMERIC

# Output: 4755
# A warning will also be printed if SHOW_WARNING is not "false".


# Permissions with SetGID:
# The `s` in the group's permissions triplet is correctly converted to a `2` in the special permissions digit.

# permconv rwxr-sr-x
# echo $PERMISSIONS_NUMERIC

# Output: 2755
# A warning will also be printed if SHOW_WARNING is not "false".


# Permissions with Sticky Bit:
# The `t` in the others' permissions triplet is correctly converted to a `1` in the special permissions digit.

# permconv rwxr-xr-t
# echo $PERMISSIONS_NUMERIC

# Output: 1755
# A warning will also be printed if SHOW_WARNING is not "false".


# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# 3. Invalid Inputs (Error Handling)**
# The function will exit and print an error message for invalid inputs.

# Missing Parameter:

# permconv

# Output: ❌ ERROR: Not set Parameter

# Invalid Format (Incorrect characters):

# permconv 888

# Output: ❌ ERROR: Invalid format: '888'

# permconv rwx1r-x-x

# Output: ❌ ERROR: Invalid format: 'rwx1r-x-x'


# Invalid Format (Incorrect length):

# permconv 77

# Output: ❌ ERROR: Invalid format: '77'

# permconv rwxr-x

# Output: ❌ ERROR: Invalid format: 'rwxr-x'
