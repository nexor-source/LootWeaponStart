$ErrorActionPreference = 'Stop'

$autoBp = 'D:\GAMES\STEAM\steamapps\common\FTL Faster Than Light\mods\Multiverse 5.5 - Data\data\autoBlueprints.xml.append'
$bpPath = 'D:\GAMES\STEAM\steamapps\common\FTL Faster Than Light\mods\Multiverse 5.5 - Data\data\blueprints.xml.append'

if (-not (Test-Path $autoBp)) { Write-Error "autoBlueprints not found: $autoBp" }
if (-not (Test-Path $bpPath)) { Write-Error "Blueprints not found: $bpPath" }

$auto = Get-Content -Raw -Encoding UTF8 $autoBp
$bp = Get-Content -Raw -Encoding UTF8 $bpPath

$lists = @('LIST_LOOT_AUTO','LIST_LOOT_ENGI','LIST_LOOT_SEPARATIST','LIST_LOOT_ESTATE','LIST_LOOT_AUG')

foreach ($list in $lists) {
  $block = [Regex]::Match($auto, '<blueprintList name="' + [Regex]::Escape($list) + '">([\s\S]*?)</blueprintList>').Groups[1].Value
  if (-not $block) { Write-Output ($list + ': not found'); continue }
  $names = [Regex]::Matches($block, '<name>([^<]+)</name>') | % { $_.Groups[1].Value } | Sort-Object -Unique
  $costs = @()
  foreach ($n in $names) {
    # Try drone blueprint cost
    $m = [Regex]::Match($bp, '<droneBlueprint name="' + [Regex]::Escape($n) + '"[\s\S]*?<cost>(\d+)</cost>')
    if ($m.Success) { $costs += [int]$m.Groups[1].Value; continue }
    # Try weapon blueprint (some lists might include weapons)
    $m = [Regex]::Match($bp, '<weaponBlueprint name="' + [Regex]::Escape($n) + '"[\s\S]*?<cost>(\d+)</cost>')
    if ($m.Success) { $costs += [int]$m.Groups[1].Value; continue }
    # Try augment
    $m = [Regex]::Match($bp, '<augBlueprint name="' + [Regex]::Escape($n) + '"[\s\S]*?<cost>(\d+)</cost>')
    if ($m.Success) { $costs += [int]$m.Groups[1].Value; continue }
  }
  if ($costs.Count -gt 0) {
    $avg = [Math]::Round(($costs | Measure-Object -Average).Average)
    $min = ($costs | Measure-Object -Minimum).Minimum
    $max = ($costs | Measure-Object -Maximum).Maximum
    Write-Output ("{0}: avg={1}, min={2}, max={3}, n={4}" -f $list,$avg,$min,$max,$costs.Count)
  } else {
    Write-Output ($list + ': no costs resolved')
  }
}
