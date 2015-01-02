{%- from 'graphite/settings.sls' import graphite with context %}

{%- if graphite.dbtype == 'mysql' %}

include:
  - graphite
  - mysql.client
  - mysql.server

install-deps:
  pkg.installed:
    - names:
      - python-mysqldb
      - mysql-client-core-5.5
      - mysql-client-5.5
      # - mysql-server

create-graphite-database:
  cmd.run:
    - name: mysqladmin create {{ graphite.dbname }}
    - unless: test -d /var/lib/mysql/{{ graphite.dbname }}

setup-graphite-user:
  cmd.wait:
    - name: mysql -e "grant all on {{ graphite.dbname }}.* to {{ graphite.dbuser }}@localhost identified by '{{ graphite.dbpassword }}'"
    - watch:
      - cmd: create-graphite-database
    - watch_in:
      - cmd: flushprivileges-mysqld-after-setup
      - cmd: initialize-graphite-db

flushprivileges-mysqld-after-setup:
  cmd.wait:
    - name: mysqladmin flush-privileges

initialize-graphite-db:
  cmd.wait:
    - cwd: {{ graphite.prefix }}/webapp/graphite
    - name:  python manage.py syncdb --noinput

restart-supervisord-graphite:
  cmd.wait:
    - name: service supervisord restart
    - watch:
      - cmd: initialize-graphite-db
{%- endif %}