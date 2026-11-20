function Resolve-SafeDirectory {
    param([string]$Path)
    $full = [IO.Path]::GetFullPath($Path)
    for ($directory = [IO.DirectoryInfo]::new($full); $null -ne $directory; $directory = $directory.Parent) {
        if (Test-Path -LiteralPath $directory.FullName) {
            $item = Get-Item -LiteralPath $directory.FullName -Force
            if (-not $item.PSIsContainer -or ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
                throw "Expected a directory without junctions or symbolic links: $($directory.FullName)"
            }
        }
    }
    return $full
}

function Test-InDirectory {
    param([string]$Path, [string]$Parent)
    $comparison = [StringComparison]::OrdinalIgnoreCase
    $parentPrefix = $Parent.TrimEnd('\', '/') + '\'
    return ($Path.TrimEnd('\', '/') + '\').StartsWith($parentPrefix, $comparison)
}

function Get-SafeFile {
    param([string]$Directory, [string]$Name)
    $path = Join-Path $Directory $Name
    $item = Get-Item -LiteralPath $path -Force
    if ($item.PSIsContainer -or ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        throw "Expected a regular configuration file: $path"
    }
    return $item.FullName
}
