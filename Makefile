# Makefile for PingServer

#
# commands setup
# 
CF                      = cfn-create-stack
S3CMD                   = s3cmd

#
# variables
#
CFTemplatedir   		= ./cloudformation
CFTemplate              = template.cf
BOOTSTRAP               = ./cloudinit/userdata.txt
REGION                  = us-east
KEY						= normal

# 
# make targets 
#

help:
	@echo "help for Makefile for AWS-CF-genome-alignment"
	@echo "make create - launch the stack on aws"
	@echo "make destroy - destroy the cf stack"
	@echo "make test - just some testing"

test:
	@ echo "user = " $(USER);

clean: cleanbootstrap
	@echo "removed all unnecessary files"


create: bootstrap ${CFTemplatedir}/${CFTemplate}
	@ echo deploying server using ${CFTemplatedir}/${CFTemplate}
	${CF} genome-alignment --template-file ${CFTemplatedir}/${CFTemplate} --parameters "KeyName="$(KEY)";AccessKey="$(AWS_ACCESS_KEY_ID)";SecretKey="$(AWS_SECRET_ACCESS_KEY)";AccountNumber="$(AWS_ACCOUNT_ID)

destroy: cleanbootstrap
	@ echo deleting server stack genome-alignment
	-cfn-delete-stack genome-alignment

bootstrap: ${BOOTSTRAP}
	-${S3CMD} mb s3://$(USER).genome.alignment
	@ echo copying bootstrap to s3
	${S3CMD} put --acl-public ${BOOTSTRAP} s3://$(USER).genome.alignment/chef/bootstrap.txt
	@rm -f /tmp/genome-alignment-cookbook.tar
	@tar -cvf /tmp/genome-alignment-cookbook.tar chef/cookbook
	${S3CMD} put --acl-public /tmp/genome-alignment-cookbook.tar s3://$(USER).genome.alignment/chef/genome-alignment-cookbook.tar

cleanbootstrap:
	-${S3CMD} del s3://$(USER).genome.alignment/chef/bootstrap.txt
	-${S3CMD} del s3://$(USER).genome.alignment/chef/genome-alignment-cookbook.tar
	@rm -f /tmp/genome-alignment-cookbook.tar

testregion: 
	@ echo ${REGION}
