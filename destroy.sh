
cd 01-infrastructure
# Fetch AMIs with names starting with "flask_server_ami"
for ami_id in $(aws ec2 describe-images \
    --owners self \
    --filters "Name=name,Values=flask_server_ami*" \
    --query "Images[].ImageId" \
    --output text); do
    
    echo "Deregistering AMI: $ami_id"
    aws ec2 deregister-image --image-id $ami_id

    # Fetch and delete associated snapshots
    for snapshot_id in $(aws ec2 describe-images \
        --image-ids $ami_id \
        --query "Images[].BlockDeviceMappings[].Ebs.SnapshotId" \
        --output text); do
        
        echo "Deleting snapshot: $snapshot_id"
        aws ec2 delete-snapshot --snapshot-id $snapshot_id
    done
done
terraform init
terraform destroy -auto-approve

