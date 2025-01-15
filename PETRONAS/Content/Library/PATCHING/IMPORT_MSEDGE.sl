namespace: PATCHING
flow:
  name: IMPORT_MSEDGE
  inputs:
    - SACoreHost:
        default: 172.17.30.20
        required: false
    - SACoreUsername:
        default: admin
        required: false
    - SACorePassword:
        default: nh2123
        required: false
        sensitive: true
    - SAPatchPolicyName:
        default: '[Daily] Microsoft Edge Patch Policy'
        required: false
    - SAPatchName:
        default: Edge
        required: false
  workflow:
    - Get_SA_Version:
        do_external:
          ad34fe78-8d93-44ef-aa79-dfd37b70e83c:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
        publish:
          - saCoreVersion: '${coreVersion}'
        navigate:
          - success: Remove_Patches_from_Patch_Policy
          - failure: FAILURE
    - Remove_Patches_from_Patch_Policy:
        do_external:
          3c691256-81bc-40c7-a161-93d846737659:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - patchPolicyName: '${SAPatchPolicyName}'
        publish:
          - removePatchResult: '${returnResult}'
        navigate:
          - success: Get_Windows_Patch_VOs
          - failure: FAILURE
    - Get_Windows_Patch_VOs:
        do_external:
          f424bf9d-dd6d-4341-9cac-2ce99844be71:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - patchName: '${SAPatchName}'
        publish:
          - saPatchId: '${id}'
        navigate:
          - success: IMPORT_PATCH
          - failure: FAILURE
    - IMPORT_PATCH:
        loop:
          for: add_patch in saPatchId
          do:
            PATCHING.IMPORT_PATCH:
              - SACoreHost: '${SACoreHost}'
              - SACoreUsername: '${SACoreUsername}'
              - SACorePassword:
                  value: '${SACorePassword}'
                  sensitive: true
              - SACoreVersion: '${saCoreVersion}'
              - SAPatchID: '${add_patch}'
              - SAPatchPolicyName: '${SAPatchPolicyName}'
          break:
            - FAILURE
          publish:
            - patchCreatedDate
            - compareDateResult
            - addPatchResult
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_SA_Version:
        x: 280
        'y': 200
        navigate:
          c65492d2-b04a-b03f-1499-d680d91e20bf:
            targetId: a8066fb8-cde3-d405-dc04-15a91434933a
            port: failure
      Remove_Patches_from_Patch_Policy:
        x: 440
        'y': 200
        navigate:
          60a7c2b6-16e9-8955-01e2-b496194f5446:
            targetId: a8066fb8-cde3-d405-dc04-15a91434933a
            port: failure
      Get_Windows_Patch_VOs:
        x: 640
        'y': 200
        navigate:
          f03de816-56e2-0af9-5e41-921ee8bbbfb5:
            targetId: a8066fb8-cde3-d405-dc04-15a91434933a
            port: failure
      IMPORT_PATCH:
        x: 640
        'y': 400
        navigate:
          148242fb-d0f4-8a4c-3e2e-196710efb669:
            targetId: a8066fb8-cde3-d405-dc04-15a91434933a
            port: FAILURE
          e355c625-867e-3d6b-c3b2-a282274b87c0:
            targetId: 07ee266e-0775-09a1-2417-1d52076eff41
            port: SUCCESS
    results:
      FAILURE:
        a8066fb8-cde3-d405-dc04-15a91434933a:
          x: 280
          'y': 400
      SUCCESS:
        07ee266e-0775-09a1-2417-1d52076eff41:
          x: 840
          'y': 280
