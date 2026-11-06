param(
    [Parameter(Mandatory=$false)]
    [string]$Zone = "us-central1-a",
    [string]$VmName = "devops-k3s-vm"
)

Write-Host "Eliminando instancia $VmName..." -ForegroundColor Yellow
gcloud compute instances delete $VmName --zone=$Zone --quiet

Write-Host "Eliminando reglas de firewall..." -ForegroundColor Yellow
gcloud compute firewall-rules delete devops-k3s-allow-ssh devops-k3s-allow-http --quiet

Write-Host "Limpieza completada exitosamente." -ForegroundColor Green
