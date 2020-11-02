namespace: NH2.ResetPassword
flow:
  name: GetUserFromContainer
  inputs:
    - host:
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - dn:
        default: 'DC=nh2system,DC=biz'
        required: false
    - filter:
        default: objectClass=Container
        required: false
    - propertyName:
        default: cn
        required: false
    - userFullName
  workflow:
    - LDAP_Get_All_Properties:
        do_external:
          6f9d9ce8-c6c2-40ea-a5f9-66bdef9c27ad:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - filter: '${filter}'
            - propertyName: '${propertyName}'
            - DN: '${dn}'
        publish:
          - cn: '${returnResult}'
        navigate:
          - failure: on_failure
          - success: Is_User_Enabled
    - Is_User_Enabled:
        loop:
          do_external:
            37c16732-1c50-4b63-b8b8-ca3e77868bee:
              - host: '${host}'
              - username: '${username}'
              - password:
                  value: '${password}'
                  sensitive: true
              - OU: '${"CN="+row}'
              - userFullName: '${userFullName}'
          for: 'row in cn.split(",")'
          break:
            - success
          publish:
            - cn: '${OU}'
            - returnResult
        navigate:
          - success: Disable_User
          - failure: Enable_User
    - Enable_User:
        do_external:
          16a531df-401a-4c9e-a57d-6c4ec929bac1:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - OU: '${cn}'
            - userFullName: '${userFullName}'
        publish:
          - returnResult
        navigate:
          - success: SUCCESS
          - failure: on_failure
    - Disable_User:
        do_external:
          16b48c60-404a-4bdc-9474-0d8f4bc830eb:
            - host: '${host}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - OU: '${cn}'
            - userFullName: '${userFullName}'
        publish:
          - returnResult
        navigate:
          - success: Enable_User
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      LDAP_Get_All_Properties:
        x: 115
        'y': 172
      Is_User_Enabled:
        x: 238
        'y': 181
      Enable_User:
        x: 404
        'y': 294
        navigate:
          f7441630-8157-86ad-c03c-2e4a3afcb1f6:
            targetId: c0880ac2-1cdd-a6fc-3ecf-58cb1e37a876
            port: success
      Disable_User:
        x: 404
        'y': 141
    results:
      SUCCESS:
        c0880ac2-1cdd-a6fc-3ecf-58cb1e37a876:
          x: 531
          'y': 294
