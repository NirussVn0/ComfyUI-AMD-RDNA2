@echo off
call venv\Scripts\activate
set PYTORCH_HIP_ALLOC_CONF=expandable_segments:True
python main.py --windows-standalone-build --use-pytorch-cross-attention --disable-smart-memory
pause