import json
import boto3
import os

def lambda_handler(event, context):
    ids = []

    region = event['region']
    detail = event['detail']
    eventname = detail['eventName']
    arn = detail['userIdentity']['arn']
    principal = detail['userIdentity']['principalId']
    userType = detail['userIdentity']['type']

    if userType == 'IAMUser':
        user = detail['userIdentity']['userName']

    else:
        user = principal.split(':')[1]
        
    ec2 = boto3.resource('ec2')

    if eventname == 'CreateVolume':
        ids.append(detail['responseElements']['volumeId'])

    elif eventname == 'RunInstances':
        items = detail['responseElements']['instancesSet']['items']
        for item in items:
            ids.append(item['instanceId'])

        base = ec2.instances.filter(InstanceIds=ids)
            
        #loop through the instances
        for instance in base:
            for vol in instance.volumes.all():
                ids.append(vol.id)
            for eni in instance.network_interfaces:
                ids.append(eni.id)

    elif eventname == 'CreateImage':
        ids.append(detail['responseElements']['imageId'])

    elif eventname == 'CreateSnapshot': 
        ids.append(detail['responseElements']['snapshotId'])

    if ids:
        for resourceid in ids:
            print('Tagging resource ' + resourceid)
            #ec2.create_tags(Resources=ids, Tags=[{'Key': 'Owner', 'Value': user}, {'Key': 'PrincipalId', 'Value': principal}])
            ec2.create_tags(Resources=ids, Tags=[{'Key': 'CreatorArn', 'Value': arn}, {'Key': 'Account', 'Value': os.getenv('Account')}])