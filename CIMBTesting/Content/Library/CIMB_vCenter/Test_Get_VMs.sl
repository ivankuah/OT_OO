namespace: CIMB_vCenter
flow:
  name: Test_Get_VMs
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
          - success: get_time
          - failure: on_failure
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
    - FS_Exists:
        do_external:
          87e6ebad-dd89-4519-83f1-f1573f237d21:
            - source: "${'C:\\\\Temp\\\\SnapshotInfo_'+date+'.xls'}"
        navigate:
          - success: Add_Excel_Data
          - failure: New_Excel_Document
    - New_Excel_Document:
        do_external:
          9d21ca68-7d03-4fb3-9478-03956532bf6f:
            - excelFileName: "${'C:\\\\Temp\\\\SnapshotInfo_'+date+'.xls'}"
            - worksheetNames: Sheet1
            - delimiter: ','
        navigate:
          - failure: on_failure
          - success: Add_Excel_Data
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
        'y': 182
      get_time:
        x: 436
        'y': 185
      FS_Exists:
        x: 594
        'y': 192
      New_Excel_Document:
        x: 743
        'y': 138
      Add_Excel_Data:
        x: 744
        'y': 284
        navigate:
          0c9aeec4-ddc8-d3ac-f074-8db277191b16:
            targetId: bb3593a3-6301-b53c-2666-bdf6edd9a109
            port: success
    results:
      SUCCESS:
        bb3593a3-6301-b53c-2666-bdf6edd9a109:
          x: 747
          'y': 423
