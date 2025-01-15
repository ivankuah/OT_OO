namespace: USER_MANAGEMENT
flow:
  name: CREATE_USER
  inputs:
    - UserFullName
    - UserFirstName
    - UserLastName
    - UserTitle
    - UserMobileNo
    - UserOrganizationalGroup
    - UserHireDate
    - UserEmail
  workflow:
    - AD_CREATE_USER:
        do:
          USER_MANAGEMENT.AD_CREATE_USER:
            - UserFullName: '${UserFullName}'
            - LoginName: '${UserEmail}'
        navigate:
          - SUCCESS: SMAX_CREATE_USER
          - FAILURE: FAILURE
    - SMAX_CREATE_USER:
        do:
          USER_MANAGEMENT.SMAX_CREATE_USER:
            - UserEmail: '${UserEmail}'
            - UserFullName: '${UserFullName}'
            - UserFirstName: '${UserFirstName}'
            - UserLastName: '${UserLastName}'
            - UserMobileNo: '${UserMobileNo}'
            - UserTitle: '${UserTitle}'
            - UserOrganizationalGroup: '${UserOrganizationalGroup}'
            - UserHireDate: '${UserHireDate}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      AD_CREATE_USER:
        x: 240
        'y': 160
        navigate:
          627f4408-5e18-28bb-590e-77f2c89a0321:
            targetId: 40a94310-4238-8333-fcd2-bd7f6952eb19
            port: FAILURE
      SMAX_CREATE_USER:
        x: 440
        'y': 160
        navigate:
          01d9df99-e97a-636f-479b-5132d66d0e84:
            targetId: 40a94310-4238-8333-fcd2-bd7f6952eb19
            port: FAILURE
          4a5b0c52-3c3e-c37c-23f7-34bae6c55bbc:
            targetId: e0d8c877-eccf-b79a-f0e9-448002533514
            port: SUCCESS
    results:
      FAILURE:
        40a94310-4238-8333-fcd2-bd7f6952eb19:
          x: 360
          'y': 320
      SUCCESS:
        e0d8c877-eccf-b79a-f0e9-448002533514:
          x: 640
          'y': 160
