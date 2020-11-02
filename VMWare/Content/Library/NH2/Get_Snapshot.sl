namespace: NH2
flow:
  name: Get_Snapshot
  workflow:
    - Get_Snapshot:
        do_external:
          4bb17fdc-3028-4a94-a7fb-ebe85649ac62:
            - host: 172.17.20.25
            - user: kayzie@vsphere.local
            - password:
                value: 'Nh212#$%'
                sensitive: true
            - closeSession: 'true'
            - vmIdentifierType: ip
            - virtualMachine: 172.17.40.82
        publish:
          - returnResult
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_Snapshot:
        x: 263
        'y': 224
        navigate:
          75cea0e4-f2c5-bdfe-060d-2466a074022f:
            targetId: dfe62bc9-0234-9ff4-fcaf-147536d99003
            port: success
    results:
      SUCCESS:
        dfe62bc9-0234-9ff4-fcaf-147536d99003:
          x: 525
          'y': 215
