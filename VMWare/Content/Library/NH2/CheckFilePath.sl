namespace: NH2
flow:
  name: CheckFilePath
  workflow:
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
            - source: "${'C:\\\\Temp\\\\Test_'+date+'.xls'}"
        navigate:
          - success: Add_Excel_Data
          - failure: New_Excel_Document
    - New_Excel_Document:
        do_external:
          9d21ca68-7d03-4fb3-9478-03956532bf6f:
            - excelFileName: "${'C:\\\\Temp\\\\Test_'+date+'.xls'}"
            - worksheetNames: Sheet1
            - delimiter: ','
        navigate:
          - failure: on_failure
          - success: Add_Excel_Data
    - Add_Excel_Data:
        do_external:
          4552e495-4595-4916-b58b-ce521bdb1e9a:
            - excelFileName: "${'C:\\\\Temp\\\\Test_'+date+'.xls'}"
            - worksheetName: Sheet1
            - headerData: 'Hostname,IP Address,Snapshot Name'
            - rowData: 'ABCD,172.17.40.88,backup123'
            - columnDelimiter: ','
            - rowsDelimiter: '|'
        navigate:
          - failure: on_failure
          - success: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      FS_Exists:
        x: 136
        'y': 194
      New_Excel_Document:
        x: 324
        'y': 119
      Add_Excel_Data:
        x: 304
        'y': 274
        navigate:
          b452a156-8931-907c-caed-f2d90b47d817:
            targetId: 075e4b63-ad27-0641-736f-0dcad0a91061
            port: success
      get_time:
        x: 8
        'y': 196
    results:
      SUCCESS:
        075e4b63-ad27-0641-736f-0dcad0a91061:
          x: 420
          'y': 251
