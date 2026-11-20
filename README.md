# DayZ performance baseline

The recorded baseline is **approximately 212 FPS** from a gameplay observation. The scene, server conditions, measurement window and frame-time data were not recorded. The goal is **240+ FPS at 2560×1600** while retaining image quality.

| Component | Hardware |
| --- | --- |
| Laptop | Acer Predator Helios Neo 16 AI PHN16-73 |
| CPU | Intel Core Ultra 9 275HX |
| GPU | NVIDIA GeForce RTX 5070 Laptop GPU, 8 GB |
| RAM | 32 GB DDR5 |
| Display | 2560×1600, 240 Hz |

- [Recorded graphics values](baseline/graphics.md)
- [NVIDIA, Windows power and PredatorSense](docs/system-settings.md)
- [Benchmark log and next test](docs/benchmarks.md)

## Back up and restore

Close DayZ before running either script. Use the actual DayZ configuration folder and replace `YourProfile` with the part of your existing filename before `_settings.DayZProfile`. Pick a private local backup directory outside the DayZ folder. The scripts handle only `DayZ.cfg` and the selected settings profile. The latter can include recent server details.

```powershell
$dayz = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'DayZ'
$backups = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'DayZConfigBackups'
$snapshot = .\scripts\Backup-DayZ.ps1 -DayZPath $dayz -BackupRoot $backups -ProfileName 'YourProfile'
$snapshot
.\scripts\Restore-DayZ.ps1 -DayZPath $dayz -BackupRoot $backups -SnapshotPath $snapshot -ProfileName 'YourProfile' -WhatIf
.\scripts\Restore-DayZ.ps1 -DayZPath $dayz -BackupRoot $backups -SnapshotPath $snapshot -ProfileName 'YourProfile'
```

Restore prompts before writing and creates a fresh backup of the destination. Restore accepts snapshots created for the same profile name. The baseline values are a reference for manual comparison.

## Publication

The original local Git commit contains personal filenames, server details and binary gameplay state. Before pushing, verify that every commit reachable from the branch or tag you plan to publish contains only reviewed files. If the original commit was never pushed, amending it can remove the raw files from the branch history. The previous commit can remain in the local reflog. Review the commit author and committer identities before publishing.
