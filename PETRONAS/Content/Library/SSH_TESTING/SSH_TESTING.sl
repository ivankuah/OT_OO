namespace: SSH_TESTING
flow:
  name: SSH_TESTING
  workflow:
    - SSH_Command:
        do_external:
          0b066b79-d65c-4da9-8ed4-edf50f378950:
            - host: 172.17.30.20
            - username: root
            - privateKeyData:
                value: |
                  -----BEGIN RSA PRIVATE KEY-----
                  MIIEowIBAAKCAQEAnormuRnsPH8fXh1pF6EZNVggFuSrkBV6+AyUK/sjYljsWRYv
                  spyrv41UfMhiL4mXq/B7P24LCr/cLf+0lO/bOrhn3O6DlXxZAvRmrty4IHZQZWTH
                  08kNJP2Xhbc2M54PHFUw5FUj0OysVGs9muibthBrmjQ0dM9/6PryJa86/cno9rI1
                  aR06SzGvwjnKUb5yg7U6ETjBWkWIPq4stpePP+tn/GDN37nYXNIrZzfqiB4EYOVF
                  apfSNV9vAu/xYGaq8WdY+s/eQg5ChIBA1Z9VJke0SqoGC3B0dtvJ94JZA+6FZowz
                  RG4XSNUJzkiuKCy+6fupnjn8yJbCOAx9Qq84ZwIDAQABAoIBADw744qhuaoGViGI
                  pPvQPeaRc6ee+zuDnbON++F1yay8whbaogaHFY1yIY5DB2KuMMynUfv4UAOmfv2O
                  78nCExWNKBC9IYryslK4DicTPnU+3i6XioABG5hZLG8l+1bDD1ShXTDy0+e1c4ej
                  MsWe6EHUnTz55pAWoa8fYE5G8++lYuCDq9H6r+U6XXyULshdglKqDpFj7D40jLco
                  w0aHoWVuAVsTVvIy2xa+0g2w07NYVXgkINqqllPS7g1TDL+RTWmXiUdoe9q/WuCA
                  hKuRCXEnAM1pfVZY7ftNlDBEpADzj0PG1Iq29AeLEtuNQ3gDa1FCNJBg0D1Ka7Ln
                  9KOgpvECgYEA58/msK1Ro/xypPvkgxIhMM0pnaRhcFEgF2xCCSvKXOVhVCGdXJPK
                  CUsYudABa/H+dBhFnk6mnqFt3t2t/bRaTeazNajddixhJA/FyGBoB5Y9vkGB1C7d
                  C+CjsAbRZAd+0pKrkId/TDWQG4F85GrhNAsfea8ZAv8lmCui09CKej8CgYEArxXY
                  axr0uZBZnh66FcdEEUunkw3YTAxA32cj0wZDYjvymhRFbovBnGfqWuThfjRIqSuf
                  odt+M9ntaR08qphGwKPg57VUp30QsxO6cr2PV/x2oywu5qIfXiNrhkdA1YIZzeqB
                  lGEftIXTOSSlOMb1/IQEcPgXJofzwArfwqPSJ9kCgYAOkcOHAS2rZ9dwxSAkmMQb
                  RBnEfateGsswja5M00LBuez3E7HHOsas9NpV+1vLhAchFtFxVLImMDEum7IuyuIO
                  GVzUF4vrvHhSgudEY8LGD0xMI+PcCSH9eB3xl0wbxFjVNUCxMcLvcEJhaC8IUCtd
                  UQGmbTneNVkQilWOiIHbkwKBgEM6wzBVWHVMnWze5ZtpOZTelQkdftmstthR1Wq5
                  c/Rrintpn0OUfJKfQFkInCGG2APFkXVoP+yPGN+M73eeI0TjaH/wnAH4PwpUX/qh
                  GUKy2adMVvIOfLb8KNSV1apmW5w7GOit5qu9216M2LiVhW0iEEaErPcJqyopwsQN
                  fav5AoGBAIpA+gGhDfzO8vlKv8SXx4DvI5rKUe0HUPFccLEs9sX44+QT1mIkmJ5g
                  S4pQGD220ObGftMlS5lglTny6S9o6FP1v4aDjytHuYv3XzapkXYPdcZIWlEkHi2q
                  MqSlnUZ2XfJi35j31bWYQN4ukaMrH36591EPC5cmeqNZt0+3CXfh
                  -----END RSA PRIVATE KEY-----
                sensitive: true
            - command: uname -a
        publish:
          - returnResult
        navigate:
          - success: SUCCESS
          - failure: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      SSH_Command:
        x: 400
        'y': 360
        navigate:
          9f8a6e45-7a09-d063-c4ca-1a89db286a5e:
            targetId: 7c662c35-7b32-1d03-6c23-9cb40102f32b
            port: failure
          d7829d6d-3306-1a41-dddb-9e759ab28720:
            targetId: e22baf13-3206-64c8-7b7c-251ffaebe2af
            port: success
    results:
      FAILURE:
        7c662c35-7b32-1d03-6c23-9cb40102f32b:
          x: 200
          'y': 320
      SUCCESS:
        e22baf13-3206-64c8-7b7c-251ffaebe2af:
          x: 640
          'y': 240
