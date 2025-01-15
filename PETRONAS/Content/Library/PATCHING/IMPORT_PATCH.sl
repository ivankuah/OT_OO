namespace: PATCHING
flow:
  name: IMPORT_PATCH
  inputs:
    - SACoreHost:
        required: false
    - SACoreUsername:
        required: false
    - SACorePassword:
        required: false
        sensitive: true
    - SACoreVersion:
        required: false
    - SAPatchID:
        required: false
    - SAPatchPolicyName:
        required: false
  workflow:
    - Get_Windows_Patch_VOs:
        do_external:
          f424bf9d-dd6d-4341-9cac-2ce99844be71:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${SACoreVersion}'
        publish:
          - createdDate
        navigate:
          - success: Get_Current_Date_and_Time
          - failure: FAILURE
    - Get_Current_Date_and_Time:
        do_external:
          237a5c37-ecbc-4ef1-af37-034e6f7e8f62: []
        publish:
          - currentDate: "${cs_regex(returnResult,\"[a-zA-Z]{3,}\\\\s.*?,\\\\s20\\\\d\\\\d\")}"
        navigate:
          - success: Time_Zone_Converter
          - failure: FAILURE
    - Time_Zone_Converter:
        do_external:
          7955d9b8-a184-457d-8450-8e196e943045:
            - date: '${createdDate}'
            - dateTimeZone: UTC
            - outTimeZone: Asia/Kuala_Lumpur
        publish:
          - patchCreatedDate: "${cs_regex(returnResult,\"[a-zA-Z]{3,}\\\\s.*?,\\\\s20\\\\d\\\\d\")}"
        navigate:
          - success: String_Comparator
          - failure: FAILURE
    - String_Comparator:
        do_external:
          f1dafb35-6463-4a1b-8f87-8aa748497bed:
            - matchType: Exact Match
            - toMatch: '${patchCreatedDate}'
            - matchTo: '${createdDate}'
            - ignoreCase: 'false'
        publish:
          - compareDateResult: '${returnResult}'
        navigate:
          - success: Add_Patches_to_Patch_Policy
          - failure: SUCCESS
    - Add_Patches_to_Patch_Policy:
        do_external:
          1b7e29d8-c348-4b0d-911a-7adb4c9d50c2:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${SACoreVersion}'
            - patchPolicyName: '${SAPatchPolicyName}'
            - patchID: '${SAPatchID}'
        publish:
          - addPatchResult: '${returnResult}'
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  outputs:
    - patchCreatedDate: '${patchCreatedDate}'
    - compareDateResult: '${compareDateResult}'
    - addPatchResult: '${addPatchResult}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Windows_Patch_VOs:
        x: 240
        'y': 240
        navigate:
          b2137013-afa9-73e8-21ee-4d1765f0c604:
            targetId: 0fce4b33-85ed-6ebf-2300-7bfd10222b55
            port: failure
      Get_Current_Date_and_Time:
        x: 400
        'y': 240
        navigate:
          7b110e3c-edde-7d81-80ac-8e42fcc5e828:
            targetId: 0fce4b33-85ed-6ebf-2300-7bfd10222b55
            port: failure
      Time_Zone_Converter:
        x: 560
        'y': 240
        navigate:
          88710e75-1173-3bae-e4c4-782884d9af9d:
            targetId: 0fce4b33-85ed-6ebf-2300-7bfd10222b55
            port: failure
      String_Comparator:
        x: 720
        'y': 240
        navigate:
          4b161b1c-bee9-35bf-0aa6-f18e5b8176f0:
            targetId: 6ee75a74-7166-1727-7306-59443ac457a2
            port: failure
      Add_Patches_to_Patch_Policy:
        x: 840
        'y': 440
        navigate:
          76c3bb59-9b02-8b62-39d9-a2a535389700:
            targetId: 6ee75a74-7166-1727-7306-59443ac457a2
            port: success
          83e0a341-fe10-007e-1ae9-35133df6eab9:
            targetId: 0fce4b33-85ed-6ebf-2300-7bfd10222b55
            port: failure
    results:
      FAILURE:
        0fce4b33-85ed-6ebf-2300-7bfd10222b55:
          x: 320
          'y': 440
      SUCCESS:
        6ee75a74-7166-1727-7306-59443ac457a2:
          x: 920
          'y': 240
