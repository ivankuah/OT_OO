namespace: NH2.ResetPassword
flow:
  name: ResetPassword
  inputs:
    - host:
        default: 172.17.20.20
        required: false
    - username:
        default: integration@nh2system.biz
        required: false
    - password:
        default: Welcome123..
        required: false
        sensitive: true
    - userFullName:
        required: true
    - userLoginName
    - userPassword:
        sensitive: true
  workflow:
    - GetUserFromOU:
        do:
          NH2.ResetPassword.GetUserFromOU:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - userFullName: '${userFullName}'
        publish: []
        navigate:
          - FAILURE: GetUserFromContainer
          - SUCCESS: Reset_Password
    - GetUserFromContainer:
        do:
          NH2.ResetPassword.GetUserFromContainer:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - userFullName: '${userFullName}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Reset_Password
    - Reset_Password:
        do_external:
          3950548b-3f1b-4baa-8a8d-95c2c98748b4:
            - host: '${host}'
            - sAMAccountName: '${userLoginName}'
            - userPassword:
                value: '${userPassword}'
                sensitive: true
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      GetUserFromOU:
        x: 116
        'y': 123
      GetUserFromContainer:
        x: 118
        'y': 267
      Reset_Password:
        x: 301
        'y': 219
        navigate:
          9122703f-3f35-c434-dcb5-6e3dd703e7ec:
            targetId: abb96330-8a23-caca-a6e3-ce7020ef56b2
            port: success
    results:
      SUCCESS:
        abb96330-8a23-caca-a6e3-ce7020ef56b2:
          x: 447
          'y': 220
