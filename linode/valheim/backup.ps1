# backup valheim server to current directory

get-content '.env' | ForEach-Object {
    $name, $value = $_.split('=')
    set-content env:\$name $value
}

$valheim_remote = "/home/$env:VALHEIM_USER/.config/unity3d/IronGate/Valheim/worlds_local/*"
$valheim_local = "./valheim-$((Get-Date).ToString("yyyyMMddhhmmss"))"
$scp_target = "$($env:VALHEIM_USER)@$($env:VALHEIM_SERVER):$valheim_remote"

if (!(Test-Path $valheim_local -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $valheim_local | Out-Null
}

Write-Host "backing up $scp_target to $valheim_local"
scp -r $scp_target $valheim_local
