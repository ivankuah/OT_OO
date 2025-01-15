namespace: SA_TESTING
operation:
  name: GetPackages
  inputs:
    - coreHost
    - coreUsername
    - corePassword
  python_action:
    use_jython: false
    script: "# do not remove the execute function\n\nimport sys\nimport pytwist \n\n\ndef execute(coreHost,coreUsername,corePassword):\n    ts = twistserver.TwistServer(coreHost)\n    try:\n            ts.authenticate(coreUsername, corePassword)\n    except:\n            return {returnResult : \"Authentication failed.\"}\n            sys.exit(2)   \n# you can add additional helper methods below."
  outputs:
    - returnResult
  results:
    - SUCCESS
