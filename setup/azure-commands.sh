az group create --name myResourceGroup1 --location australiaeast

az vmss create \
  --resource-group apigee \
  --name vmss2 \
  --image RedHat:RHEL:7_9:latest \
  --upgrade-policy-mode automatic \
  --admin-username azureuser \
  --instance-count 1 \
  --vnet-name vnet \
  --subnet apigee_subnet \
  --public-ip-address "" \
  --ssh-key-values id_rsa_apigee.pub

az vmss extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --resource-group apigee \
  --vmss-name vmss2 \
  --settings '{"fileUris":["https://raw.githubusercontent.com/ashwarn/ansible-opdk-accelerator/master/setup/test-nginx.sh"],"commandToExecute":"su -c \"bash ./automate_nginx.s\" - azureuser"}'

az network lb rule create \
  --resource-group apigee \
  --name myLoadBalancerRuleWeb \
  --lb-name vmss2LB \
  --backend-pool-name vmss2LBBEPool \
  --backend-port 80 \
  --frontend-ip-name loadBalancerFrontEnd \
  --frontend-port 80 \
  --protocol tcp

az network public-ip show \
  --resource-group apigee \
  --name vmss2LBPublicIP \
  --query '[ipAddress]' \
  --output tsv




  az vmss delete \
    --resource-group apigee \
    --name vmss2

  # az network lb address-pool delete -g apigee --lb-name test-rotuing -n pool1
  # az vmss update --resource-group apigee --name vmss-rmp --remove virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools 0
