#!/bin/bash
export DBT_TARGET='sso'
use="n"
if [ $DBT_USR ]; then
  echo "Current user:" $DBT_USR
  echo "Do you still want to use the current user? Y/n"
  read  use
  echo ""
  use=${use:-y}
fi

if [ $use = 'n' ]; then
  echo "Username:"
  read username
  export DBT_USR=$username
fi


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
  echo "Here is script you can run in snowflake:"
  echo ""
  echo "create or replace database $COMMONS_DB clone $prod_db;"
  echo "grant usage on database $COMMONS_DB to role "$prod_db"_loader;"
  echo "grant usage on database $COMMONS_DB to role "$prod_db"_transformer;"
  echo "grant usage on database $COMMONS_DB to role "$prod_db"_reporter;"
fi
