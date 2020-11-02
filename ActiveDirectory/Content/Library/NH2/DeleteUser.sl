namespace: NH2
flow:
  name: DeleteUser
  inputs:
    - user_fullname: user ldapuser
    - user_id: ldapuser
  workflow:
    - Delete_User:
        do_external:
          646a39ed-121c-4738-aa36-59e0c34936c6:
            - host: testad.test.biz
            - username: administrator@test.biz
            - password:
                value: sh1nhwaCJ
                sensitive: true
            - OU: cn=users
            - userFullName: '${user_fullname}'
            - sAMAccountName: '${user_id}'
        publish:
          - deleteuser: '${returnResult}'
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Delete_User:
        x: 235
        'y': 165
        navigate:
          2f6a0da2-4c54-7996-03a7-923401aa0dee:
            targetId: 1723517e-a905-275e-1e78-59949c7a174a
            port: success
    results:
      SUCCESS:
        1723517e-a905-275e-1e78-59949c7a174a:
          x: 420
          'y': 162
