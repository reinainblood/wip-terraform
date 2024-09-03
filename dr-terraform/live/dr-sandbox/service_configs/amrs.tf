locals {

  amrs = {
    cpu            = 1024
    memory         = 4028
    image_tag      = "3232abc7-amrs"
    container_port = 5003
    desired_count  = 1
    environment =  [
      { name = "SERVICE_NAME", value = "amrs" },
      { name = "PORT", value = "5000"}
    ]
    secrets = [
      {
        name      = "AIRTABLE_KEY",
        valueFrom = "arn:aws:secretsmanager:eu-west-3:609902089584:secret:SANDBOX_AIRTABLE_KEY-niq1J8"
      }
    ]
  }
}
