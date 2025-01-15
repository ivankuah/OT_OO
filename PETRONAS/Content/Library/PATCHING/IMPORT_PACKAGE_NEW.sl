namespace: PATCHING
flow:
  name: IMPORT_PACKAGE_NEW
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
        default: Wireshark
        required: false
    - SAOSUsername:
        default: ivankuah
        required: false
    - SAOSPassword:
        default: Ironman123..
        sensitive: true
    - SoftwareMajorVersion: '4'
    - SoftwareName: wireshark
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
          - success: Get_Software_Version
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
    - Get_Unit_VOs_1:
        do_external:
          15aa115d-c0ed-4712-982d-eeb7365fe456:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - unitNames: '${softwareInstallerName}'
        publish:
          - newUnitFileName: '${unitFileName}'
          - newUnitType: '${unitType}'
          - newUnitName: '${name}'
        navigate:
          - success: Compare_UnitType
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
          - changeInstallFlags: '${returnResult}'
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
    - Get_Software_Version:
        do_external:
          006298d0-cf5b-4f5a-87d6-c88727b795fb:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - sourceCode: "${'sudo curl --silent http://repo.nh2system.com/' + SoftwareName + '/server/'+ SoftwareMajorVersion + '/ | grep -oE \">[0-9.]+\" | cut -c 2-8 | sort -nr | head -n 1'}"
            - sourceCodeType: SH
            - serverNames: SA_CORE24-2
        publish:
          - returnResult
          - jobId
          - returnCode
        navigate:
          - success: Sleep_1
          - failure: FAILURE
    - Is_Get_Software_Version_Job_Completed:
        do_external:
          b9969b26-65f6-49a1-87aa-06d18f28e2ef:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobID: '${jobId}'
        publish:
          - status
        navigate:
          - running: Sleep_1
          - completed: Get_Software_Version_Result
          - failure: FAILURE
    - Get_Software_Version_Result:
        do_external:
          53605fd8-3656-47f7-8839-57580a0b791f:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobId: '${jobId}'
        publish:
          - fullSoftwareVersion: "${cs_replace(cs_replace(output,\"\\n\",\"\"),\" \",\"\")}"
        navigate:
          - success: Get_Installer
          - failure: FAILURE
    - Get_Installer:
        do_external:
          006298d0-cf5b-4f5a-87d6-c88727b795fb:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - sourceCode: "${'sudo curl --silent http://repo.nh2system.com/' + SoftwareName + '/server/'+ SoftwareMajorVersion + '/' + fullSoftwareVersion +  '/ | grep -ioE \">[a-zA-Z0-9\\./\\-]+.(msi|exe)\" | cut -c 2-50'}"
            - sourceCodeType: SH
            - serverNames: SA_CORE24-2
        publish:
          - returnResult
          - jobId
          - returnCode
        navigate:
          - success: Sleep_2
          - failure: FAILURE
    - Is_Get_Installer_Job_Completed:
        do_external:
          b9969b26-65f6-49a1-87aa-06d18f28e2ef:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobID: '${jobId}'
        publish:
          - status
        navigate:
          - running: Sleep_2
          - completed: Get_Installer_Result
          - failure: FAILURE
    - Get_Installer_Result:
        do_external:
          53605fd8-3656-47f7-8839-57580a0b791f:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobId: '${jobId}'
        publish:
          - softwareInstallerName: "${cs_replace(cs_replace(output,\"\\n\",\"\"),\" \",\"\")}"
        navigate:
          - success: Get_Software_Policy_Items
          - failure: FAILURE
    - Download_Installer:
        do_external:
          006298d0-cf5b-4f5a-87d6-c88727b795fb:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - sourceCode: "${'sudo curl --silent --create-dirs -o /var/opt/opsware/word/' + SoftwareName + '/' + softwareInstallerName + ' http://repo.nh2system.com/' + SoftwareName + '/server/'+ SoftwareMajorVersion + '/' + fullSoftwareVersion +  '/' + softwareInstallerName}"
            - sourceCodeType: SH
            - serverNames: SA_CORE24-2
        publish:
          - returnResult
          - jobId
          - returnCode
        navigate:
          - success: Sleep_3
          - failure: FAILURE
    - Is_Download_Installer_Job_Completed:
        do_external:
          b9969b26-65f6-49a1-87aa-06d18f28e2ef:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobID: '${jobId}'
        publish:
          - status
        navigate:
          - running: Sleep_3
          - completed: Download_Installer_Result
          - failure: FAILURE
    - Download_Installer_Result:
        do_external:
          53605fd8-3656-47f7-8839-57580a0b791f:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobId: '${jobId}'
        publish: []
        navigate:
          - success: Import_Software
          - failure: FAILURE
    - Import_Software:
        do_external:
          006298d0-cf5b-4f5a-87d6-c88727b795fb:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - sourceCode: "${'sudo /opt/opsware/software_import/software_import.sh ' + SoftwareName + ' /var/opt/opsware/word/' + SoftwareName + '/' + softwareInstallerName + ' ' + oldUnitType + ' ' + fullSoftwareVersion}"
            - sourceCodeType: SH
            - serverNames: SA_CORE24-2
        publish:
          - returnResult
          - jobId
          - returnCode
        navigate:
          - success: Sleep
          - failure: FAILURE
    - Sleep_1:
        do_external:
          d1bbf441-824a-450e-afae-2ddec0e0f35e:
            - seconds: '2'
        navigate:
          - success: Is_Get_Software_Version_Job_Completed
          - failure: FAILURE
    - Sleep_2:
        do_external:
          d1bbf441-824a-450e-afae-2ddec0e0f35e:
            - seconds: '10'
        navigate:
          - success: Is_Get_Installer_Job_Completed
          - failure: FAILURE
    - Sleep_3:
        do_external:
          d1bbf441-824a-450e-afae-2ddec0e0f35e:
            - seconds: '10'
        navigate:
          - success: Is_Download_Installer_Job_Completed
          - failure: FAILURE
    - Is_Import_Software_Job_Completed:
        do_external:
          b9969b26-65f6-49a1-87aa-06d18f28e2ef:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobID: '${jobId}'
        publish:
          - status
        navigate:
          - running: Sleep
          - completed: Get_Unit_VOs_1
          - failure: FAILURE
    - Sleep:
        do_external:
          d1bbf441-824a-450e-afae-2ddec0e0f35e:
            - seconds: '10'
        navigate:
          - success: Is_Import_Software_Job_Completed
          - failure: FAILURE
    - Compare_UnitType:
        do_external:
          f1dafb35-6463-4a1b-8f87-8aa748497bed:
            - matchType: Exact Match
            - toMatch: '${newUnitType}'
            - matchTo: EXE
            - ignoreCase: 'true'
        publish:
          - compareUnitType: '${returnResult}'
        navigate:
          - success: Change_InstallFlags
          - failure: Remove_Item_from_Software_Policy
    - Change_InstallFlags:
        do_external:
          006298d0-cf5b-4f5a-87d6-c88727b795fb:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - sourceCode: |-
                import sys
                from pytwist import *
                from pytwist.com.opsware.search import Filter
                from pytwist.com.opsware.pkg import ExecutableVO
                from pytwist.com.opsware.pkg import InstallInfo

                # Check for the command-line argument.
                if len(sys.argv) < 2:
                        print("You must specify package name as the search target.")
                #       print("Example: " + sys.argv[0] + " " + ".exe")
                        sys.exit(2)

                # Construct a search filter.
                filter = Filter()
                filter.expression = 'name = "%s" ' % (sys.argv[1])

                # Create a TwistServer object.
                ts = twistserver.TwistServer()

                # Get a reference to ServerService.
                packageService = ts.pkg.ExecutableService

                # Perform the search, returning a tuple of references.
                packages = packageService.findExecutableRefs(filter)

                if len(packages) < 1:
                        print("No matching package found")
                        sys.exit(3)

                # For each server found, get the server’s value object (VO)
                # and print some of the VO’s attributes.
                #desc = 'change this 2222'
                command = 'start /wait "Wireshark" "%EXE_FULL_NAME%" /S'
                vo = ExecutableVO()
                vo.installInfo = InstallInfo()
                #vo.description = desc
                vo.installInfo.installFlags = command

                for package in packages:
                        packageService.update(package, vo, 1, 0)
                        unit = packageService.getExecutableVO(package)
                        installflags = unit.installInfo.installFlags
                        #print("Name : " + unit.name)
                        print("InstallInfo :" + installflags)
                        #print("FileType :" + unit.fileType)
            - sourceCodeType: PY2
            - scriptArguments: '${softwareInstallerName}'
            - serverNames: SA_CORE24-2
        publish:
          - returnResult
          - jobId
          - returnCode
        navigate:
          - success: Sleep_4
          - failure: FAILURE
    - Sleep_4:
        do_external:
          d1bbf441-824a-450e-afae-2ddec0e0f35e:
            - seconds: '2'
        navigate:
          - success: Is_Change_InstallFlags_Job_Completed
          - failure: FAILURE
    - Is_Change_InstallFlags_Job_Completed:
        do_external:
          b9969b26-65f6-49a1-87aa-06d18f28e2ef:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobID: '${jobId}'
        publish:
          - status
        navigate:
          - running: Sleep_4
          - completed: Change_InstallFlags_Result
          - failure: FAILURE
    - Change_InstallFlags_Result:
        do_external:
          53605fd8-3656-47f7-8839-57580a0b791f:
            - coreHost: '${SACoreHost}'
            - coreUsername: '${SACoreUsername}'
            - corePassword:
                value: '${SACorePassword}'
                sensitive: true
            - coreVersion: '${saCoreVersion}'
            - jobId: '${jobId}'
        publish: []
        navigate:
          - success: Remove_Item_from_Software_Policy
          - failure: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Import_Software:
        x: 1640
        'y': 840
        navigate:
          6775d182-37d4-f0dd-08a3-f6d34155a594:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Change_InstallFlags_Result:
        x: 1840
        'y': 1080
        navigate:
          1010e65c-b18e-1cae-697e-e5c4c65c0a17:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Get_Software_Policy_Items:
        x: 680
        'y': 640
        navigate:
          7057ff20-e7da-aa93-d984-e46b5b9d48d8:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      String_Comparator:
        x: 1280
        'y': 640
        navigate:
          f8f1c26a-3e1c-399b-465d-7305e62da00d:
            targetId: 18d96665-2307-68ea-d24f-c7e0f4a3f9f8
            port: success
      Remove_Item_from_Software_Policy:
        x: 1640
        'y': 1040
        navigate:
          586122a6-6c1e-24cc-c015-56ed9a09ab07:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Is_Get_Software_Version_Job_Completed:
        x: 1000
        'y': 250
        navigate:
          7d190dea-a7e5-6662-2259-eba5eac1f981:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Get_Unit_VOs:
        x: 1000
        'y': 640
        navigate:
          74543d0a-ea82-18c4-3c6a-83d06e498a7e:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Get_Software_Version:
        x: 400
        'y': 125
        navigate:
          3bbc38d3-59d4-86af-47b4-a86515f5bf43:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Sleep_1:
        x: 700
        'y': 250
        navigate:
          c5c7a07b-52d8-e7ce-3b1f-0f84c238b4d4:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Sleep_2:
        x: 1000
        'y': 440
        navigate:
          612afb49-5e2c-d9b8-d966-bc44f7818dfa:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Sleep_3:
        x: 680
        'y': 840
        navigate:
          812a7b68-2502-c6ce-ed60-40bd82245ca8:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Download_Installer_Result:
        x: 1280
        'y': 840
        navigate:
          060a37eb-0609-23c4-1ca8-e82895af85ad:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Sleep_4:
        x: 1640
        'y': 1280
        navigate:
          d37cf402-4482-a01b-bbf6-4b2d077dbe3c:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Get_SA_Version:
        x: 100
        'y': 250
        navigate:
          99a28b19-853b-3bf7-79a8-bf49fb05f376:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Is_Download_Installer_Job_Completed:
        x: 1000
        'y': 840
        navigate:
          b59beaeb-7098-f014-cbca-cbe01031b438:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Is_Change_InstallFlags_Job_Completed:
        x: 1760
        'y': 1200
        navigate:
          8c268acc-0665-ce97-6a07-ca9fffd61325:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Download_Installer:
        x: 1640
        'y': 640
        navigate:
          a8f1b7ba-9553-53ae-9a35-253d6dcb5722:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Get_Software_Version_Result:
        x: 1300
        'y': 250
        navigate:
          f14bb18c-def4-bd4b-0a22-15b73a43ac2d:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Add_Item_to_Software_Policy:
        x: 1880
        'y': 920
        navigate:
          a704bb49-0bfa-a36a-992e-78b318b220a6:
            targetId: 18d96665-2307-68ea-d24f-c7e0f4a3f9f8
            port: success
          7a60294f-dad9-362d-b44c-a7625d876d26:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Is_Get_Installer_Job_Completed:
        x: 1280
        'y': 440
        navigate:
          cc7f5709-75c7-bae5-7e17-8c145ade92c5:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Is_Import_Software_Job_Completed:
        x: 1000
        'y': 1040
        navigate:
          d485c2a5-2884-c158-f9a5-eca244bcbadd:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Sleep:
        x: 680
        'y': 1040
        navigate:
          fa0e6ab4-b8df-10bb-c6fb-e7f3326956a6:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Compare_UnitType:
        x: 1480
        'y': 1040
      Get_Unit_VOs_1:
        x: 1280
        'y': 1040
        navigate:
          1d451ac1-1f21-0858-feeb-eb7439f3b8ce:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Change_InstallFlags:
        x: 1480
        'y': 1200
        navigate:
          e7404d24-c5a1-9ee9-0a33-f1f6906e9aae:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Get_Installer_Result:
        x: 1640
        'y': 440
        navigate:
          3cb83844-374f-f969-44cc-e8c8361240b6:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
      Get_Installer:
        x: 680
        'y': 440
        navigate:
          10db35dd-ed46-a28d-a494-c2245937bf31:
            targetId: 693bbfe4-7ef7-c435-9c31-770715910b1f
            port: failure
    results:
      SUCCESS:
        18d96665-2307-68ea-d24f-c7e0f4a3f9f8:
          x: 1880
          'y': 640
      FAILURE:
        693bbfe4-7ef7-c435-9c31-770715910b1f:
          x: 400
          'y': 375
