namespace: Get_VMInfo
flow:
  name: Get_VMInfo
  inputs:
    - password: Nh2vcpa$$
  workflow:
    - Get_Virtual_Machine:
        do_external:
          a7b8a2c3-99a3-47a7-99e2-6e6d5988c060:
            - host: 172.17.20.25
            - user: administrator@vsphere.local
            - password:
                value: '${password}'
                sensitive: true
            - closeSession: 'false'
            - vmIdentifierType: IP
            - virtualMachine: 172.17.40.88
            - getDetailed: 'true'
        publish:
          - name
        navigate:
          - success: SUCCESS
          - failure: on_failure
          - no more: SUCCESS
  outputs:
    - name: name
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Get_Virtual_Machine:
        x: 226
        'y': 249
        navigate:
          fb9f8850-8979-5c84-60a2-03225e78c215:
            targetId: 388f1f66-ef8a-f96b-1510-6acd9860a155
            port: success
          126295c0-0f9f-9c15-fe8c-9371c4babe86:
            targetId: 388f1f66-ef8a-f96b-1510-6acd9860a155
            port: no more
    results:
      SUCCESS:
        388f1f66-ef8a-f96b-1510-6acd9860a155:
          x: 440
          'y': 232
