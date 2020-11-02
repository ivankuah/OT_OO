namespace: NH2
flow:
  name: CreateSnapshot
  inputs:
    - vcenterhost: 172.17.20.25
    - vcenterpassword:
        default: Nh2vcpa$$
        sensitive: true
    - vcenteruser: administrator@vsphere.local
    - excelfile: "c:\\\\Temp\\\\ServerList.xls"
    - vm_ip: IP Address
  workflow:
    - Get_Cell:
        do_external:
          5060d8cc-d03c-43fe-946f-7babaaec589f:
            - excelFileName: '${excelfile}'
            - worksheetName: Sheet1
            - vm_ip: '${vm_ip}'
        publish:
          - data: '${returnResult}'
          - vm_ip_index: '${str(header.split(",").index(vm_ip))}'
        navigate:
          - failure: on_failure
          - success: GetVMID
    - GetVMID:
        loop:
          for: 'row in data.split("|")'
          do:
            NH2.GetVMID:
              - vcenterhost: '${vcenterhost}'
              - vcenteruser: '${vcenteruser}'
              - vcenterpassword:
                  value: '${vcenterpassword}'
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
        x: 65
        'y': 231
      GetVMID:
        x: 225
        'y': 190
        navigate:
          730186ad-936b-ad15-a620-bc0ec415aff8:
            targetId: 05db0175-4300-4291-534d-72554eec32b6
            port: SUCCESS
    results:
      SUCCESS:
        05db0175-4300-4291-534d-72554eec32b6:
          x: 379
          'y': 131
