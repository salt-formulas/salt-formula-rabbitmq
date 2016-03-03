salt_rabbitmq_cluster_master:
  salt.state:
    - tgt: 'G@roles:rabbitmq.cluster and I@rabbitmq:cluster:role:master'
    - tgt_type: compound
    - sls: rabbitmq

salt_rabbitmq_cluster_slave:
  salt.state:
    - tgt: 'G@roles:rabbitmq.cluster and I@rabbitmq:cluster:role:slave'
    - tgt_type: compound
    - sls: rabbitmq
    - require:
      - salt: salt_rabbitmq_cluster_master

