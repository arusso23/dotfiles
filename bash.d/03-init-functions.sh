# Profile Init Functions
#
# Utility functions that can be depended on by the rest of the scripts used to
# load the profile.
#
# Functions in this file should start with a colon ':' so they are obvious to
# identify as early-loaded utility functions.

# Given a filepath, prepend it to our PATH if it is not already present.
:prependpath() {
  local path="$1"

  [[ $(:inpath "$path") -eq 0 ]] && return
  PATH="${path}:${PATH}"
}

# Given a filepath, append it to our PATH if it is not already present.
:appendpath() {
  local path="$1"

  [[ $(:inpath "$path") -eq 0 ]] && return
  PATH="${PATH}:${path}"
}

# Given a filepath, return 0 if it is in our PATH and 1 if it is not.
:inpath() {
  local path="${1}"
  [[ ":${PATH}:" == *":${path}:"* ]] && echo 0 || echo 1
}

# Given a binary name, return 0 if it's in our PATH and 1 if it is not
:binexists() {
  local bin="${1}"
  which "$bin" &>/dev/null
  [[ $? -eq 0 ]] && echo 0 || echo 1
}

# Replace an exact path match for another
:replacepath() {
  local orig="${1}"
  local new="${2}"

  PATH="${PATH//$orig/$new}"
}
