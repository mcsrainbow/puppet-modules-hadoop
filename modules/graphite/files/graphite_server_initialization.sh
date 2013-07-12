#!/bin/bash 
#File Managed by Puppet

function check_graphite()
{
    PROG_HOME="/opt/graphite"
    if [ ! -d $PROG_HOME ]; then
        echo "$PROG_HOME does not exist."
        exit 0
    fi
}

function init_db()
{
    check_graphite

    DB_FILE="/opt/graphite/storage/graphite.db"
    if [ -f $DB_FILE ]; then
        echo "$DB_FILE already exist."
        exit 0
    else 
        echo "Sync the database"
        sudo python manage.py syncdb
    fi
}

function start_services()
{
    echo "Chown the graphite"
    sudo chown -R apache:apache /opt/graphite
    
    echo "Restart the httpd"
    sudo /etc/init.d/httpd restart
    
    echo "Start the carbon-cache.py"
    sudo /opt/graphite/bin/carbon-cache.py start
}

function create_django_user()
{
    echo "Create a default Django superuser"
    sudo python manage.py createsuperuser --username=admin
}

init_db
start_services
