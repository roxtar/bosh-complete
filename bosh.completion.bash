#!/usr/bin/env bash
# Bash completion support for bosh.

export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}
export BOSHCOMPLETE_CONFIG_DIR=$HOME/.boshcomplete
mkdir -p $BOSHCOMPLETE_CONFIG_DIR
cp commands.txt $BOSHCOMPLETE_CONFIG_DIR

_boshcomplete() {
   cur=${COMP_WORDS[COMP_CWORD]}
   prev=${COMP_WORDS[1]}
   COMPREPLY=()
   case ${COMP_CWORD} in
     1)
       IFS=';'
       COMMANDS=$(cat $BOSHCOMPLETE_CONFIG_DIR/commands.txt)
       for COMMAND in $COMMANDS; do
         if [[ $COMMAND =~ ^$cur ]]; then
           COMPREPLY+=($COMMAND)
         fi
       done
       ;;
     *)
       IFS=';'
       COMMANDS=$(cat $BOSHCOMPLETE_CONFIG_DIR/commands.txt)
       for COMMAND in $COMMANDS; do
         if [[ $COMMAND =~ ^$prev ]]; then
           SUB_COMMAND=$(echo $COMMAND | awk -v i=$COMP_CWORD '{print $i;}')
           if [[ $SUB_COMMAND =~ ^$cur ]]; then
             COMPREPLY+=($SUB_COMMAND)
           fi
         fi
       done
       ;;
   esac
   return 0
}

complete -o default -o nospace -F _boshcomplete bosh

