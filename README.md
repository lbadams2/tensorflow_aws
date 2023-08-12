## Create EC2 instance for building Tensorflow


## Connect using SSM
1. Install SSM client
```bash
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
unzip sessionmanager-bundle.zip
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
```

2. Start a session
```bash
export AWS_DEFAULT_REGION=$region
aws ssm start-session --target $ec2_instance_id
```