param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectId,
    [string]$Zone = "us-central1-a",
    [string]$VmName = "devops-k3s-vm"
)

Write-Host "Configurando proyecto y zona en Google Cloud..." -ForegroundColor Cyan
gcloud config set project $ProjectId
gcloud config set compute/zone $Zone

# 1. Reglas de firewall
Write-Host "Configurando reglas de firewall..." -ForegroundColor Cyan
$sshRule = gcloud compute firewall-rules list --filter="name=devops-k3s-allow-ssh" --format="value(name)"
if (-not $sshRule) {
    gcloud compute firewall-rules create devops-k3s-allow-ssh `
        --direction=INGRESS --priority=1000 --action=ALLOW `
        --rules=tcp:22 --source-ranges="38.7.14.68/32"
}

$httpRule = gcloud compute firewall-rules list --filter="name=devops-k3s-allow-http" --format="value(name)"
if (-not $httpRule) {
    gcloud compute firewall-rules create devops-k3s-allow-http `
        --direction=INGRESS --priority=1000 --action=ALLOW `
        --rules=tcp:80 --source-ranges="0.0.0.0/0"
}

# 2. Clave SSH
$pubKey = (Get-Content "$HOME\.ssh\id_ed25519.pub").Trim()
$sshMetadata = "azureuser:$pubKey"

# 3. Crear Instancia
Write-Host "Creando instancia Compute Engine con K3s..." -ForegroundColor Cyan
gcloud compute instances create $VmName `
    --zone=$Zone `
    --machine-type=e2-medium `
    --image-family=ubuntu-2404-lts-amd64 `
    --image-project=ubuntu-os-cloud `
    --boot-disk-size=32GB `
    --metadata=ssh-keys="$sshMetadata" `
    --metadata-from-file=startup-script="$PSScriptRoot\startup.sh"

$publicIp = gcloud compute instances describe $VmName --zone=$Zone --format="get(networkInterfaces[0].accessConfigs[0].natIP)"

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "Instancia aprovisionada con exito!" -ForegroundColor Green
Write-Host "IP Publica: $publicIp" -ForegroundColor Green
Write-Host "Comando SSH:" -ForegroundColor Yellow
Write-Host "ssh -i `$HOME\.ssh\id_ed25519 azureuser@$publicIp" -ForegroundColor White
Write-Host "========================================================`n" -ForegroundColor Green
