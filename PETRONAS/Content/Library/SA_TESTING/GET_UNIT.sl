namespace: SA_TESTING
flow:
  name: GET_UNIT
  workflow:
    - Get_Unit_VOs:
        do_external:
          15aa115d-c0ed-4712-982d-eeb7365fe456:
            - coreHost: 172.19.2.140
            - coreUsername: ivankuah
            - corePassword:
                value: Ironman123..
                sensitive: true
            - coreVersion: sas241
            - unitNames: mysql
        publish:
          - id
          - unitFileName
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Unit_VOs:
        x: 320
        'y': 400
        navigate:
          64f4cef7-59ac-5bdb-e703-4078a52f6461:
            targetId: b15f3740-7540-0cee-556a-a8eec301ba4d
            port: failure
          da565231-7e0f-ccdd-05f7-a39a26a9a1ac:
            targetId: 89e555f6-eb9c-11bb-1400-4f1dc33e600a
            port: success
    results:
      FAILURE:
        b15f3740-7540-0cee-556a-a8eec301ba4d:
          x: 320
          'y': 560
      SUCCESS:
        89e555f6-eb9c-11bb-1400-4f1dc33e600a:
          x: 520
          'y': 400
