$ErrorActionPreference = 'Stop'

$dir = 'D:\GAMES\STEAM\steamapps\common\FTL Faster Than Light\mods\Multiverse 5.5 - Data\data'
if (-not (Test-Path $dir)) { Write-Error "Dir not found: $dir" }

$files = Get-ChildItem $dir -Filter 'events*.xml*'
foreach ($f in $files) {
  $i = 0
  foreach ($line in Get-Content -Encoding UTF8 $f.FullName) {
    $i++
    if ($line -match 'req="SCRAP' -or $line -match '<item type="scrap"' -or $line -match '<pay' -or $line -match 'loseScrap' -or $line -match '<cost' -or $line -match '<choice ' -and $line -match 'cost=' -or $line -match 'bribe') {
      Write-Output ("{0}:{1}: {2}" -f $f.Name,$i,$line)
    }
  }
}
