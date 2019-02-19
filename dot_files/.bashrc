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
COL_HOST="$(colorize '\h' 94)";
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
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%y-%m-%d %T "

export NIFI_HOME="\${HOME}/Libraries/nifi/nifi-1.3.0/nifi-assembly/target/nifi-1.3.0-bin/nifi-1.3.0";
export JAVA_HOME='/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-0.el7_5.x86_64'
export MVN_HOME='';
export BOOST_HOME="${HOME}/Libraries/cpp/boost/src/boost";
export GTEST_DIR="${HOME}/Downloads/googletest";
export ECLIPSE_HOME="${HOME}/Libraries/cpp/eclipse/cpp-photon/eclipse";
# export ECLIPSE_HOME="${HOME}/Libraries/cpp/eclipse/java-oxygen/eclipse";

path_arr=("${NIFI_HOME}" "${JAVA_HOME}" "${MVN_HOME}" "$HOME/Libraries/VSCode-linux-x64/bin" "/usr/local/bin" \
  "$HOME/Libraries/node-v10.15.1-linux-x64/bin" "${JAVA_HOME}/bin" "${HOME}/Libraries/maven/apache-maven-3.5.4/bin" \
  "${HOME}/Libraries/cpp/cmake/bin" "${HOME}/Libaries/cpp/qt_stuff/Qt/5.11.1/gcc_64/bin" "$ECLIPSE_HOME"
)
lib_path_arr=("/usr/include" "${GTEST_DIR}/include" "${HOME}/Libraries/cpp/qt_stuff/Qt/5.11.1/Src/qtbase/include/QtWidgets" \
  "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-3.b13.el7_5.x86_64/include" "$HOME/Downloads/gcc-8.2.0/libstdc++-v3/include/std" \
  "$HOME/Downloads/gcc-8.2.0/x86_64-pc-linux-gnu/libstdc++-v3/include" "/usr/local/lib/../lib64" "$HOME/Libraries/cpp/boost/src/boost/lib" "/usr/include/gtkmm-3.0"
)

for _path in "${path_arr[@]}"; do
  if [ -d "${_path}" ]; then
    PATH="${PATH}:${_path}";
  fi
done
export PATH
for _path in "${lib_path_arr[@]}"; do
  if [ -d "${_path}" ]; then
    LIBRARY_PATH="${LIBRARY_PATH}:${_path}";
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${_path}";
  fi
done
export LIBRARY_PATH
export LD_LIBRARY_PATH


export WINDOWS_MNT_DIR='/mnt/windows';
alias mntwindows="sudo mkdir \${WINDOWS_MNT_DIR} && sudo ntfs-3g /dev/nvme0n1p3 \${WINDOWS_MNT_DIR}";
# User specific aliases and functions
alias lm='ls -lrth';
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
alias mv='mv -iv'; # ask before overwrite and be verbose
alias rm='rm -iv'; # ask before every remove and be verbose

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
mkdir -p "$RECYCLE_BIN_DIR"; # make dir if it doesn't already exist

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

# alias java7='/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.191-2.6.15.4.el7_5.x86_64/jre/bin/java';
# alias javac7='/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.191-2.6.15.4.el7_5.x86_64/bin/javac';
# alias j11='$HOME/Libraries/java/jdk-11/bin/java';
# alias jc11='$HOME/Libraries/java/jdk-11/bin/javac';
# export PATH_TO_FX='$HOME/Libraries/java/javafx-sdk-11/lib';
alias fxmledit="\${HOME}/Libraries/java/JavaFXSceneBuilder2.0/JavaFXSceneBuilder2.0";

# open gui calculator
alias calc='gnome-calculator'
alias binview='xxd -b'
alias hexview='xxd'
alias hexview2='od -xc'

# alias mygpp="g++ -isystem \${GTEST_DIR}/include -std=c++11 -Wall -Wextra -pthread -I/home/skilgore/src/boost/include -L/home/skilgore/src/boost/lib -lboost_log -lboost_chrono -lboost_atomic -lboost_thread -lboost_date_time -lboost_filesystem -lboost_system -lboost_regex \$GTEST_DIR/libgtest.a";
# -Wswitch-enum
# -Wunsafe-loop-optmization
# -Waggregate-return
# -pedantic-errors
# -Wformat-y2k
# -Wimplicit -Wimport -Winline
# -Wpacked

# -Weffc++ \
  # -fdiagnostics-show-option
# use -Wno-error=<err_type/warn type> with -Werror to disable erroring out on
# that particular warning type
alias mygpp='g++ -std=c++17 -Wall -Wextra -pedantic -Wunused-parameter -Wunused -pthread -Wnoexcept -Wshadow'
alias boostgpp='g++ -std=c++17 -Wall -Wconversion -Wextra -Wunused-parameter -Wunused -Wnoexcept -Wshadow -pedantic -pthread -I$GTEST_DIR/include -I/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-3.b13.el7_5.x86_64/include -L/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-3.b13.el7_5.x86_64/include -lboost_log -lboost_chrono -lboost_atomic -lboost_thread -lboost_date_time -lboost_filesystem -lboost_system -lboost_regex'

alias igrep='grep -i';
# mvn aliases
alias mci='mvn clean install';
alias mcint='mvn -Dmaven.test.skip=true clean install';
alias mct='mvn clean test';
alias mcc='mvn clean compile';
alias mccti='mvn clean compile test install';

alias openpdf='evince';

# alias qmake='/home/skilgore/Qt/5.11.1/gcc_64/bin/qmake';


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

# function searpr()
# {
# for proc_name in "$@"; do
# procs="$(ps aux | grep -i "$proc_name")";
# retVal="$procs";
# if [ "$proc_name" != "grep" ]; then
# retVal="$(echo "$procs" | grep -v grep)";
# fi
# echo "$retVal";
# done;
# }

function resetgit()
{
  printf "Deleting all identities (or type CTRL-C)...\n";
  SLEEP_TIME_S=1.0;
  sleep ${SLEEP_TIME_S};
  ssh-add -D; # deletes all identities
  ssh-add -l;
  printf "Look okay? Continuing in %s sec...\n" "${SLEEP_TIME_S}";
  sleep ${SLEEP_TIME_S};
  eval "$(ssh-agent -s)";
  ssh-add -l;
  ssh-add;
  ssh-add -l;
  printf "Done!\n";
  unset SLEEP_TIME_S;
}

# # starting eclim server if not already started
# if [[ ! $(pgrep -fa eclim) ]]; then
# # echo "Starting eclimd...";
# $ECLIPSE_HOME/eclimd > /dev/null 2>&1 &
# #if [[ $(pgrep -fa eclim) ]]; then
# # echo "eclimd start successful...";
# #else
# # echo "eclimd failed to start...";
# #fi;
# fi;


