$susbscription = 'a8f77654-9254-4d5f-9c61-712b81de23c6'
$resourceGroup = 'oe-docker-rg'
$vmName = 'oe-docker-vm'
$adminUser = 'azureadm'
$adminPwd = 'Azureadm1234.'
$vnet = 'oe-docker-vnet'
$subnet = 'subnet-1'
$count = 2
$installDocker = 'https://github.com/pzsolt72/oe-kubernetes/blob/feature-docker/iac/install-docker.sh'


az account set --subscription $susbscription


az group create --location westeurope --resource-group $resourceGroup

az network vnet create `
    --name oe-docker-vnet `
    --resource-group $resourceGroup `
    --address-prefix 10.0.0.0/16 `
    --subnet-name subnet-1 `
    --subnet-prefixes 10.0.0.0/24

az vm create `
    --resource-group $resourceGroup `
    --name $vmName `
    --image Ubuntu2204  `
    --public-ip-sku Standard `
    --admin-username $adminUser `
    --admin-password $adminPwd `
    --vnet-name $vnet `
    --subnet $subnet `
    --count $count


az vm extension set `
    --resource-group $resourceGroup `
    --vm-name $vmName'0' --name customScript `
    --publisher Microsoft.Azure.Extensions `
    --version 2.0 `
    --settings ./iac/custom-script-config.json


az group delete --resource-group $reysourceGroup

