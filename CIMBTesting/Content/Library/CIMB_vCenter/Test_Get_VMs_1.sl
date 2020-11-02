namespace: CIMB_vCenter
flow:
  name: Test_Get_VMs_1
  inputs:
    - vCenter_Host
    - vCenter_Username
    - vCenter_Password:
        sensitive: true
    - saServerIdentifier
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
            - closeSession: 'false'
            - vmIdentifierType: hostname
            - virtualMachine: '${saServerName}'
            - getDetailed: 'true'
        publish:
          - vmID: '${returnResult}'
          - serverName: '${virtualMachine}'
          - vmName: '${name}'
        navigate:
          - success: vCenter_Create_Snapshot
          - failure: on_failure
          - no more: vCenter_Create_Snapshot
    - vCenter_Create_Snapshot:
        do_external:
          ef19d4c1-167f-4462-b689-416ce8e78cc0:
            - vCenterHost: '${vCenter_Host}'
            - vCenterUsername: '${vCenter_Username}'
            - vCenterPassword:
                value: '${vCenter_Password}'
                sensitive: true
            - vmIdentifierType: vmid
            - virtualMachine: '${vmID}'
        publish:
          - snapshotName
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
        x: 120
        'y': 193
      vCenter_Create_Snapshot:
        x: 303
        'y': 183
        navigate:
          da3ddfa1-62ab-132c-2d6c-da10fa74116a:
            targetId: bb3593a3-6301-b53c-2666-bdf6edd9a109
            port: success
    results:
      SUCCESS:
        bb3593a3-6301-b53c-2666-bdf6edd9a109:
          x: 430
          'y': 196
