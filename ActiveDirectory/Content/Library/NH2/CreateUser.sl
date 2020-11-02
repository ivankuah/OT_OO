namespace: NH2
flow:
  name: CreateUser
  inputs:
    - firstname
    - lastname
    - new_user_id
    - new_user_password:
        sensitive: true
  workflow:
    - Create_User:
        do_external:
          0b7086df-fca5-4841-83f6-934e8d3106f5:
            - host: testad.test.biz
            - OU: cn=users
            - userFullName: "${lastname+' '+firstname}"
            - userPassword:
                value: '${new_user_password}'
                sensitive: true
            - sAMAccountName: '${new_user_id}'
            - altuser: administrator@test.biz
            - altpass:
                value: sh1nhwaCJ
                sensitive: true
        publish:
          - CreateUserResult: '${returnResult}'
          - userCommonName: '${userFullName}'
        navigate:
          - success: Set_User_Account
          - failure: on_failure
    - Set_User_Account:
        do_external:
          b02dcd0f-f6b0-410f-b47a-ee56129311bf:
            - host: testad.test.biz
            - username: administrator@test.biz
            - password:
                value: sh1nhwaCJ
                sensitive: true
            - OU: cn=users
            - userCommonName: '${userCommonName}'
            - logonName: "${new_user_id+'@test.biz'}"
            - sAMAccountName: '${new_user_id}'
        publish: []
        navigate:
          - success: Set_User_General_Information
          - failure: on_failure
    - Set_User_General_Information:
        do_external:
          cac61f8b-5f3d-448d-9db5-99976a9d2bbd:
            - host: testad.test.biz
            - username: administrator@test.biz
            - password:
                value: sh1nhwaCJ
                sensitive: true
            - OU: cn=users
            - userCommonName: '${userCommonName}'
            - firstName: '${firstname}'
            - lastName: '${lastname}'
            - displayName: "${lastname+' '+firstname}"
        publish: []
        navigate:
          - success: success
          - failure: on_failure
  results:
    - FAILURE
    - success
extensions:
  graph:
    steps:
      Create_User:
        x: 230
        'y': 147
      Set_User_Account:
        x: 391
        'y': 142
      Set_User_General_Information:
        x: 576
        'y': 146
        navigate:
          7d86e83f-8ff2-7daa-837f-a8c23fb8c8c9:
            targetId: f913ae70-101c-a7b6-a82c-4c61cd8c8399
            port: success
    results:
      success:
        f913ae70-101c-a7b6-a82c-4c61cd8c8399:
          x: 737
          'y': 142
