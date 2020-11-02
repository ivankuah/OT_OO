namespace: CIMB_vCenter
flow:
  name: CreateSnapshot
  inputs:
    - vCenter_Host
    - vCenter_Username
    - vCenter_Password:
        sensitive: true
    - saServerName
  workflow:
    - Get_Virtual_Machine:
        do_external:
          a7b8a2c3-99a3-47a7-99e2-6e6d5988c060:
            - host: '${vCenter_Host}'
            - user: '${vCenter_Username}'
            - password:
                value: '${vCenter_Password}'
                sensitive: true
            - closeSession: 'true'
            - vmIdentifierType: hostname
            - virtualMachine: '${saServerName}'
            - getDetailed: 'true'
        publish:
          - vmID: '${returnResult}'
        navigate:
          - success: Create_Snapshot
          - failure: on_failure
          - no more: Create_Snapshot
    - Create_Snapshot:
        do_external:
          9021d4cf-5310-471c-a27d-9beed95043ec:
            - host: '${vCenter_Host}'
            - user: '${vCenter_Username}'
            - password:
                value: '${vCenter_Password}'
                sensitive: true
            - closeSession: 'true'
            - async: 'true'
            - vmIdentifierType: vmid
            - virtualMachine: '${vmID}'
            - snapshotName: Snapshot
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Virtual_Machine:
        x: 83
        'y': 170
      Create_Snapshot:
        x: 253
        'y': 164
        navigate:
          cbe531c8-5036-c817-4dd7-cbc43c0d0430:
            targetId: 072206de-5f55-d863-6e96-ef7b15543dfd
            port: success
    results:
      SUCCESS:
        072206de-5f55-d863-6e96-ef7b15543dfd:
          x: 437
          'y': 164
