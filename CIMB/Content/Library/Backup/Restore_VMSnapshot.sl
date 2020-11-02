namespace: Backup
flow:
  name: Restore_VMSnapshot
  inputs:
    - vCenter_Hostname: 172.17.20.25
    - vCenter_Username: ivankuah@vsphere.local
    - vCenter_Password:
        default: Hello123..
        sensitive: true
    - vm_IP: 172.17.30.16
    - snapshot_Name: 'Snapshot_2020-08-17_11:26:18'
  workflow:
    - Get_Virtual_Machine:
        do_external:
          a7b8a2c3-99a3-47a7-99e2-6e6d5988c060:
            - host: '${vCenter_Hostname}'
            - user: '${vCenter_Username}'
            - password:
                value: '${vCenter_Password}'
                sensitive: true
            - closeSession: 'false'
            - vmIdentifierType: IP
            - virtualMachine: '${vm_IP}'
            - getDetailed: 'true'
        publish:
          - vmid: '${returnResult}'
        navigate:
          - success: vCenter_Revert_Snapshot
          - failure: on_failure
          - no more: vCenter_Revert_Snapshot
    - vCenter_Revert_Snapshot:
        do_external:
          42f8973f-c2d1-4e19-afa9-91d3d781e793:
            - vCenterHost: '${vCenter_Hostname}'
            - vCenterUsername: '${vCenter_Username}'
            - vCenterPassword:
                value: '${vCenter_Password}'
                sensitive: true
            - vmIdentifierType: vmid
            - virtualMachine: '${vmid}'
            - snapshotName: '${snapshot_Name}'
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
      Get_Virtual_Machine:
        x: 181
        'y': 213
      vCenter_Revert_Snapshot:
        x: 372
        'y': 215
        navigate:
          7b255bcb-81b6-b309-b571-1942de15969a:
            targetId: 01028cf6-110b-d9d1-99c6-3d6a890ae13d
            port: success
    results:
      SUCCESS:
        01028cf6-110b-d9d1-99c6-3d6a890ae13d:
          x: 541
          'y': 216
