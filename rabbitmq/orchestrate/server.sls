rabbitmq.server:
  salt.state:
    - tgt: 'I@rabbitmq:server and not I@rabbitmq:cluster'
    - tgt_type: compound
    - sls: rabbitmq

