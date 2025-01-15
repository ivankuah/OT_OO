namespace: PATCHING
flow:
  name: SCHEDULE_REMEDIATION
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
    - SADeviceGroupName:
        required: false
    - ticketID: "${'MS Edge Patching For ' + SADeviceGroupName}"
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
          - success: Get_Patches_in_Patch_Policy
          - failure: FAILURE
    - Get_Patches_in_Patch_Policy:
        do_external:
          f70c56bf-d595-4100-96e3-c4c0a52ff6a4:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - patchPolicyName: '${SAPatchPolicyName}'
        publish:
          - patchResult: "${'[PATCH FOUND]' + returnResult}"
        navigate:
          - success: String_Comparator
          - failure: String_Comparator
    - String_Comparator:
        do_external:
          f1dafb35-6463-4a1b-8f87-8aa748497bed:
            - matchType: Contains
            - toMatch: '${patchResult}'
            - matchTo: No patches found
            - ignoreCase: 'false'
        navigate:
          - success: SUCCESS
          - failure: Remediate_Device_Group_For_Patch_Policies
    - Remediate_Device_Group_For_Patch_Policies:
        do_external:
          beecb6ae-cef9-42b3-9e50-82a243b1ecca:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - deviceGroupName: '${SADeviceGroupName}'
            - patchPolicies: '${SAPatchPolicyName}'
            - rebootOption: suppress
            - ticketID: '${ticketID}'
        publish:
          - scheduleResult: '${returnResult}'
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_SA_Version:
        x: 320
        'y': 120
        navigate:
          96720c75-9418-e367-1720-5396d2b04786:
            targetId: d2dad7f3-26e6-4982-7b9b-b75d6672ea79
            port: failure
      Get_Patches_in_Patch_Policy:
        x: 640
        'y': 120
      String_Comparator:
        x: 760
        'y': 280
        navigate:
          88a0fe38-9edf-b58f-ca5e-7a7b545e2f3f:
            targetId: 49e07a07-e3a7-ef00-8576-d5e025ccdf1b
            port: success
      Remediate_Device_Group_For_Patch_Policies:
        x: 760
        'y': 480
        navigate:
          446b1202-9f0c-3784-0619-6e2c81966c27:
            targetId: 49e07a07-e3a7-ef00-8576-d5e025ccdf1b
            port: success
          550b3529-5069-d7e8-3084-3b8c324c7683:
            targetId: d2dad7f3-26e6-4982-7b9b-b75d6672ea79
            port: failure
    results:
      FAILURE:
        d2dad7f3-26e6-4982-7b9b-b75d6672ea79:
          x: 320
          'y': 480
      SUCCESS:
        49e07a07-e3a7-ef00-8576-d5e025ccdf1b:
          x: 960
          'y': 320
