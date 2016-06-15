=========================
RabbitMQ messaging system
=========================

RabbitMQ is a complete and highly reliable enterprise messaging system based on the emerging AMQP standard.

Sample pillars
==============

Standalone Broker
-----------------

RabbitMQ as AMQP broker with admin user and vhosts

.. code-block:: yaml

    rabbitmq:
      server:
        enabled: true
        bind:
          address: 0.0.0.0
          port: 5672
        secret_key: rabbit_master_cookie
        admin:
          name: adminuser
          password: pwd
        plugins:
        - amqp_client
        - rabbitmq_management
        virtual_hosts:
        - enabled: true
          host: '/monitor'
          user: 'monitor'
          password: 'password'

RabbitMQ as a Stomp broker

.. code-block:: yaml

    rabbitmq:
      server:
        enabled: true
        secret_key: rabbit_master_cookie
        bind:
          address: 0.0.0.0
          port: 5672
        virtual_hosts:
        - enabled: true
          host: '/monitor'
          user: 'monitor'
          password: 'password'
        plugins:
        - rabbitmq_stomp

RabbitMQ cluster
----------------

RabbitMQ as base cluster node

.. code-block:: yaml

    rabbitmq:
      server:
        enabled: true
        bind:
          address: 0.0.0.0
          port: 5672
        secret_key: rabbit_master_cookie
        admin:
          name: adminuser
          password: pwd
      cluster:
        enabled: true
        role: master
        mode: disc
        members:
        - name: openstack1
          host: 10.10.10.212
        - name: openstack2
          host: 10.10.10.213

HA Queues definition

.. code-block:: yaml

    rabbitmq:
      server:
        enabled: true
        ...
        virtual_hosts:
        - enabled: true
          host: '/monitor'
          user: 'monitor'
          password: 'password'
          policies:
          - name: HA
            pattern: '^(?!amq\.).*' 
            definition: '{"ha-mode": "all"}'

Usage
=====

Check cluster status, example shows running cluster with 3 nodes: ctl-1, ctl-2, ctl-3

.. code-block:: yaml

    > rabbitmqctl cluster_status
    
    Cluster status of node 'rabbit@ctl-1' ...
    [{nodes,[{disc,['rabbit@ctl-1','rabbit@ctl-2','rabbit@ctl-3']}]}, 
     {running_nodes,['rabbit@ctl-3','rabbit@ctl-2','rabbit@ctl-1']},
     {partitions,[]}]
    ...done.

Setup management user.

.. code-block:: yaml

    > rabbitmqctl add_vhost vhost
    > rabbitmqctl add_user user alive
    > rabbitmqctl set_permissions -p vhost user ".*" ".*" ".*"
    > rabbitmqctl set_user_tags user management

EPD process is Erlang Port Mapper Daemon. It's a feature of the Erlang runtime that helps Erlang nodes to find each other. It's a pretty tiny thing and doesn't contain much state (other than "what Erlang nodes are running on this system?") so it's not a huge deal for it to still be running.
Although it's running as user rabbitmq, it was started automatically by the Erlang VM when we started. We've considered adding "epmd -kill" to our shutdown script - but that would break any other Erlang apps running on the system; it's more "global" than RabbitMQ.

Read more
=========

* http://www.rabbitmq.com/admin-guide.html
* https://github.com/saltstack/salt-contrib/blob/master/states/rabbitmq_plugins.py
* http://docs.saltstack.com/ref/states/all/salt.states.rabbitmq_user.html
* http://stackoverflow.com/questions/14699873/how-to-reset-user-for-rabbitmq-management
* http://www.rabbitmq.com/memory.html

Clustering
==========

* http://www.rabbitmq.com/clustering.html#auto-config
* https://github.com/jesusaurus/hpcs-salt-state/tree/master/rabbitmq
* http://gigisayfan.blogspot.cz/2012/06/rabbit-mq-clustering-python-fabric.html
* http://docwiki.cisco.com/wiki/OpenStack_Havana_Release:_High-Availability_Manual_Deployment_Guide#RabbitMQ_Installation
