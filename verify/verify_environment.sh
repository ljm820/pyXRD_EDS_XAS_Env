# pyXRD_EDS_XAS_Env 环境验证脚本
# 用于验证 conda 环境是否正确安装

echo "============================================"
echo " pyXRD_EDS_XAS_Env 环境验证"
echo "============================================"
echo ""

ENV_NAME="${1:-}"
if [ -z "$ENV_NAME" ]; then
    echo "Usage: bash verify_environment.sh <env_name>"
    echo "Example: bash verify_environment.sh pyXRD_EDS_XAS_Env-v1"
    exit 1
fi

# 检查 conda 环境是否存在
if ! conda env list | grep -q "^${ENV_NAME} "; then
    echo "[ERROR] 环境 ${ENV_NAME} 不存在"
    exit 1
fi

source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${ENV_NAME}"

echo "Python: $(python3 --version)"
echo ""

FAILED=0
TOTAL=0

check_import() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local module="$2"
    if python3 -c "import ${module}" 2>/dev/null; then
        echo "  [OK] ${name}"
    else
        echo "  [FAIL] ${name}"
        FAILED=$((FAILED + 1))
    fi
}

check_version() {
    TOTAL=$((TOTAL + 1))
    local name="$1"
    local code="$2"
    local result
    result=$(python3 -c "${code}" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$result" ]; then
        echo "  [OK] ${name}: ${result}"
    else
        echo "  [FAIL] ${name}"
        FAILED=$((FAILED + 1))
    fi
}

echo "--- 核心科学计算 ---"
check_version "numpy"      "import numpy; print(numpy.__version__)"
check_version "scipy"      "import scipy; print(scipy.__version__)"
check_version "pandas"     "import pandas; print(pandas.__version__)"
check_version "matplotlib" "import matplotlib; print(matplotlib.__version__)"
check_version "sklearn"    "import sklearn; print(sklearn.__version__)"
check_version "sympy"      "import sympy; print(sympy.__version__)"

echo ""
echo "--- 材料科学 ---"
check_version "pymatgen"   "import pymatgen; print(pymatgen.__version__)"
check_version "ase"        "import ase; print(ase.__version__)"

echo ""
echo "--- EDS/XAS/XRD ---"
check_version "hyperspy"   "import hyperspy; print(hyperspy.__version__)"
check_import  "rsciio"     "rsciio"
check_import  "EDAX"       "rsciio.edax"
check_import  "xraylarch"  "larch"
check_import  "PyXplore"   "PyXplore"

echo ""
echo "--- 可视化 (v1 only) ---"
python3 -c "import crystal_toolkit" 2>/dev/null && echo "  [OK] crystal_toolkit" || echo "  [INFO] crystal_toolkit not installed (v0 expected)"
python3 -c "import pymatviz" 2>/dev/null && echo "  [OK] pymatviz" || echo "  [INFO] pymatviz not installed (v0 expected)"

echo ""
echo "--- 交互开发 ---"
check_import  "jupyterlab"  "jupyterlab"
check_import  "h5py"        "h5py"
check_import  "dask"        "dask"
check_import  "numba"       "numba"

echo ""
echo "============================================"
echo " Results: ${FAILED}/${TOTAL} failed"
if [ $FAILED -eq 0 ]; then
    echo " Environment verification PASSED!"
else
    echo " Environment verification FAILED!"
    exit 1
fi
echo "============================================"
