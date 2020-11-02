namespace: NH2
flow:
  name: RollbackSnapshot
  inputs:
    - vcenterhost: 172.17.20.25
    - vcenteruser: administrator@vsphere.local
    - vcenterpassword:
        default: Nh2vcpa$$
        sensitive: true
    - vm_ip: 172.17.40.88
    - snapshotname: 'Snapshot_2020-06-24_23:15:04'
  workflow:
    - Get_Virtual_Machine:
        do_external:
          a7b8a2c3-99a3-47a7-99e2-6e6d5988c060:
            - host: '${vcenterhost}'
            - user: '${vcenteruser}'
            - password:
                value: '${vcenterpassword}'
                sensitive: true
            - closeSession: 'false'
            - vmIdentifierType: IP
            - virtualMachine: '${vm_ip}'
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
            - vCenterHost: '${vcenterhost}'
            - vCenterUsername: '${vcenteruser}'
            - vCenterPassword:
                value: '${vcenterpassword}'
                sensitive: true
            - vmIdentifierType: vmid
            - virtualMachine: '${vmid}'
            - snapshotName: '${snapshotname}'
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
        x: 133
        'y': 214
      vCenter_Revert_Snapshot:
        x: 315
        'y': 215
        navigate:
          7ee2edec-ecec-f546-b0dc-7ccadef8d6c2:
            targetId: be7608e3-37ad-b8fd-556e-bf90ec408bda
            port: success
    results:
      SUCCESS:
        be7608e3-37ad-b8fd-556e-bf90ec408bda:
          x: 315
          'y': 377
