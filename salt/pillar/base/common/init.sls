consul:
  checks:
    ssh:
      name: "SSH TCP on port 22"
      type: tcp
      target: "localhost:22"
      interval: 10s
      timeout: 1s