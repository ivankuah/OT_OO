namespace: USER_MANAGEMENT
flow:
  name: AD_CREATE_USER
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
    - Generate_Random_Password:
        do_external:
          7aa08ff2-5d8b-4839-901e-93b61aebbe7e:
            - passwordLength: '15'
            - numberOfNonAlphanumericCharacters: '4'
        publish:
          - userPassword: '${password}'
        navigate:
          - success: Create_User
          - failure: FAILURE
    - Create_User:
        do_external:
          0b7086df-fca5-4841-83f6-934e8d3106f5:
            - host: '${ADHost}'
            - OU: '${ADOU}'
            - userFullName: '${UserFullName}'
            - userPassword:
                value: '${userPassword}'
                sensitive: true
            - sAMAccountName: '${LoginName}'
            - altuser: '${ADAdminUser}'
            - altpass:
                value: '${ADAdminPassword}'
                sensitive: true
        publish:
          - returnResult
          - userDN
        navigate:
          - success: Set_User_Account
          - failure: FAILURE
    - Set_User_Account:
        do_external:
          b02dcd0f-f6b0-410f-b47a-ee56129311bf:
            - host: '${ADHost}'
            - username: '${ADAdminUser}'
            - password:
                value: '${ADAdminPassword}'
                sensitive: true
            - OU: '${ADOU}'
            - userCommonName: '${UserFullName}'
            - logonName: "${LoginName+'@nh2demo.local'}"
            - sAMAccountName: '${LoginName}'
        publish:
          - returnResult
        navigate:
          - success: AddUserToTestVM
          - failure: FAILURE
    - AddUserToTestVM:
        do_external:
          6ae74457-0430-4b6b-9272-9a23be1d1d7b:
            - groupDN: 'CN=TestVM,OU=vCenter,OU=NH2-Groups,DC=nh2system,DC=biz'
            - userDN: '${userDN}'
            - host: '${ADHost}'
            - altuser: '${ADAdminUser}'
            - altpass:
                value: '${ADAdminPassword}'
                sensitive: true
        navigate:
          - success: Send_Mail
          - failure: FAILURE
    - Send_Mail:
        do_external:
          14d6eacc-c41c-4e89-a139-63124c1376f4:
            - hostname: 172.17.20.21
            - port: '25'
            - from: no-reply@nh2system.com
            - to: "LoginName+'@nh2system.com'"
            - subject: NH2 AD USER ACCOUNT
            - body: "${'<p>Dear '+ UserFullName  +'<br><br>Below is your VPN and VCENTER User Account Information. <br><br>Full Name :' + UserFullName +'<br>Username: ' + LoginName + '<br>Password: ' + userPassword + '</p><p>Kindly refer to the attachments for your new account access to Office SSLVPN and Office vCenter.<br><br>Please follow the sequence.<br><br>1.\t1.0 Change New User Account Password.pdf<br>2.\t2.0 Office SSLVPN Guide.pdf<br>3.\t3.0 Office vCenter.pdf<br>4.\t4.0 Password Reset Guide.pdf (This guide is only required when you forgot your VPN/VCENTER password)<br>5.\t5.0 NH2 MFA User Setup.pdf (This guide enables Multi Factor Authentication for O365 Account)<br><br>Please do not hesitate to contact Ivan should you have any problems.</p>'}"
        publish:
          - returnResult
        navigate:
          - failure: FAILURE
          - success: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Generate_Random_Password:
        x: 280
        'y': 80
        navigate:
          05fabe2f-1fd9-c399-ba0a-34213747dfc5:
            targetId: 8001a9f4-b78b-0e06-b0a8-0fae7dd0db52
            port: failure
      Create_User:
        x: 440
        'y': 80
        navigate:
          624e58ec-ec7e-2f6f-fe17-5bb402376e6a:
            targetId: 8001a9f4-b78b-0e06-b0a8-0fae7dd0db52
            port: failure
      Set_User_Account:
        x: 640
        'y': 80
        navigate:
          ea02c49d-bb05-aa05-2148-5d6f81f8a2d4:
            targetId: 8001a9f4-b78b-0e06-b0a8-0fae7dd0db52
            port: failure
      Send_Mail:
        x: 760
        'y': 320
        navigate:
          d84bd517-594d-c30d-6088-d790011a2aed:
            targetId: 8001a9f4-b78b-0e06-b0a8-0fae7dd0db52
            port: failure
          d73c7d20-1367-b820-7596-e3be8f2e6c81:
            targetId: 292b9929-e130-5101-baa8-70452495c4ca
            port: success
      AddUserToTestVM:
        x: 480
        'y': 320
        navigate:
          219ecfdd-fad4-1283-c474-01e81f24f68a:
            targetId: 8001a9f4-b78b-0e06-b0a8-0fae7dd0db52
            port: failure
    results:
      SUCCESS:
        292b9929-e130-5101-baa8-70452495c4ca:
          x: 880
          'y': 280
      FAILURE:
        8001a9f4-b78b-0e06-b0a8-0fae7dd0db52:
          x: 280
          'y': 280
