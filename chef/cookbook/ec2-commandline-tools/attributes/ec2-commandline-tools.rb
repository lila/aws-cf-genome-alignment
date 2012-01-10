

set_unless[:ec2_commandline_tools][:url] = "http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip"
set_unless[:ec2_commandline_tools][:install_base] = "/opt/aws/apitools"
set_unless[:ec2_commandline_tools][:install_dir] = "ec2"
set_unless[:ec2_commandline_tools][:user] = "root"
set_unless[:ec2_commandline_tools][:group] = "root"
