namespace: EMAIL_TO_TICKET
operation:
  name: save_eml_to_local_innerflo
  inputs:
    - email_data
  python_action:
    use_jython: false
    script: |-
      import email
      from email import policy
      from email.parser import BytesParser

      def execute(email_data):

          msg = email.message_from_string(email_data, policy=policy.default)

          # Write the email to a file
          with open('/opt/attachment/originalemail.eml', 'wb') as f:
              f.write(bytes(msg))
  results:
    - SUCCESS
