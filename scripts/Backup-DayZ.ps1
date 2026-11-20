[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$DayZPath,
    [Parameter(Mandatory)][string]$BackupRoot,
    [Parameter(Mandatory)][ValidatePattern('^[\p{L}\p{N}_-][\p{L}\p{N} _.\-]*\z')][string]$ProfileName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'DayZPaths.ps1')

$target = Resolve-SafeDirectory $DayZPath
$root = Resolve-SafeDirectory $BackupRoot
if (Test-InDirectory $root $target) {
    throw 'Choose a backup root outside the DayZ configuration directory.'
}
$names = @('DayZ.cfg', "${ProfileName}_settings.DayZProfile")

$sources = foreach ($name in $names) { Get-SafeFile $target $name }
$folderName = 'DayZ-backup-{0}-{1}' -f [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssZ'), [guid]::NewGuid().ToString('N')
$snapshot = Join-Path $root $folderName
[void][IO.Directory]::CreateDirectory($snapshot)
try {
    foreach ($source in $sources) {
        [IO.File]::Copy($source, (Join-Path $snapshot ([IO.Path]::GetFileName($source))))
    }
    [IO.File]::WriteAllText((Join-Path $snapshot 'complete.txt'), 'DayZ configuration snapshot v1')
} catch {
    throw "Backup incomplete at '$snapshot'. No source files were changed. $($_.Exception.Message)"
}
$snapshot
