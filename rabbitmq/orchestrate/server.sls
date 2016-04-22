rabbitmq_state:
  salt.state:
    - tgt: 'G@roles:rabbitmq.server and not G@roles:rabbitmq.cluster'
    - tgt_type: compound
    - sls: rabbitmq

