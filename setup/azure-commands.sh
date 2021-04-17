az group create --name myResourceGroup1 --location australiaeast

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

az vmss extension set \
 --publisher Microsoft.Azure.Extensions \
 --version 2.0 \
 --name CustomScript \
 --resource-group apigee \
 --vmss-name vmss7 \
 --settings '{"fileUris":["https://raw.githubusercontent.com/ashwarn/ansible-opdk-accelerator/master/setup/setup-rmp-azure-optimized-demo.sh"],"commandToExecute":"cat setup-rmp-azure-optimized-demo.sh | su -c 'bash' - azureuser"}'

az vmss extension set \
  --name ApplicationHealthLinux \
  --vmss-name vmss7 \
  --publisher Microsoft.ManagedServices \
  --version 1.0 \
  --resource-group apigee \
  --settings '{"port":8081,"protocol":"http","requestPath":"/v1/servers/self/up"}'

az network lb probe create --lb-name vmss7LB \
 --name rmp_health_probe \
 --port 15999 --protocol Http \
 --resource-group apigee \
 --path v1/servers/self/reachable


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

az network public-ip show \
 --resource-group apigee \
 --name vmss7LBPublicIP \
 --query '[ipAddress]' \
 --output tsv





az vmss extension set --publisher Microsoft.ManagedServices --version 2.0 --name HealthExtension --resource-group apigee --vmss-name vmss2 --settings '{"port":8081,"protocol":"http","requestPath":"/v1/servers/self/up"}'

az network lb rule create --resource-group apigee --name myLoadBalancerRuleWeb --lb-name vmss2LB --backend-pool-name vmss2LBBEPool --backend-port 80 --frontend-ip-name loadBalancerFrontEnd --frontend-port 80 --protocol tcp

az network public-ip show --resource-group apigee --name vmss2LBPublicIP --query '[ipAddress]' --output tsv


RedHat:RHEL:7_9:latest

  az vmss delete \
    --resource-group apigee \
    --name vmss2

# az network lb address-pool delete -g apigee --lb-name test-rotuing -n pool1
# az vmss update --resource-group apigee --name vmss-rmp --remove virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools 0
az vmss extension list --resource-group apigee --vmss-name vmss2
az vmss extension delete --name CustomScript --resource-group apigee --vmss-name vmss2
# --settings '{"fileUris":["https://raw.githubusercontent.com/ashwarn/ansible-opdk-accelerator/master/setup/test-nginx.sh"],"commandToExecute":"./test-nginx.sh"}'

sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --permanent --add-port=8082/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=9001/tcp
sudo firewall-cmd --permanent --add-port=15999/tcp
## Clean -up

az vmss delete --resource-group apigee --name vmss5
az network lb delete --resource-group apigee --name vmss5LB


# New RG

az group create --name myResourceGroup1 --location australiaeast

az vmss create --resource-group apigee --name vmss3 --image RedHat:RHEL:7_9:latest --upgrade-policy-mode automatic --admin-username azureuser --instance-count 1 --vnet-name vnet --subnet apigee_subnet --ssh-key-values id_rsa_apigee.pub --disable-overprovision

az vmss extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --resource-group apigee --vmss-name vmss3 --settings '{"fileUris":["https://raw.githubusercontent.com/ashwarn/ansible-opdk-accelerator/master/setup/test-nginx.sh"],"commandToExecute":"./test-nginx.sh"}'


az network lb rule create --resource-group apigee --name myLoadBalancerRuleWeb --lb-name vmss3LB --backend-pool-name vmss3LBBEPool --backend-port 80 --frontend-ip-name loadBalancerFrontEnd --frontend-port 80 --protocol tcp

az network public-ip show --resource-group apigee --name vmss3LBPublicIP --query '[ipAddress]' --output tsv
