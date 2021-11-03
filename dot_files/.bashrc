# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export PATH="/usr/bin:$PATH";

# when shell exits, append to history file, don't overwrite
shopt -s histappend
# save and reload history after each command finishes.
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

function colorize()
{
  if [[ $# -lt 2 ]]; then
    echo "$1";
    return 0;
  fi;

  TEXT_IN="$1";
  shift; # now only color arguments should remain
  BUILD_STR="\[\e[";
  BUILD_STR="${BUILD_STR}$1"; # length is at least 2
  shift; # get rid of that color
  for color in "$@"; do
    BUILD_STR="${BUILD_STR};${color}";
    #echo "new build str: ${BUILD_STR}";
  done;
  BUILD_STR="${BUILD_STR}m\]${TEXT_IN}\[\e[0m\]";
  #echo "final build str: ${BUILD_STR}";
  #echo -e "Returning: ${BUILD_STR}";
  echo "${BUILD_STR}";
}

# \001 == \[
# \033 == \e
# \002 == \]
COL_OPEN_BRACK="$(colorize '[' 91)"; # \[\e[91m\][\[\e[0m\]";
COL_CLOSE_BRACK="$(colorize ']' 91)";
COL_OPEN_BRACE="$(colorize '{' 35 1)";
COL_CLOSE_BRACE="$(colorize '}' 35 1)";
COL_BAR="$(colorize '|' 91)";
COL_AT="$(colorize '@' 91)";
COL_DATE="$(colorize '\t' 32 4)";
# include time in standard bash line
COL_USER="$(colorize '\u' 93)";
COL_HOST="$(colorize '\h' 93)";
COL_DIR="$(colorize '\W' 34)";
END_CHAR='\$';
export PS1="${COL_OPEN_BRACK}${COL_OPEN_BRACE}${COL_DATE}${COL_CLOSE_BRACE} ${COL_BAR} ${COL_USER}${COL_AT}${COL_HOST} ${COL_DIR}${COL_CLOSE_BRACK}${END_CHAR} ";
unset COL_OPEN_BRACK;
unset COL_CLOSE_BRACK;
unset COL_OPEN_BRACE;
unset COL_CLOSE_BRACE;
unset COL_BAR;
unset COL_AT;
unset COL_DATE;
unset COL_USER;
unset COL_HOST;
unset COL_DIR;
unset END_CHAR;
# 91 is a light red
# 35 is like a purple-ish
# 93 is a yellow
# 94 is light blue
# 34 is blue
# 32 for green
# 44 for blue background
# 4 for underlined


# infinite command history
HISTCONTROL=
HISTSIZE=
HISTFILESIZE=
HISTTIMEFORMAT="%y-%m-%d %T "



# User specific aliases and functions
alias lm='ls -lrt';
alias lk='ls -lrtah';
alias ll='ls -l';
alias la='ls -a';
alias lrt='ls -lrt';
alias l='ls';

alias v='vim';
alias vimr='vim -R';
alias vr='vim -R';
# readonly vim, keeps syntax highlighting (unlike 'view' cmd). use if know that file is already opened in another vim process.

alias c='clear';
alias d='date';
# alias mv='mv -iv'; # ask before overwrite and be verbose
# alias rm='rm -iv'; # ask before every remove and be verbose

# git aliases
alias gst='git status';
alias gcho='git checkout';
alias gbr='git branch';
alias gdiff='git diff';
alias gadd='git add';


# takes filenames as input and moves them to apped just
# a .bkp on the end. If that somehow exists, will also append
# current datetime to that file.
# Optionally, a directory where to put them may be given with
# -o DIRECTORY as the first 2 arguments.
function bkp()
{
  BKP_DIR="$(pwd)";
  if [[ $1 == "-o" ]]; then
    if [ -d "$2" ]; then
      BKP_DIR="$2"
    else
      echo "DIRECTORY $2 does not exist. Skipping..." >&2;
    fi
    shift;
    shift;
  fi
  for filename in "$@"; do
    newfilename="${BKP_DIR}/${filename}.bkp";
    if [ -e "${newfilename}" ]; then
      newfilename="${newfilename}.$(date +%F-%H-%M-%S-%N)";
    fi
    echo mv "${filename}" "${newfilename}";
  done
}


export RECYCLE_BIN_DIR="${HOME}/.recycle_bin";
mkdir -p "$RECYCLE_BIN_DIR";

function recyc()
{
  for fullname in "$@"; do
    filename="$(basename "$fullname")";
    if [ -e "$RECYCLE_BIN_DIR/$filename" ]; then
      newfilename="$filename.$(date +%F-%H-%M-%S-%N)";
      mv "$fullname" "$RECYCLE_BIN_DIR/$newfilename";
      echo "File \"$filename\" already in recycle bin. Renamed to $newfilename";
    else
      mv "$fullname" "$RECYCLE_BIN_DIR/$filename";
    fi
  done
}

# calls function recyc - "safe" delete
alias rms='recyc';
alias rmf='rm -f';

alias cd-="cd -";

# extra grep aliases
alias igrep='grep -i';
alias egrep='grep -E';
alias eigrep='grep -Ei';

# open gui calculator
alias calc='gnome-calculator'
alias binview='xxd -b'
alias hexview='xxd'
alias hexview2='od -xc'

# local bashrc stuff to not commit to repo
NOCOMMIT_BASHRC="${HOME}/.nocommit.bashrc";
if [ -f "${NOCOMMIT_BASHRC}" ]; then
  . "${NOCOMMIT_BASHRC}";
fi

# make it clearly known if users SSH into us
if [ "${SSH_CONNECTION}" != "" ]; then
  SSH_CLIENT_IP="$(echo "${SSH_CONNECTION}" | sed 's/ .*//')";
  SSH_SERVER_IP="$(echo "${SSH_CONNECTION}" | sed 's/.*.* \(.*\) .*/\1/')";
  PS1="[SSH:${SSH_CLIENT_IP}->${SSH_SERVER_IP}] $PS1";
fi

# conprehensive apt update
alias myupdate='sudo apt update -y && sudo apt upgrade -y && sudo apt update -y && sudo apt autoremove';

# mvn aliases
alias mci='mvn clean install';
alias mcint='mvn -Dmaven.test.skip=true clean install';
alias mct='mvn clean test';
alias mcc='mvn clean compile';
alias mccti='mvn clean compile test install';

alias openpdf='evince';


# default browser command - opens mozilla firefox browser
function goog()
{
  readonly DEF_BROWSER="firefox";
  readonly GOOGLE_URL="https://www.google.com";
  readonly BASE_URL="${GOOGLE_URL}/search?q=";
  if [[ "$#" -lt 1 ]]; then
    "$DEF_BROWSER" "${GOOGLE_URL}";
  else
    "$DEF_BROWSER" "${BASE_URL}$1";
  fi
  unset GOOGLE_URL;
  unset BASE_URL;
}

