namespace: USER_MANAGEMENT
flow:
  name: SMAX_CREATE_USER
  inputs:
    - SMAXUrl:
        required: false
    - SMAXTenantId:
        required: false
    - SMAXUsername:
        required: false
    - SMAXPassword:
        required: false
        sensitive: true
    - UserEmail
    - UserFullName
    - UserFirstName
    - UserLastName
    - UserMobileNo
    - UserTitle
    - UserOrganizationalGroup
    - UserHireDate
  workflow:
    - Get_SSO_Token:
        do_external:
          78a95e79-2f1d-4173-b12b-e00f7bcd2134:
            - sawUrl: '${SMAXUrl}'
            - username: '${SMAXUsername}'
            - password:
                value: '${SMAXPassword}'
                sensitive: true
        publish:
          - ssoToken
        navigate:
          - success: Create_User
          - failure: FAILURE
    - Create_User:
        do_external:
          caef4a4e-1d84-4b15-8144-d9925391eb2f:
            - sawUrl: '${SMAXUrl}'
            - ssoToken: '${ssoToken}'
            - tenantId: '${SMAXTenantId}'
            - inputJSON: "${'{\"entity_type\":\"People\",\"properties\":{\"Upn\":\"' + UserEmail + '\", \"Email\":\"' + UserEmail + '\", \"Name\": \"' + UserFullName + '\", \"FirstName\": \"' + UserFirstName + '\", \"LastName\": \"' + UserLastName + '\", \"MobilePhoneNumber\": \"' + UserMobileNo + '\", \"Title\": \"' + UserTitle + '\", \"OrganizationalGroup\": \"' + UserOraganizationalGroup + '\", \"HireDate\": \"' + UserHireDate + '\", \"Company\": \"13218\", \"IsExternal\": \"TRUE\", \"IsMaasUser\": \"TRUE\", \"IsSystemIntegration\": \"FALSE\", \"IsSystem\": \"FALSE\"}}'}"
            - proxyHost: '${proxyHost}'
        publish:
          - createUserResult: '${returnResult}'
        navigate:
          - failure: FAILURE
          - success: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_SSO_Token:
        x: 280
        'y': 160
        navigate:
          c856d1fd-869f-a42d-4ba4-d93a256709d7:
            targetId: 03301b75-7a0d-5969-8e9d-24ef4f766971
            port: failure
      Create_User:
        x: 560
        'y': 160
        navigate:
          06449c25-5c70-29d1-7fd5-2a93e0b64ad4:
            targetId: 03301b75-7a0d-5969-8e9d-24ef4f766971
            port: failure
          7cda7daf-4cce-0896-12d3-814b4ba22483:
            targetId: 808b707a-837d-9deb-5b1d-04f1aec59c31
            port: success
    results:
      FAILURE:
        03301b75-7a0d-5969-8e9d-24ef4f766971:
          x: 400
          'y': 320
      SUCCESS:
        808b707a-837d-9deb-5b1d-04f1aec59c31:
          x: 720
          'y': 160
