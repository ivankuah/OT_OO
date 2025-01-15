namespace: SA_TESTING
flow:
  name: TESTING_IMPORT_PACKAGES
  inputs:
    - SoftwareMajorVersion: '24'
    - SoftwareName: Wireshark-4.4.1-x64.exe
    - SACoreHost: 172.19.2.140
    - SACoreUsername: ivankuah
    - SACorePassword:
        default: Ironman123..
        sensitive: true
    - saCoreVersion: sas241
  workflow:
    - Start_Adhoc_Server_Script:
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
                        #print("FileType :" + unit.fileType)        #print("FileType :" + unit.fileType)
            - sourceCodeType: PY2
            - scriptArguments: '${SoftwareName}'
            - serverNames: SA_CORE24-2
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Start_Adhoc_Server_Script:
        x: 400
        'y': 320
        navigate:
          e825de0f-7e97-0c1b-e8cd-36815efa5218:
            targetId: ef06565c-327e-bef2-6404-858463cefa4a
            port: success
          ea94ee38-3767-dc77-3920-2d041e19192d:
            targetId: dbcb0bc4-d83c-8cca-d139-b6fece76b1a1
            port: failure
    results:
      SUCCESS:
        ef06565c-327e-bef2-6404-858463cefa4a:
          x: 680
          'y': 280
      FAILURE:
        dbcb0bc4-d83c-8cca-d139-b6fece76b1a1:
          x: 280
          'y': 440
