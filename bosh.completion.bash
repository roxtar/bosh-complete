#!/usr/bin/env bash
# Bash completion support for cf.

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
           COMPREPLY+=( "${COMMAND//___/ }" )
         fi
       done
       ;;
#     *)
#       COMMANDS=$(cf $prev --help | grep -A100 OPTIONS | grep -v OPTIONS| awk '{print $1;}')
#       SPACE_GUID=$(cat ~/.cf/config.json  | jq -r .SpaceFields.Guid)
#       APP_FILE=$HOME/.cfcomplete/$SPACE_GUID.txt
#       if [[ ! -e $APP_FILE ]]; then
#         cf curl /v2/spaces/$SPACE_GUID/summary | jq -r ".apps[] | .name" > $APP_FILE
#       fi
#       APPS=$(cat $APP_FILE)
#       COMPREPLY=($( compgen -W "$COMMANDS $APPS" -- $cur ))
#       ;;
   esac
   return 0
}

complete -o default -o nospace -F _boshcomplete bosh

