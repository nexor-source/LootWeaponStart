$ErrorActionPreference = 'Stop'

$bpPath = 'D:\GAMES\STEAM\steamapps\common\FTL Faster Than Light\mods\Multiverse 5.5 - Data\data\blueprints.xml.append'
$root = Join-Path $PSScriptRoot '..'
$eventsPath = Join-Path (Join-Path (Join-Path $root 'LootWeaponStartMod') 'data') 'events_special_storage.xml.append'

if (-not (Test-Path $bpPath)) { Write-Error "Blueprints not found: $bpPath" }
if (-not (Test-Path $eventsPath)) { Write-Error "Events not found: $eventsPath" }

$events = Get-Content -Raw -Encoding UTF8 $eventsPath
$bp = Get-Content -Raw -Encoding UTF8 $bpPath

$weaponNames = [System.Text.RegularExpressions.Regex]::Matches($events, 'weapon name="([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

foreach ($name in $weaponNames) {
  $pattern = '<weaponBlueprint name="' + $name + '"[\s\S]*?<cost>(\d+)</cost>'
  $m = [System.Text.RegularExpressions.Regex]::Match($bp, $pattern)
  if ($m.Success) {
    $cost = [int]$m.Groups[1].Value
    Write-Output "$name=$cost"
  } else {
    Write-Output "$name=?"
  }
}
