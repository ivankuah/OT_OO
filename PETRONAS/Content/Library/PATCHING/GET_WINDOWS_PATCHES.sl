namespace: PATCHING
flow:
  name: GET_WINDOWS_PATCHES
  inputs:
    - SACoreHost: 172.17.30.20
    - SACoreUsername: admin
    - SACorePassword: nh2123
    - SAPatchName: Edge
  workflow:
    - Get_Windows_Patch_VOs:
        do_external:
          f424bf9d-dd6d-4341-9cac-2ce99844be71:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: sas241
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Get_Windows_Patch_VOs:
        x: 280
        'y': 240
        navigate:
          a4c1960e-1db5-8839-0996-c2b42d9b175e:
            targetId: 78bc0c72-2c9a-8e93-75ca-a54c9d7aa129
            port: failure
          c6f5f41e-a14f-e761-1d8f-72f7136e1338:
            targetId: 9636550f-6873-58a6-4c7f-7cc18051bf1a
            port: success
    results:
      SUCCESS:
        9636550f-6873-58a6-4c7f-7cc18051bf1a:
          x: 520
          'y': 240
      FAILURE:
        78bc0c72-2c9a-8e93-75ca-a54c9d7aa129:
          x: 280
          'y': 480
