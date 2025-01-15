namespace: EMAIL_TO_TICKET
flow:
  name: EMAIL_TO_TICKET_MAINFLOW
  inputs:
    - EmailUser
    - EmailPassword
    - EmailServer
    - EmailPort
    - SMAXUrl
    - SMAXTenantId
    - SMAXUser
    - SMAXPassword
  workflow:
    - read_email_innerflow:
        do:
          EMAIL_TO_TICKET.read_email_innerflow:
            - emailUser: '${EmailUser}'
            - emailPassword:
                value: '${EmailPassword}'
                sensitive: true
            - emailServer: '${EmailServer}'
            - emailPort: '${EmailPort}'
        publish:
          - result
          - sender
          - subject
          - body
        navigate:
          - SUCCESS: is_null
    - is_null:
        do:
          io.cloudslang.base.utils.is_null: []
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: check_double_quote
    - check_double_quote:
        do_external:
          f1dafb35-6463-4a1b-8f87-8aa748497bed:
            - matchType: Contains
            - toMatch: '${body}'
            - matchTo: '"'
            - ignoreCase: 'true'
        publish:
          - checkDoubleQuoteResult: '${returnResult}'
          - response
        navigate:
          - success: replace_double_quote_in_body
          - failure: replace_symbol_in_body
    - replace_symbol_in_body:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${body}'
            - text_to_replace: "\\r\\n"
            - replace_with: '[thisisnewline]'
        publish:
          - replaced_string
        navigate:
          - SUCCESS: Get_SSO_Token
          - FAILURE: on_failure
    - replace_double_quote_in_body:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${body}'
            - text_to_replace: '"'
            - replace_with: "\\"
        publish:
          - replaced_string
        navigate:
          - SUCCESS: replace_symbol_in_body
          - FAILURE: on_failure
    - Get_SSO_Token:
        do_external:
          78a95e79-2f1d-4173-b12b-e00f7bcd2134:
            - sawUrl: '${SMAXUrl}'
            - username: '${SMAXUser}'
            - password:
                value: '${SMAXPassword}'
                sensitive: true
            - contentType: application/json
        publish:
          - ssoToken
        navigate:
          - success: Create_Request
          - failure: FAILURE
    - Create_Request:
        do_external:
          b37a057b-9f03-42db-bbd0-49844960804e:
            - sawUrl: '${SMAXUrl}'
            - ssoToken: '${ssoToken}'
            - tenantId: '${SMAXTenantId}'
            - properties: "${'{\"ImpactScope\":\"SingleUser\",\"Urgency\":\"NoDisruption\",\"RequestsOffering\":\"42751\",\"DisplayLabel\":\"'+subject+'\",\"Description\":\"'+body+'\",\"EmailBody_c\":\"'+sender+'\"}'}"
        publish:
          - entityId
        navigate:
          - success: save_eml_to_local_innerflo
          - failure: FAILURE
    - save_eml_to_local_innerflo:
        do:
          EMAIL_TO_TICKET.save_eml_to_local_innerflo:
            - email_data: '${result}'
        navigate:
          - SUCCESS: http_client_action
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${sawUrl + '/rest/' + tenantId +'/ces/attachment'}"
            - auth_type: Basic
            - headers: "${'Cookie:LWSSO_COOKIE_KEY=' + ssoToken + '; TENANTID=' + tenantId}"
            - content_type: text/plain
            - multipart_files: 'files[]=/opt/attachment/originalemail.eml'
            - multipart_files_content_type: text/plain
            - method: POST
        publish:
          - attachment_name: "${(cs_json_query(return_result,'$.name'))[2:-2]}"
          - attachement_id: "${(cs_json_query(return_result,'$.guid'))[2:-2]}"
          - attachement_size: "${(cs_json_query(return_result,'$.contentLength'))[1:-1]}"
          - attachment_content_type: "${(cs_json_query(return_result,'$.contentType'))[2:-2]}"
          - httpPostResult: '${return_result}'
        navigate:
          - SUCCESS: Update_Request
          - FAILURE: on_failure
    - Update_Request:
        do_external:
          a7d7b33c-b08d-4c89-81b1-6f489de3befa:
            - sawUrl: '${SMAXUrl}'
            - ssoToken: '${ssoToken}'
            - tenantId: '${SMAXTenantId}'
            - entityId: '${entityId}'
            - properties: "${'\"RequestAttachments\":\"{\\\\\"complexTypeProperties\\\\\":[ {\\\\\"properties\\\\\":{ \\\\\"id\\\\\":\\\\\"' + attachment_id + '\\\\\",\\\\\"file_name\\\\\":\\\\\"'+ attachment_name +'\\\\\",\\\\\"file_extension\\\\\":\\\\\"eml\\\\\",\\\\\"size\\\\\":\\\\\"' + attachment_size + '\\\\\",\\\\\"mime_type\\\\\":\\\\\"' + attachment_content_type +'\\\\\",\\\\\"Creator\\\\\":\\\\\"uat.admin\\\\\"}}]}\"'}"
        publish:
          - uploadAttachementResult: '${returnResult}'
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Get_SSO_Token:
        x: 480
        'y': 200
        navigate:
          0afe44f4-e075-14c8-8ec0-b6b50510d2db:
            targetId: 30e08ab9-6756-6098-a8d6-2288a3a6332e
            port: failure
      replace_symbol_in_body:
        x: 320
        'y': 200
      check_double_quote:
        x: 320
        'y': 40
      Create_Request:
        x: 640
        'y': 40
        navigate:
          1afe266f-34a9-9098-e030-2d05f0316655:
            targetId: 30e08ab9-6756-6098-a8d6-2288a3a6332e
            port: failure
      save_eml_to_local_innerflo:
        x: 800
        'y': 40
      http_client_action:
        x: 800
        'y': 200
      replace_double_quote_in_body:
        x: 480
        'y': 40
      read_email_innerflow:
        x: 160
        'y': 40
      Update_Request:
        x: 800
        'y': 400
        navigate:
          a76c117c-c5f2-9c31-cfe2-f16f23845d01:
            targetId: 0fbf5cc3-371b-d6dd-8f20-add7dc69b139
            port: success
          cbb9acfd-3c29-9582-f9a8-2563eaa426b7:
            targetId: 30e08ab9-6756-6098-a8d6-2288a3a6332e
            port: failure
      is_null:
        x: 160
        'y': 200
        navigate:
          682ccfa9-9d95-c5c1-3e18-8fdb085e3a5a:
            targetId: 23f05e14-f4ff-aa07-5677-e499d33314a0
            port: IS_NULL
    results:
      SUCCESS:
        23f05e14-f4ff-aa07-5677-e499d33314a0:
          x: 160
          'y': 360
        0fbf5cc3-371b-d6dd-8f20-add7dc69b139:
          x: 960
          'y': 400
      FAILURE:
        30e08ab9-6756-6098-a8d6-2288a3a6332e:
          x: 520
          'y': 360
