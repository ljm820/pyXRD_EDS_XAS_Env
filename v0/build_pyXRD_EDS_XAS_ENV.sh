#!/bin/bash
# build_pyXRD_EDS_XAS_ENV.sh
# 一键构建 pyXRD_EDS_XAS_ENV 科学仪器数据分析 Python 环境
set -e

ENV_NAME="pyXRD_EDS_XAS_ENV"
PYTHON_VER="3.11"

echo "=== Creating conda environment: $ENV_NAME ==="
conda create -n "$ENV_NAME" python="$PYTHON_VER" -y
eval "$(conda shell.bash hook)"
conda activate "$ENV_NAME"

echo "=== Installing core scientific packages ==="
pip install numpy scipy pandas matplotlib sympy scikit-learn

echo "=== Installing EDS/Spectroscopy packages ==="
pip install 'rosettasciio[all]'
pip install 'hyperspy[all]'

echo "=== Installing XAS analysis (xraylarch) ==="
pip install xraylarch

echo "=== Installing XRD analysis (PyWPEM/PyXplore) ==="
pip install PyXplore --no-deps

echo "=== Installing JupyterLab ==="
pip install jupyterlab

echo "=== Verifying environment ==="
python -c "
import hyperspy; print('OK: hyperspy', hyperspy.__version__)
from rsciio.edax import file_reader; print('OK: EDAX reader')
import larch; print('OK: xraylarch')
import PyXplore; print('OK: PyXplore')
import pymatgen; print('OK: pymatgen')
import ase; print('OK: ase', ase.__version__)
import jupyterlab; print('OK: jupyterlab')
import numpy; print('OK: numpy', numpy.__version__)
import scipy; print('OK: scipy', scipy.__version__)
import pandas; print('OK: pandas', pandas.__version__)
import sklearn; print('OK: sklearn', sklearn.__version__)
import sympy; print('OK: sympy', sympy.__version__)
import matplotlib; print('OK: matplotlib', matplotlib.__version__)
print('ALL PACKAGES VERIFIED SUCCESSFULLY')
"

echo ""
echo "=== Environment build complete ==="
echo "Location: $(conda info --base)/envs/$ENV_NAME"
echo "Activate: conda activate $ENV_NAME"
echo ""
echo "To pack for distribution:"
echo "  conda install -n base conda-pack -c conda-forge -y"
echo "  conda pack -n $ENV_NAME -o ${ENV_NAME}.tar.gz"
