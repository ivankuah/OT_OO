namespace: Rollback_Snapshot
flow:
  name: Rollback_Snapshot
  inputs:
    - password: Nh2vcpa$$
  workflow:
    - vCenter_Revert_Snapshot:
        do_external:
          42f8973f-c2d1-4e19-afa9-91d3d781e793:
            - vCenterHost: 172.17.20.25
            - vCenterUsername: administrator@vsphere.local
            - vCenterPassword:
                value: '${password}'
                sensitive: true
            - vmIdentifierType: name
            - virtualMachine: testrhelvm-Ivan/KZ
            - snapshotName: 'Snapshot_2020-06-24_19:10:20'
            - shouldPowerOn: 'true'
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      vCenter_Revert_Snapshot:
        x: 193
        'y': 226
        navigate:
          604b989a-7c92-a7aa-22fe-c2a3d149bc64:
            targetId: 056e1845-790c-84c1-334f-3e95b86143df
            port: success
    results:
      SUCCESS:
        056e1845-790c-84c1-334f-3e95b86143df:
          x: 596
          'y': 213
