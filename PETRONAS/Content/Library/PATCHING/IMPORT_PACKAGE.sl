namespace: PATCHING
flow:
  name: IMPORT_PACKAGE
  inputs:
    - SACoreHost:
        default: 172.19.2.140
        required: false
    - SACoreUsername:
        default: ivankuah
        required: false
    - SACorePassword:
        default: Ironman123..
        required: false
        sensitive: true
    - SASoftwarePolicyName:
        default: 7zip
        required: false
    - SAOSUsername:
        default: ivankuah
        required: false
    - SAOSPassword:
        default: Ironman123..
        sensitive: true
    - SoftwareMajorVersion: '24'
    - SoftwareName: 7zip
  workflow:
    - Get_Software_Full_Version:
        do_external:
          0b066b79-d65c-4da9-8ed4-edf50f378950:
            - host: '${SACoreHost}'
            - username: '${SAOSUsername}'
            - password:
                value: '${SAOSPassword}'
                sensitive: true
            - knownHostsPolicy: allow
            - command: "${'sudo curl --silent http://repo.nh2system.com/' + SoftwareName + '/server/'+ SoftwareMajorVersion + '/ | grep -oE \">[0-9.]+\" | cut -c 2-8 | sort -nr | head -n 1'}"
        publish:
          - fullSoftwareVersion: "${cs_replace(cs_replace(returnResult,\"\\n\",\"\"),\" \",\"\")}"
        navigate:
          - success: Get_Installer
          - failure: FAILURE
    - Get_Installer:
        do_external:
          0b066b79-d65c-4da9-8ed4-edf50f378950:
            - host: '${SACoreHost}'
            - username: '${SAOSUsername}'
            - password:
                value: '${SAOSPassword}'
                sensitive: true
            - knownHostsPolicy: allow
            - command: "${'sudo curl --silent http://repo.nh2system.com/' + SoftwareName + '/server/'+ SoftwareMajorVersion + '/' + fullSoftwareVersion +  '/ | grep -ioE \">[a-zA-Z0-9\\./\\-]+.(msi|exe)\" | cut -c 2-50'}"
        publish:
          - softwareInstallerName: "${cs_replace(cs_replace(returnResult,\"\\n\",\"\"),\" \",\"\")}"
        navigate:
          - success: Get_SA_Version
          - failure: FAILURE
    - Download_Installer:
        do_external:
          0b066b79-d65c-4da9-8ed4-edf50f378950:
            - host: '${SACoreHost}'
            - username: '${SAOSUsername}'
            - password:
                value: '${SAOSPassword}'
                sensitive: true
            - knownHostsPolicy: allow
            - command: "${'sudo curl --silent --create-dirs -o /var/opt/opsware/word/' + SoftwareName + '/' + softwareInstallerName + ' http://repo.nh2system.com/' + SoftwareName + '/server/'+ SoftwareMajorVersion + '/' + fullSoftwareVersion +  '/' + softwareInstallerName}"
            - input_0: null
        publish:
          - downloadResult: '${returnResult}'
        navigate:
          - success: Import_Software
          - failure: FAILURE
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
          - success: Get_Software_Policy_Items
          - failure: FAILURE
    - Get_Software_Policy_Items:
        do_external:
          2b806bb7-5f63-4d98-a5f6-fd47703f7925:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - policyName: '${SASoftwarePolicyName}'
            - itemType: UNIT
        publish:
          - swItemName: '${itemName}'
          - switemId: '${itemId}'
        navigate:
          - success: Get_Unit_VOs
          - failure: FAILURE
    - Get_Unit_VOs:
        do_external:
          15aa115d-c0ed-4712-982d-eeb7365fe456:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - unitIDs: '${switemId}'
        publish:
          - oldUnitFileName: '${unitFileName}'
          - oldUnitType: '${unitType}'
          - oldUnitName: '${name}'
        navigate:
          - success: String_Comparator
          - failure: FAILURE
    - String_Comparator:
        do_external:
          f1dafb35-6463-4a1b-8f87-8aa748497bed:
            - matchType: Exact Match
            - toMatch: '${softwareInstallerName}'
            - matchTo: '${oldUnitFileName}'
            - ignoreCase: 'false'
        publish:
          - unitCompareResult: '${returnResult}'
        navigate:
          - success: SUCCESS
          - failure: Download_Installer
    - Import_Software:
        do_external:
          0b066b79-d65c-4da9-8ed4-edf50f378950:
            - host: '${SACoreHost}'
            - username: '${SAOSUsername}'
            - password:
                value: '${SAOSPassword}'
                sensitive: true
            - knownHostsPolicy: allow
            - command: "${'sudo /opt/opsware/software_import/software_import.sh ' + SoftwareName + ' /var/opt/opsware/word/' + SoftwareName + '/' + softwareInstallerName + ' ' + oldUnitType + ' ' + fullSoftwareVersion}"
        publish:
          - importResult: "${cs_replace(cs_replace(returnResult,\"\\n\",\"\"),\" \",\"\")}"
        navigate:
          - success: Get_Unit_VOs_1
          - failure: FAILURE
    - Get_Unit_VOs_1:
        do_external:
          15aa115d-c0ed-4712-982d-eeb7365fe456:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - unitNames: "${'7-Zip ' + fullSoftwareVersion}"
        publish:
          - newUnitFileName: '${unitFileName}'
          - newUnitType: '${unitType}'
          - newUnitName: '${name}'
        navigate:
          - success: Remove_Item_from_Software_Policy
          - failure: FAILURE
    - Remove_Item_from_Software_Policy:
        do_external:
          ad5f0eeb-3e57-47a6-bd93-1cd9b08f68ba:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - policyName: '${SASoftwarePolicyName}'
            - itemName: '${oldUnitName}'
            - itemType: UNIT
        publish:
          - removeItemResult: '${returnResult}'
        navigate:
          - success: Add_Item_to_Software_Policy
          - failure: FAILURE
    - Add_Item_to_Software_Policy:
        do_external:
          3d1bbd20-d90c-4cfc-9151-e0cd56b63477:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - policyName: '${SASoftwarePolicyName}'
            - itemName: '${newUnitName}'
            - itemType: UNIT
        publish:
          - addItemResult: '${returnResult}'
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Import_Software:
        x: 320
        'y': 520
        navigate:
          103407e4-81e6-1a34-52ba-4fc63c22ad3c:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      Get_Software_Policy_Items:
        x: 560
        'y': 120
        navigate:
          21126fd8-a70d-5e4d-0597-0b45828842ea:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      String_Comparator:
        x: 560
        'y': 440
        navigate:
          a1f7960e-1581-4b17-694f-c5c8c30a9d1c:
            targetId: 332fb5a1-2249-0be2-c68a-7ad2cad0281e
            port: success
      Remove_Item_from_Software_Policy:
        x: 680
        'y': 600
        navigate:
          2f67290f-f9ed-9400-edea-d86f96d59a6e:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      Get_Unit_VOs:
        x: 560
        'y': 280
        navigate:
          3138d015-ff65-66e6-b521-a7fe66dc677c:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      Get_SA_Version:
        x: 440
        'y': 120
        navigate:
          b0954979-05b3-b06d-e563-f1995b4e3e6f:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      Download_Installer:
        x: 320
        'y': 360
        navigate:
          2d8cc09e-c073-6933-0861-77407e21d18e:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      Add_Item_to_Software_Policy:
        x: 840
        'y': 520
        navigate:
          e243e2c0-540f-c1b8-3030-547501acde29:
            targetId: 332fb5a1-2249-0be2-c68a-7ad2cad0281e
            port: success
          1511a6b0-e121-0fb3-b2d1-b93149fa033e:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      Get_Software_Full_Version:
        x: 160
        'y': 120
        navigate:
          4bed2d87-0445-c3b1-98fa-73bcacaf66a7:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      Get_Unit_VOs_1:
        x: 520
        'y': 600
        navigate:
          1b7562af-34c3-6eed-0dc3-9f99b6779273:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
      Get_Installer:
        x: 320
        'y': 120
        navigate:
          acc1b079-380e-8549-16d3-277161a3b49d:
            targetId: a80732c4-819f-1e8f-fac2-b9c32647b06f
            port: failure
    results:
      SUCCESS:
        332fb5a1-2249-0be2-c68a-7ad2cad0281e:
          x: 800
          'y': 360
      FAILURE:
        a80732c4-819f-1e8f-fac2-b9c32647b06f:
          x: 160
          'y': 280
