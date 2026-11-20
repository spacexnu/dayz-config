[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)][string]$DayZPath,
    [Parameter(Mandatory)][string]$BackupRoot,
    [Parameter(Mandatory)][ValidatePattern('^[\p{L}\p{N}_-][\p{L}\p{N} _.\-]*\z')][string]$ProfileName,
    [Parameter(Mandatory)][string]$SnapshotPath
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

$snapshot = Resolve-SafeDirectory $SnapshotPath
if ((Test-InDirectory $snapshot $target) -or (Test-InDirectory $target $snapshot)) {
    throw 'The snapshot and destination must be separate directories.'
}
$marker = Get-SafeFile $snapshot 'complete.txt'
if ([IO.File]::ReadAllText($marker) -cne 'DayZ configuration snapshot v1') {
    throw 'The selected folder is not a completed DayZ configuration snapshot.'
}
$sources = foreach ($name in $names) { Get-SafeFile $snapshot $name }
$destinations = foreach ($name in $names) { Get-SafeFile $target $name }

if (-not $PSCmdlet.ShouldProcess($target, "Back up current files and restore from '$snapshot'")) {
    return
}

$previous = & (Join-Path $PSScriptRoot 'Backup-DayZ.ps1') -DayZPath $target -BackupRoot $root -ProfileName $ProfileName
$staged = [System.Collections.Generic.List[string]]::new()
$replaced = 0
try {
    foreach ($source in $sources) {
        $temporary = Join-Path $target ('.dayz-restore-' + [guid]::NewGuid().ToString('N') + '.tmp')
        $staged.Add($temporary)
        [IO.File]::Copy($source, $temporary)
    }
    foreach ($destination in $destinations) {
        [IO.File]::Replace($staged[$replaced], $destination, [NullString]::Value)
        $replaced++
    }
} catch {
    throw "Restore stopped after replacing $replaced file(s). The pre-restore snapshot is '$previous'. $($_.Exception.Message)"
} finally {
    foreach ($temporary in $staged) {
        Remove-Item -LiteralPath $temporary -ErrorAction SilentlyContinue
    }
}
Write-Output "Restored $($names.Count) files. Pre-restore snapshot: $previous"
