#!/bin/bash
# pyXRD_EDS_XAS_Env-v1 一键构建脚本
# 生成日期: 2026-07-28
# 构建产物: pyXRD_EDS_XAS_Env-v1.tar.gz

set -euo pipefail

ENV_NAME="pyXRD_EDS_XAS_Env-v1"
PYTHON_VERSION="3.12"

echo "============================================"
echo " pyXRD_EDS_XAS_Env-v1 环境构建脚本"
echo " Python ${PYTHON_VERSION} | Linux x86_64"
echo "============================================"
echo ""

# 检查 conda 是否可用
if ! command -v conda &> /dev/null; then
    echo "[ERROR] conda 未找到, 请先安装 Miniconda3"
    exit 1
fi

source "$(conda info --base)/etc/profile.d/conda.sh"

# 清理旧环境
if conda env list | grep -q "^${ENV_NAME} "; then
    echo "[INFO] 移除已存在的环境 ${ENV_NAME} ..."
    conda env remove -n "${ENV_NAME}" -y
fi

# 1. 创建 Python 3.12 环境
echo "[STEP 1/8] 创建 Python ${PYTHON_VERSION} 环境 ..."
conda create -n "${ENV_NAME}" "python=${PYTHON_VERSION}" -y
conda activate "${ENV_NAME}"

# 2. 安装 pymatgen 2025.10.7
echo "[STEP 2/8] 安装 pymatgen 2025.10.7 (兼容版本) ..."
pip install 'pymatgen==2025.10.7'

# 3. 安装 crystal_toolkit + pymatviz
echo "[STEP 3/8] 安装 crystal_toolkit + pymatviz ..."
pip install crystal-toolkit pymatviz

# 4. 安装 hyperspy + 仪器格式支持
echo "[STEP 4/8] 安装 hyperspy + rosettasciio ..."
pip install 'hyperspy[all]' rosettasciio

# 5. 安装 xraylarch
echo "[STEP 5/8] 安装 xraylarch ..."
pip install xraylarch

# 6. 安装 PyXplore
echo "[STEP 6/8] 安装 PyXplore (无依赖模式) ..."
pip install --no-deps PyXplore

# 7. 安装 jupyterlab + 交互工具
echo "[STEP 7/8] 安装 jupyterlab + 科学计算包 ..."
pip install jupyterlab ipywidgets ipympl ipykernel
pip install scikit-learn scikit-image pybaselines

# 8. 验证所有包
echo "[STEP 8/8] 验证环境 ..."
python3 -c "
import sys
errors = []
tests = [
    ('numpy', lambda: __import__('numpy')),
    ('scipy', lambda: __import__('scipy')),
    ('pandas', lambda: __import__('pandas')),
    ('matplotlib', lambda: __import__('matplotlib')),
    ('sklearn', lambda: __import__('sklearn')),
    ('sympy', lambda: __import__('sympy')),
    ('pymatgen', lambda: __import__('pymatgen')),
    ('crystal_toolkit', lambda: __import__('crystal_toolkit')),
    ('pymatviz', lambda: __import__('pymatviz')),
    ('ase', lambda: __import__('ase')),
    ('hyperspy', lambda: __import__('hyperspy')),
    ('rsciio', lambda: __import__('rsciio')),
    ('rsciio.edax', lambda: __import__('rsciio.edax')),
    ('larch', lambda: __import__('larch')),
    ('PyXplore', lambda: __import__('PyXplore')),
    ('jupyterlab', lambda: __import__('jupyterlab')),
    ('h5py', lambda: __import__('h5py')),
    ('dask', lambda: __import__('dask')),
    ('numba', lambda: __import__('numba')),
]
for name, test in tests:
    try:
        test()
        print(f'  [OK] {name}')
    except Exception as e:
        print(f'  [FAIL] {name}: {e}')
        errors.append(name)

if errors:
    print(f'\nERROR: {len(errors)} packages failed: {errors}')
    sys.exit(1)
else:
    print(f'\nAll {len(tests)} packages verified successfully!')
"

echo ""
echo "============================================"
echo " 环境构建完成!"
echo ""
echo " 打包命令:"
echo "   conda-pack -n ${ENV_NAME} -o ${ENV_NAME}.tar.gz --ignore-missing-files"
echo ""
echo " 用户安装:"
echo "   tar -xzf ${ENV_NAME}.tar.gz -C ~/miniconda3/envs/${ENV_NAME}"
echo "   source ~/miniconda3/envs/${ENV_NAME}/bin/activate"
echo "   conda-unpack"
echo "============================================"
