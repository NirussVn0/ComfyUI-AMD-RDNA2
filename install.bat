@echo off
cd /d "%~dp0"
color 0B
title ComfyUI ROCm Native Setup
echo ===============================================================================
echo.
echo   ██████╗ ██████╗ ███╗   ███╗███████╗██╗   ██╗██╗
echo  ██╔════╝██╔═══██╗████╗ ████║██╔════╝╚██╗ ██╔╝██║
echo  ██║     ██║   ██║██╔████╔██║█████╗   ╚████╔╝ ██║
echo  ██║     ██║   ██║██║╚██╔╝██║██╔══╝    ╚██╔╝  ██║
echo  ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║        ██║   ██║
echo   ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝        ╚═╝   ╚═╝
echo.
echo  ██████╗  ██████╗  ██████╗███╗   ███╗
echo  ██╔══██╗██╔═══██╗██╔════╝████╗ ████║
echo  ██████╔╝██║   ██║██║     ██╔████╔██║
echo  ██╔══██╗██║   ██║██║     ██║╚██╔╝██║
echo  ██║  ██║╚██████╔╝╚██████╗██║ ╚═╝ ██║
echo  ╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝     ╚═╝
echo.
echo ===============================================================================
echo            Automated AMD ROCm Environment Setup - by NirussVn0
echo ===============================================================================
echo.
echo Please ensure you have placed all 7 downloaded .whl and .tar.gz files 
echo from MediaFire into the 'rocm' folder before continuing.
echo.
pause

echo.
echo [1/6] Creating Python virtual environment...
py -3.12 -m venv venv
call venv\Scripts\activate
python -m pip install --upgrade pip

echo.
echo [2/6] Installing ComfyUI requirements...
pip install -r requirements.txt

echo.
echo [3/6] Installing ROCm ^& PyTorch (from local files)...
cd rocm
pip install rocm-7.12.0.dev0.tar.gz rocm_sdk_core-7.12.0.dev0-py3-none-win_amd64.whl rocm_sdk_devel-7.12.0.dev0-py3-none-win_amd64.whl rocm_sdk_libraries_gfx103x_all-7.12.0.dev0-py3-none-win_amd64.whl
pip install torch-2.10.0+devrocm7.12.0.dev0-cp312-cp312-win_amd64.whl torchaudio-2.10.0+devrocm7.12.0.dev0-cp312-cp312-win_amd64.whl torchvision-0.25.0+devrocm7.12.0.dev0-cp312-cp312-win_amd64.whl
cd ..

echo.
echo [4/6] Installing dependencies ^& bitsandbytes...
pip install triton-windows==3.6.0.post25 sageattention==1.0.6
pip install https://github.com/0xDELUXA/bitsandbytes_win_rocm/releases/download/v0.49.2.dev0-py312-rocm7.12/bitsandbytes-0.49.2.dev0-cp312-cp312-win_amd64.whl

echo.
echo [5/6] Patching SageAttention for RDNA 2...
curl -s -o venv\Lib\site-packages\sageattention\attn_qk_int8_per_block.py https://raw.githubusercontent.com/NirussVn0/ComfyUI-AMD-RDNA2/refs/heads/master/comfy/customzluda/sa/attn_qk_int8_per_block.py
curl -s -o venv\Lib\site-packages\sageattention\attn_qk_int8_per_block_causal.py https://raw.githubusercontent.com/NirussVn0/ComfyUI-AMD-RDNA2/refs/heads/master/comfy/customzluda/sa/attn_qk_int8_per_block_causal.py
curl -s -o venv\Lib\site-packages\sageattention\quant_per_block.py https://raw.githubusercontent.com/NirussVn0/ComfyUI-AMD-RDNA2/refs/heads/master/comfy/customzluda/sa/quant_per_block.py

echo.
echo [6/6] Creating dummy comfy_aimdo bypass modules via Python...
echo import os > create_dummy.py
echo import textwrap >> create_dummy.py
echo target_dir = r"venv\Lib\site-packages\comfy_aimdo" >> create_dummy.py
echo os.makedirs(target_dir, exist_ok=True) >> create_dummy.py
echo with open(os.path.join(target_dir, '__init__.py'), 'w', encoding='utf-8') as f: pass >> create_dummy.py
echo modules = ['model_vbar', 'host_buffer', 'torch', 'utils', 'model', 'quant', 'cuda', 'memory', 'offload', 'abc', 'base', 'core', 'common', 'kernel', 'cache', 'tensor', 'runtime', 'device', 'stream', 'allocator', 'pinned_memory', 'ops', 'taesd', 'cpu', 'hip', 'rocm', 'attention', 'flash', 'linear', 'conv', 'norm'] >> create_dummy.py
echo for mod in modules: >> create_dummy.py
echo     with open(os.path.join(target_dir, f'{mod}.py'), 'w', encoding='utf-8') as f: f.write("# Dummy module for AMD RDNA2 bypass\npass\n") >> create_dummy.py
echo control_code = textwrap.dedent(""" >> create_dummy.py
echo     def init(): pass >> create_dummy.py
echo     def init_device(device): return False >> create_dummy.py
echo     def set_log_debug(): pass >> create_dummy.py
echo     def set_log_critical(): pass >> create_dummy.py
echo     def set_log_error(): pass >> create_dummy.py
echo     def set_log_warning(): pass >> create_dummy.py
echo     def set_log_info(): pass >> create_dummy.py
echo     def get_total_vram_usage(*args, **kwargs): >> create_dummy.py
echo         try: >> create_dummy.py
echo             import torch >> create_dummy.py
echo             if torch.cuda.is_available(): return torch.cuda.memory_allocated() >> create_dummy.py
echo         except: pass >> create_dummy.py
echo         return 0 >> create_dummy.py
echo     def get_free_vram(*args, **kwargs): >> create_dummy.py
echo         try: >> create_dummy.py
echo             import torch >> create_dummy.py
echo             if torch.cuda.is_available(): return torch.cuda.mem_get_info()[0] >> create_dummy.py
echo         except: pass >> create_dummy.py
echo         return 16 * 1024**3 >> create_dummy.py
echo     def __getattr__(name): >> create_dummy.py
echo         def dummy(*args, **kwargs): return 0 >> create_dummy.py
echo         return dummy >> create_dummy.py
echo """).lstrip() >> create_dummy.py
echo with open(os.path.join(target_dir, 'control.py'), 'w', encoding='utf-8') as f: f.write(control_code) >> create_dummy.py
python create_dummy.py
del create_dummy.py

echo.
echo ===============================================================================
echo                           INSTALLATION COMPLETE!
echo ===============================================================================
echo You can now run run_amd.bat to start ComfyUI.
echo.
pause
