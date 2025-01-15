namespace: USER_MANAGEMENT
flow:
  name: AD_DELETE_USER
  inputs:
    - ADHost:
        default: 172.17.40.100
        required: false
    - ADOU:
        default: OU=NH2-Users
        required: false
    - ADAdminUser:
        default: "nh2\\Administrator"
        required: false
    - ADAdminPassword:
        default: Hello123..
        required: false
        sensitive: true
    - UserFullName
    - LoginName
  workflow:
    - Delete_User:
        do_external:
          646a39ed-121c-4738-aa36-59e0c34936c6:
            - host: '${ADHost}'
            - username: '${ADAdminUser}'
            - password:
                value: '${ADAdminPassword}'
                sensitive: true
            - OU: '${ADOU}'
            - userFullName: '${UserFullName}'
        publish:
          - deleteUserResult: '${returnResult}'
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Delete_User:
        x: 480
        'y': 160
        navigate:
          c68cb821-807c-049a-318c-9ac472995472:
            targetId: 8001a9f4-b78b-0e06-b0a8-0fae7dd0db52
            port: failure
          c4f566f3-06c1-05cd-ad2e-cd6ac484ee4d:
            targetId: 292b9929-e130-5101-baa8-70452495c4ca
            port: success
    results:
      SUCCESS:
        292b9929-e130-5101-baa8-70452495c4ca:
          x: 680
          'y': 160
      FAILURE:
        8001a9f4-b78b-0e06-b0a8-0fae7dd0db52:
          x: 480
          'y': 280
