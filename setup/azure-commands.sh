# Create Virtual Machine Scale Set
az vmss create --name vmss7 \
 --resource-group apigee \
 --image /subscriptions/61b58447-d904-4358-b64b-a0b389a4b773/resourceGroups/APIGEE/providers/Microsoft.Compute/galleries/customer_image_gallery/images/RHEL_7_9_RMP_BASE/versions/0.0.9\
 --upgrade-policy-mode automatic \
 --admin-username azureuser \
 --instance-count 1 \
 --vnet-name vnet \
 --subnet apigee_subnet \
 --ssh-key-values id_rsa_apigee.pub \
 --disable-overprovision \
 --specialized

# Add Custom Script to the Virtual machine scale set
az vmss extension set \
 --publisher Microsoft.Azure.Extensions \
 --version 2.0 \
 --name CustomScript \
 --resource-group apigee \
 --vmss-name vmss7 \
 --settings '{"fileUris":["https://raw.githubusercontent.com/ashwarn/ansible-opdk-accelerator/master/setup/setup-rmp-azure-optimized-demo.sh"],"commandToExecute":"cat setup-rmp-azure-optimized-demo.sh | su -c 'bash' - azureuser"}'

# Add health probe the Virtual machine scale set
az vmss extension set \
  --name ApplicationHealthLinux \
  --vmss-name vmss7 \
  --publisher Microsoft.ManagedServices \
  --version 1.0 \
  --resource-group apigee \
  --settings '{"port":8081,"protocol":"http","requestPath":"/v1/servers/self/up"}'

# Create load balancer health probe
az network lb probe create --lb-name vmss7LB \
 --name rmp_health_probe \
 --port 15999 --protocol Http \
 --resource-group apigee \
 --path v1/servers/self/reachable

# Create routing rule 80-->9001
az network lb rule create \
 --resource-group apigee \
 --name myLoadBalancerRuleWeb2 \
 --lb-name vmss7LB \
 --probe-name rmp_health_probe \
 --backend-pool-name vmss7LBBEPool \
 --backend-port 9001 \
 --frontend-ip-name loadBalancerFrontEnd \
 --frontend-port 80 \
 --protocol tcp

# Get IP Address of the load balancer
az network public-ip show \
 --resource-group apigee \
 --name vmss7LBPublicIP \
 --query '[ipAddress]' \
 --output tsv



## Clean -up
az vmss delete --resource-group apigee --name vmss5
az network lb delete --resource-group apigee --name vmss5LB
