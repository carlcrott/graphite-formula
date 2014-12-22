========
graphite
========

Formula to set up and configure graphite servers on Debian and RedHat systems

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.


Configuring
================
Option A: Manually place formulas ::

    mkdir -p /srv/formulas/ # Default formula dir
    cd /srv/formulas
    git clone git@github.com:carlcrott/graphite-formula.git

Edit minion and master files to search for formulas in above directory ::

    # /etc/salt/master and /etc/salt/minion
    file_roots:
      base:
        - /srv/salt
        - /srv/formulas/graphite-formula

Create grain for 'roles' and set to 'monitor_master' ::

    # /srv/salt/monitor_master_grain.sls
    roles:
      grains.present:
        - value: monitor_master


Add graphite and "monitor_master" grain to top.sls ::

    # /srv/salt/top.sls
    base:
      'awesome-monitor-node':
        - monitor_master_grain
        - graphite



Configure pillar topfile ::

    # /srv/pillar/top.sls
    base:
      '*-monitor':
        - graphite

Place graphite pillar ::

    cp /graphite-formula/pillar.example  /srv/pillar/graphite.sls



Option B: Reference formulas with GitFS:

outlined in detail here:
http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#adding-a-formula-as-a-gitfs-remote


Starting Service
================

Setup database if not already done ::

    python /opt/graphite/webapp/graphite/manage.py syncdb

Start graphite ::

    /opt/graphite/bin/run-graphite-devel-server.py /opt/graphite &

Generating a new password
==========================

Uses the `Passlib library <http://pythonhosted.org/passlib/>`_ ::

    pip install passlib
    
Then make::

    python -c "from passlib.hash import pbkdf2_sha256; import getpass, pwd; print pbkdf2_sha256.encrypt(getpass.getpass())"
    Password: [ENTER YOUR PASSWORD HERE]


Available states
================

.. contents::
    :local:

``graphite``
------------

Installs all dependencies and the graphite packages themselves, sets up a minimal system including 
supervisor to run carbon and django and nginx as the proxy.

``graphite.supervisor``
-----------------------

Adds a basic supervisor configuration for the graphite daemons to work on top of.
The graphite state already depends on this one internally - eventually there should be a supervisor-formula.

``graphite.mysqldb``
--------------------

Depends on the mysql-formula's mysql.client and mysql.server, makes the graphite server use mysql
for the admin login.

Please note that this is a very basic (and monolithic) formula, not necessarily intended for production use.
