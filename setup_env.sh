#!/bin/bash

source .venv/bin/activate

dependency_diff=$(comm -23 requirements-lock.txt <( pip freeze))

if [ $dependency_diff ]; then
  make install
fi

#DBT
. ./dbt/auth.sh

#Snowbird
. ./infrastructure/auth.sh

code .
