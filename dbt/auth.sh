#!/bin/bash
export DBT_TARGET='sso'

if [[ -z ${DBT_USR+x} ]]; then
  echo "Username:"
  read username
  export DBT_USR=$username
fi

echo "Current user:" $DBT_USR

use="n"
if [ $COMMONS_DB ]; then
  echo "Current DB:" $COMMONS_DB
  echo "Do you still want use the current database? Y/n"
  read use
  echo ""
  use=${use:-y}
fi

prod_db=commons

if [[ -z ${COMMONS_DB+x} || $use = 'n' ]]; then
  echo "Choose a database:"
  select db in $prod_db dev_"$USER"_"$prod_db" other; do
    break;
  done
  if [ $db = 'other' ]; then
    echo Database:
    read db
    echo ""
  fi
  export COMMONS_DB=$db
fi

recreate_db=n
if [ $COMMONS_DB != $prod_db ]; then
  echo "Do you want to create / recreate the database: $COMMONS_DB? y/N"
  read recreate_db
  echo ""
  recreate_db=${recreate_db:-n}
fi

if [ $recreate_db = 'y' ]; then
  snowbird clone $prod_db $COMMONS_DB --usage "$prod_db"_transformer
fi
