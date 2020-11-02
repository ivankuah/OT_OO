namespace: Create_Snapshot
flow:
  name: Create_Snapshot
  inputs:
    - password: Nh2vcpa$$
  workflow:
    - vCenter_Create_Snapshot:
        do_external:
          ef19d4c1-167f-4462-b689-416ce8e78cc0:
            - vCenterHost: 172.17.20.25
            - vCenterUsername: administrator@vsphere.local
            - vCenterPassword:
                value: '${password}'
                sensitive: true
            - vmIdentifierType: IP
            - virtualMachine: 172.17.40.88
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      vCenter_Create_Snapshot:
        x: 233
        'y': 236
        navigate:
          839cf2f4-495a-d63c-04d2-74bc5c01fdc0:
            targetId: a57907ea-12ed-b9cb-dee9-2652bc234cd5
            port: success
    results:
      SUCCESS:
        a57907ea-12ed-b9cb-dee9-2652bc234cd5:
          x: 398
          'y': 203
