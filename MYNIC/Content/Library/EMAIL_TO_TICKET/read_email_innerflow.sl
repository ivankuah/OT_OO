namespace: EMAIL_TO_TICKET
operation:
  name: read_email_innerflow
  inputs:
    - emailUser
    - emailPassword:
        sensitive: true
    - emailServer
    - emailPort
  python_action:
    use_jython: false
    script: "import imaplib\r\nimport email\r\nimport re \r\nimport codecs \r\nimport string \r\nimport getpass\r\n\r\n#pattern_uid = re.compile(r'\\d+ \\(UID (?P<uid>\\d+)\\)')\r\n\r\n#def parse_uid(message):\r\n#    match = pattern_uid.match(message)\r\n#    return match.group('uid')\r\n\r\ndef execute(emailUser,emailPassword,emailServer,emailPort):\r\n    \r\n    \r\n    user = emailUser\r\n    password = emailPassword\r\n    host = emailServer\r\n    port = emailPort\r\n    \r\n    imap = imaplib.IMAP4_SSL(host,port)\r\n    imap.login(user, password)\r\n\r\n    #for i in imap.list()[1]:\r\n    #    l = i.decode().split('\"/\"')\r\n    #    return {\"result\" : l[0] + \" = \" + l[1]}\r\n        \r\n        \r\n    imap.select('\"Inbox\"')\r\n    status, messages = imap.search(None, 'UNSEEN')\r\n    \r\n    # iterate over the messages and retrieve their contents\r\n    for num in messages[0].split()[::-1]:\r\n        _, msg = imap.fetch(num, \"(RFC822)\")\r\n        message = email.message_from_bytes(msg[0][1])\r\n        sender = message['From']\r\n        subject = message['Subject']\r\n        for part in message.walk():\r\n            if part.get_content_type() == \"text/plain\":\r\n                body = part.get_payload(decode=True)\r\n                #body = body.decode('utf-8')\r\n                #body = obj.replace('\\r\\n',',')\r\n                #body = obj[:len(obj)-1].replace(' ','')\r\n                #body = dict(map(lambda x: x.split(':'), body.split(',')))\r\n        #decoded_subject = email.header.decode_header(subject_header)\r\n        #subject = decoded_subject[0][0]\r\n        \r\n        # print the message details\r\n        return {\"result\" : message, \"sender\" : sender, \"subject\" : subject, \"body\" : body}\r\n        #return {\"From\" : message[\"From\"] + \",\" + subject}\r\n        \r\n        \r\n     #   apply_lbl_msg = imap.uid('COPY',msg_uid, 'Processed')\r\n     #   return {\"copy_status\" : apply_lbl_msg}\r\n    \r\n    imap.close()\r\n    imap.logout()"
  outputs:
    - result
    - sender
    - subject
    - body
  results:
    - SUCCESS
