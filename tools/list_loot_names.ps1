$ErrorActionPreference = 'Stop'

$root = Join-Path $PSScriptRoot '..'
$eventsPath = Join-Path (Join-Path (Join-Path $root 'LootWeaponStartMod') 'data') 'events_special_storage.xml.append'

if (-not (Test-Path $eventsPath)) {
  Write-Error "Events file not found: $eventsPath"
}

$content = Get-Content -Raw -Encoding UTF8 $eventsPath

$weaponNames = [System.Text.RegularExpressions.Regex]::Matches($content, 'weapon name="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
$droneNames = [System.Text.RegularExpressions.Regex]::Matches($content, 'drone name="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }

Write-Output "Weapons:"
$weaponNames | Sort-Object -Unique
Write-Output "Drones:"
$droneNames | Sort-Object -Unique
