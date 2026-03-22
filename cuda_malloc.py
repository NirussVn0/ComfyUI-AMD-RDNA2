import sys
import importlib.metadata

def get_torch_version_noimport():
    try:
        if 'torch' in sys.modules:
            return sys.modules['torch'].__version__
        return importlib.metadata.version('torch')
    except:
        return ""

blacklist = [
    "GeForce GTX 16",
    "GeForce GTX 15",
    "GeForce GTX 10",
    "GeForce GTX 9",
    "GeForce GTX 8",
    "GeForce GTX 7",
]
