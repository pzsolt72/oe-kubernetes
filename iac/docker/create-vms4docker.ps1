$file_content = Get-Content "./.secret" -raw
$file_content = [Regex]::Escape($file_content)
$file_content = $file_content -replace "(\\r)?\\n", [Environment]::NewLine
$configuration = ConvertFrom-StringData($file_content)
$configuration.'subscriptionId'


$susbscription = $configuration.'subscriptionId'
$resourceGroup = 'oe-docker-rg'
$vmName = 'oe_docker_vm'
$vmSize= 'Standard_DS1_v2'  #Standard_DS1_v2 Standard_D2as_v4
$adminUser = 'azureadm'
$adminPwd = $configuration.'vmAdminPassword'
$vnet = 'oe-docker-vnet'
$subnet = 'subnet-1'
$count = 2


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
    --size $vmSize `
    --count $count

for ($i = 0; $i -lt $count; $i++) {
    az vm extension set `
        --resource-group $resourceGroup `
        --vm-name "$vmName$i" --name customScript `
        --publisher Microsoft.Azure.Extensions `
        --version 2.0 `
        --settings ./iac/docker/custom-script-config.json
   
}


az vm list-ip-addresses -g $resourceGroup  --query "[].virtualMachine.network.publicIpAddresses[].ipAddress" -o tsv

az group delete --resource-group $resourceGroup --yes

