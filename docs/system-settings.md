# NVIDIA, Windows power and PredatorSense

Local read-only inspection confirmed an NVIDIA GeForce RTX 5070 Laptop GPU with driver **621.24** and **8151 MiB** reported by `nvidia-smi`. The active Windows power plan was **Balanced**. These are observations from the documentation session. The conditions of the original FPS observation were not recorded.

| Setting to record | Status |
| --- | --- |
| NVIDIA Control Panel, DayZ program profile | Unverified |
| Windows per-app graphics preference for DayZ | Unverified |
| PredatorSense operating mode and fan profile | Unverified |
| GPU routing or MUX mode | Unverified |
| AC power during the original reading | Unrecorded |

Before the next run, open NVIDIA Control Panel → Manage 3D settings → Program Settings and record any DayZ-specific overrides, including power management, frame limiter and sync. In PredatorSense, record the current operating mode and fan setting. Record the configured GPU routing if exposed and whether AC power is connected. Keep these conditions fixed across the comparison.

```powershell
powercfg /getactivescheme
nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv
```
