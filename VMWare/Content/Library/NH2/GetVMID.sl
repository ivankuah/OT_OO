namespace: NH2
flow:
  name: GetVMID
  inputs:
    - vcenterhost: 172.17.40.100
    - vcenteruser: ivankuah@vsphere.local
    - vcenterpassword:
        default: Hello123..
        sensitive: true
    - vmip: 172.17.30.16
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
            - virtualMachine: '${vmip}'
            - getDetailed: 'true'
        publish:
          - vmid: '${returnResult}'
          - vmName: '${name}'
          - vmIP: '${virtualMachine}'
        navigate:
          - success: vCenter_Create_Snapshot
          - failure: on_failure
          - no more: vCenter_Create_Snapshot
    - vCenter_Create_Snapshot:
        do_external:
          ef19d4c1-167f-4462-b689-416ce8e78cc0:
            - vCenterHost: '${vcenterhost}'
            - vCenterUsername: '${vcenteruser}'
            - vCenterPassword:
                value: '${vcenterpassword}'
                sensitive: true
            - vmIdentifierType: vmid
            - virtualMachine: '${vmid}'
        publish:
          - snapshotName
        navigate:
          - success: get_time
          - failure: on_failure
    - Add_Excel_Data:
        do_external:
          4552e495-4595-4916-b58b-ce521bdb1e9a:
            - excelFileName: "${'C:\\\\Temp\\\\SnapshotInfo_'+date+'.xls'}"
            - worksheetName: Sheet1
            - headerData: 'Hostname,IP Address,Snapshot Name'
            - rowData: "${vmName+','+vmIP+','+snapshotName}"
            - columnDelimiter: ','
            - rowsDelimiter: '|'
            - overwriteData: 'false'
        navigate:
          - failure: on_failure
          - success: SUCCESS
    - New_Excel_Document:
        do_external:
          9d21ca68-7d03-4fb3-9478-03956532bf6f:
            - excelFileName: "${'C:\\\\Temp\\\\SnapshotInfo_'+date+'.xls'}"
            - worksheetNames: Sheet1
            - delimiter: ','
        navigate:
          - failure: on_failure
          - success: Add_Excel_Data
    - FS_Exists:
        do_external:
          87e6ebad-dd89-4519-83f1-f1573f237d21:
            - source: "${'C:\\\\Temp\\\\SnapshotInfo_'+date+'.xls'}"
        navigate:
          - success: Add_Excel_Data
          - failure: New_Excel_Document
    - get_time:
        do:
          io.cloudslang.base.datetime.get_time:
            - timezone: '+8'
            - date_format: yyyyMMdd
        publish:
          - date: '${output}'
        navigate:
          - SUCCESS: FS_Exists
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Virtual_Machine:
        x: 44
        'y': 166
      vCenter_Create_Snapshot:
        x: 211
        'y': 163
      Add_Excel_Data:
        x: 633
        'y': 216
        navigate:
          9885831f-dab9-95aa-5a65-9c28851a4ba3:
            targetId: 4a75dc6d-f8fa-5f3f-b167-53354da5f0ae
            port: success
      New_Excel_Document:
        x: 627
        'y': 59
      FS_Exists:
        x: 442
        'y': 171
      get_time:
        x: 326
        'y': 163
    results:
      SUCCESS:
        4a75dc6d-f8fa-5f3f-b167-53354da5f0ae:
          x: 633
          'y': 364
