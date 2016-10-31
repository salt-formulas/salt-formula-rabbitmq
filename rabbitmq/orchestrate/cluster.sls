rabbitmq.cluster.master:
  salt.state:
    - tgt: 'rabbitmq:cluster:role:master'
    - tgt_type: pillar
    - queue: True
    - sls: rabbitmq

rabbitmq.cluster.slave:
  salt.state:
    - tgt: 'rabbitmq:cluster:role:slave'
    - tgt_type: pillar
    - queue: True
    - sls: rabbitmq
    - batch: 1
    - require:
      - salt: rabbitmq.cluster.master

