namespace: CIMB_vCenter
flow:
  name: Test_Create_VMSnapshot
  inputs:
    - vCenter_Hostname: 172.17.20.25
    - vCenter_Username: ivankuah@vsphere.local
    - vCenter_Password:
        default: Hello123..
        sensitive: true
    - vm_ip:
        default: IP Address
        required: false
    - excelFile_Path:
        default: "c:\\\\Temp\\\\ServerList.xls"
        required: false
  workflow:
    - Get_Cell:
        do_external:
          5060d8cc-d03c-43fe-946f-7babaaec589f:
            - excelFileName: '${ServerIdentifier}'
            - worksheetName: Sheet1
            - vm_ip: '${vm_ip}'
        publish:
          - data: '${returnResult}'
          - vm_ip_index: '${str(header.split(",").index(vm_ip))}'
        navigate:
          - failure: on_failure
          - success: Get_VMs
    - Get_VMs:
        loop:
          for: 'row in data.split("|")'
          do:
            Backup.Get_VMs:
              - vCenter_Host: '${vCenter_Hostname}'
              - vCenter_Username: '${vCenter_Username}'
              - vCenter_Password:
                  value: '${vCenter_Password}'
                  sensitive: true
              - vmip: '${row.split(",")[int(vm_ip_index)]}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Cell:
        x: 219
        'y': 252
      Get_VMs:
        x: 357
        'y': 251
        navigate:
          0efc0d73-b014-768e-0507-e80358601055:
            targetId: 7cb20b64-7593-d518-bd01-70a39706b53c
            port: SUCCESS
    results:
      SUCCESS:
        7cb20b64-7593-d518-bd01-70a39706b53c:
          x: 498
          'y': 253
