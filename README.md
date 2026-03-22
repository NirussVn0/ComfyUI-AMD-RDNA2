<div align="center">

![PyTorch ROCm Native for AMD](https://img.shields.io/badge/PyTorch-ROCm%20Native-red?style=for-the-badge&logo=amd&logoColor=white)
![RDNA2 Support](https://img.shields.io/badge/Support-RX%206000%20(RDNA2)-brightgreen?style=for-the-badge)
[![GitHub](https://img.shields.io/badge/GitHub-NirussVn0-181717?style=for-the-badge&logo=github)](https://github.com/NirussVn0)

[![Python 3.12](https://img.shields.io/badge/Python-3.12-blue?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![ROCm](https://img.shields.io/badge/ROCm-7.2-ff69b4?style=flat-square&logo=amd)](https://rocm.docs.amd.com)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.10.0%2Brocm-ee4c2c?style=flat-square&logo=pytorch)](https://pytorch.org)
[![License](https://img.shields.io/badge/License-GPL--3.0-lightgrey?style=flat-square)](LICENSE)

</div>

# ComfyUI PyTorch ROCm Native for AMD Radeon RX 6000 (RDNA 2) 

This guide walks you through setting up **PyTorch ROCm Native ComfyUI** on Windows for AMD RDNA 2 GPUs (RX 6600, 6700, 6800, 6900, etc.) using a custom ROCm build. All steps have been tested on an **RX 6800**.

> **Maintainer**: [NirussVn0](https://github.com/NirussVn0) – contributions and improvements are welcome!

---

## 📋 System Requirements

- **OS**: Windows 10/11 (64‑bit)
- **GPU**: AMD Radeon RX 6000 series (RDNA 2)
- **RAM**: 16 GB+ | **Disk**: 20+ GB free
- **Drivers**: Latest AMD Adrenalin (25.6.1 or newer)
- **Software**: 
  - [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe) (Select "Desktop development with C++")
  - [Python 3.12](https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe) (Check **"Add Python to PATH"** during install)
  - [Git for Windows](https://git-scm.com/download/win)

---

## 📦 Step 1: Download Required Files & Clone Repo

Since MediaFire does not allow direct script downloads, please download these manually.

1. Go to [this MediaFire folder](https://app.mediafire.com/folder/mvrwkgj96lkua).
2. Download all 7 files.
3. Open a Command Prompt, clone the repo, and arrange the downloaded files structurally:

```cmd
git clone https://github.com/NirussVn0/ComfyUI-AMD-RDNA2.git
cd ComfyUI-AMD-RDNA2
mkdir rocm
```

Place the downloaded files inside the `rocm` folder so your directory looks exactly like this:

```text
ComfyUI-AMD-RDNA2/
└── rocm/
    ├── rocm-7.12.0.dev0.tar.gz
    ├── rocm_sdk_core-7.12.0.dev0-py3-none-win_amd64.whl
    ├── rocm_sdk_devel-7.12.0.dev0-py3-none-win_amd64.whl
    ├── rocm_sdk_libraries_gfx103x_all-7.12.0.dev0-py3-none-win_amd64.whl
    ├── torch-2.10.0+devrocm7.12.0.dev0-cp312-cp312-win_amd64.whl
    ├── torchaudio-2.10.0+devrocm7.12.0.dev0-cp312-cp312-win_amd64.whl
    └── torchvision-0.25.0+devrocm7.12.0.dev0-cp312-cp312-win_amd64.whl
```

---

## 🚀 Step 2: Automated Installation

For convenience and speed, we've bundled the entire setup into an automated script. This script creates the virtual environment, installs the required packages, patches `sageattention`, and generates the bypass for NVIDIA dummy modules automatically.

1. Locate the **`install.bat`** file inside your `ComfyUI-AMD-RDNA2` folder.
2. Double-click it to run.
3. A command prompt window with a cool ROCm setup GUI will appear. Read the prompts and press any key to let the script automatically configure everything for you.

*(If you're on Linux, a similar approach inside a bash `.sh` script would apply, using the equivalent Linux ROCm wheels.)*

---

## ▶️ Step 3: Run ComfyUI

Create a file named `run_amd.bat` (or `.sh`) in the main folder:

```batch
@echo off
call venv\Scripts\activate
set PYTORCH_HIP_ALLOC_CONF=expandable_segments:True
python main.py --windows-standalone-build --use-pytorch-cross-attention --disable-smart-memory
pause
```

Double‑click it to launch! Access the UI at `http://127.0.0.1:8188`.
*If you see a red error message saying no model is found, place a checkpoint (`.safetensors`) into `models\checkpoints\`.*

---

## 🧪 Testing & Troubleshooting

- **No module named 'comfy_aimdo.xxx'**: Just re-run the `create_dummy.py` script to generate any missing bypassed modules.
- **CUDA/HIP Errors**: Update AMD drivers and add `--disable-cuda-malloc` to your launch command.
- **Performance**: The first generation will be slow due to kernel compilation. Subsequent runs are much faster. Add `PYTORCH_TUNABLEOP_ENABLED=1` for potential long-term speedup.
- **Out of Memory**: Add `--lowvram` to the launch arguments.

---

## 🙏 Credits

- Original ComfyUI by [comfyanonymous](https://github.com/comfyanonymous)
- ROCm community efforts
- **[NirussVn0](https://github.com/NirussVn0)** – testing and compiling this ROCm Native RDNA 2 setup.

---

## 📜 License

- **ComfyUI Core**: Licensed under [GPL-3.0](https://github.com/comfyanonymous/ComfyUI/blob/master/LICENSE).
- **Automation Scripts & Guide**: Provided by [NirussVn0/ComfyUI-AMD-RDNA2](https://github.com/NirussVn0/ComfyUI-AMD-RDNA2).

<div align="center">
  <sub>Made with 💙 by <b>NirussVn0</b> for the AMD community.</sub>
</div>