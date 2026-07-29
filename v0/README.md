# pyXRD_EDS_XAS_ENV 科学仪器数据分析 Python 环境

## 环境概述

| 项目 | 详情 |
|------|------|
| **环境名称** | `pyXRD_EDS_XAS_ENV` |
| **Python 版本** | 3.11.15 |
| **打包方式** | conda-pack (Miniconda3) |
| **压缩包大小** | 755 MB |
| **解压后大小** | ~2.5 GB |
| **操作系统** | Linux x86_64 (glibc 2.17+) |

## 核心功能模块

| 模块 | 包名 | 版本 | 功能 |
|------|------|------|------|
| **EDS/仪器数据读取** | hyperspy | 2.4.0 | 多维光谱图像分析 |
| | rosettasciio | 0.14.0 | 40+ 科学仪器格式读写 (含 EDAX) |
| **XAS 吸收谱分析** | xraylarch | 2026.2.2 | XAS/EXAFS/XANES/XRF/XRD 分析 |
| **XRD 衍射谱精修** | PyXplore (PyWPEM) | 2026.7.22 | AI 驱动 XRD 全谱精修 |
| **材料科学计算** | pymatgen | 2026.5.4 | 晶体结构、相图、电子结构分析 |
| | ase | 3.26.0 | 原子尺度模拟环境 |
| **核心计算** | numpy | 2.4.6 | 数值计算 |
| | scipy | 1.15.3 | 科学计算 |
| | pandas | 2.3.3 | 数据处理 |
| | scikit-learn | 1.7.2 | 机器学习 |
| | sympy | 1.14.0 | 符号计算 |
| | matplotlib | 3.11.1 | 数据可视化 |
| **交互开发** | jupyterlab | 4.6.2 | 交互式笔记本 |

## 不兼容说明

以下包因与 pymatgen 2026.x 存在根本性 API 不兼容已被移除：

- **crystal_toolkit** - 依赖 pymatgen 旧版 API (`Lattice` 从 `pymatgen.core` 导入)
- **pymatviz** - 依赖 pymatgen 旧版 API (`Composition` 从 `pymatgen.core` 导入)

如需使用这些包，建议创建单独环境并安装 pymatgen < 2025 版本。

---

## 一、使用 conda-pack 安装 (已生成)

### 1. 解压环境

```bash
mkdir -p ~/miniconda3/envs
tar -xzf pyXRD_EDS_XAS_ENV.tar.gz -C ~/miniconda3/envs/pyXRD_EDS_XAS_ENV
```

### 2. 激活环境

```bash
source ~/miniconda3/envs/pyXRD_EDS_XAS_ENV/bin/activate
# 或
conda activate ~/miniconda3/envs/pyXRD_EDS_XAS_ENV
```

### 3. 验证安装

```bash
python -c "
import hyperspy; print('hyperspy:', hyperspy.__version__)
import rsciio; print('rosettasciio: OK')
import larch; print('xraylarch: OK')
import PyXplore; print('PyXplore: OK')
import pymatgen; print('pymatgen: OK')
import jupyterlab; print('jupyterlab: OK')
print('All OK')
"
```

---

## 二、从零构建 (Miniconda3 方式)

### 步骤 1: 安装 Miniconda3

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/miniconda3
source ~/miniconda3/bin/activate
conda init bash
```

### 步骤 2: 创建 Python 3.11 环境

```bash
conda create -n pyXRD_EDS_XAS_ENV python=3.11 -y
conda activate pyXRD_EDS_XAS_ENV
```

### 步骤 3: 安装核心科学计算包

```bash
# 基础科学计算
pip install numpy scipy pandas matplotlib sympy scikit-learn
```

### 步骤 4: 安装 EDS/仪器数据读取

```bash
# rosettasciio (科学仪器格式读写核心)
pip install 'rosettasciio[all]'

# hyperspy (多维光谱数据分析)
pip install 'hyperspy[all]'
```

### 步骤 5: 安装 XAS 分析

```bash
pip install xraylarch
```

### 步骤 6: 安装 XRD 分析

```bash
# PyWPEM 已发布为 PyXplore
pip install PyXplore --no-deps
```

### 步骤 7: 安装交互开发环境

```bash
pip install jupyterlab
```

### 步骤 8: 导出环境配置

```bash
pip freeze > pyXRD_EDS_XAS_ENV_requirements.txt
```

---

## 三、从零构建 (uv + pyenv 方式)

### 前置条件

```bash
# 安装 pyenv (管理 Python 版本)
curl https://pyenv.run | bash

# 安装 uv (快速包管理器)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 步骤 1: 安装 Python 3.11

```bash
pyenv install 3.11.15
pyenv local 3.11.15
```

### 步骤 2: 创建虚拟环境

```bash
uv venv pyXRD_EDS_XAS_ENV --python 3.11
source pyXRD_EDS_XAS_ENV/bin/activate
```

### 步骤 3: 安装所有包

```bash
uv pip install numpy scipy pandas matplotlib sympy scikit-learn
uv pip install 'rosettasciio[all]'
uv pip install 'hyperspy[all]'
uv pip install xraylarch
uv pip install PyXplore --no-deps
uv pip install jupyterlab
```

### 步骤 4: 锁定依赖

```bash
uv pip freeze > requirements-lock.txt
```

---

## 四、使用示例

### 1. EDAX EDS 谱图读取

```python
import hyperspy as hs

# 读取 EDAX .spc/.spx 格式
spectrum = hs.load('sample.spc')
print(spectrum)

# 读取其他仪器格式
# .dm3/.dm4 (Gatan Digital Micrograph)
# .msa (EMSA/MSA)
# .emd (Velox)
# .bcf (Bruker)
# .rpl (Bruker)
# .ser/.emi (TIA)
# .mrc (MRC)
# .hdf5 (通用)
# 等 40+ 种格式
```

### 2. XAS 吸收谱分析 (xraylarch)

```python
from larch.io import read_ascii

# 读取 XAFS 数据
dat = read_ascii('sample_xas.dat')

# 归一化与背景扣除
dat.pre_edge.energy = dat.energy
dat.pre_edge()

# EXAFS 分析
from larch.xafs import autobk
autobk(dat, rbkg=1.0, kweight=2)

# 查看结果
print(dat.k, dat.chi)
```

### 3. XRD 衍射谱精修 (PyWPEM/PyXplore)

```python
from PyXplore import WPEM

# AI 驱动的 XRD 全谱精修
wpem = WPEM.WPEM(
    data_file='sample_xrd.xy',
    wavelength=1.5406,  # Cu K-alpha
)

wpem.run()

# 获取精修结果
refinement = wpem.get_results()
print(refinement)
```

### 4. 材料晶体结构分析 (pymatgen + ase)

```python
from pymatgen.core import Structure
from ase.io import read

# 读取 CIF 文件
structure = Structure.from_file('crystal.cif')
print(structure)

# 读取 XYZ 文件
atoms = read('molecule.xyz')
print(atoms.get_positions())
```

### 5. JupyterLab 启动

```bash
conda activate pyXRD_EDS_XAS_ENV
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
```

---

## 五、支持的仪器数据格式 (rosettasciio)

| 厂商/格式 | 扩展名 | 读取器模块 |
|-----------|--------|------------|
| **EDAX** | .spc, .spx | rsciio.edax |
| Bruker | .spx, .bcf | rsciio.bruker |
| Gatan DM | .dm3, .dm4 | rsciio.digitalmicrograph |
| FEI/TFS | .emi, .ser | rsciio.tia |
| Velox (ThermoFisher) | .emd | rsciio.emd |
| EMSA/MSA | .msa | rsciio.msa |
| MRC | .mrc | rsciio.mrc |
| HDF5 | .hdf5, .h5 | rsciio.hdf5 (通过 h5py) |
| TIFF | .tif, .tiff | rsciio.tiff |
| JEOL | .map, .pts | rsciio.jeol |
| Digital Surf | .sur, .pro | rsciio.digitalsurf |
| Renishaw Raman | .wdf | rsciio.renishaw |
| TopSpin NMR | .1r | rsciio.topspin |
| 通用文本 | .csv, .txt, .dat | rsciio.msa |

完整列表：https://hyperspy.org/rosettasciio/supported_formats/index.html

---

## 六、版本兼容性矩阵

| Python | hyperspy | xraylarch | rosettasciio | pymatgen | PyXplore |
|--------|----------|-----------|-------------|----------|----------|
| 3.10 | 2.4.0 | 2026.2.2 | 0.14.0 | - | - |
| **3.11** | **2.4.0** | **2026.2.2** | **0.14.0** | **2026.5.4** | **2026.7.22** |
| 3.12 | 2.4.0 | 2026.2.2 | 0.14.0 | 2026.5.4 | 2026.7.22 |
| 3.13 | 2.4.0 | 2026.2.2 | 0.14.0 | 2026.5.4 | 2026.7.22 |
| 3.14 | 2.4.0 | 2026.2.2 | 0.14.0 | 2026.5.4 | - |

**推荐 Python 3.11**：所有包均稳定支持，生产环境首选。

---

## 七、环境导出与迁移

### 导出已安装包列表

```bash
pip freeze > requirements.txt
```

### 导出 conda 环境配置

```bash
conda env export -n pyXRD_EDS_XAS_ENV > environment.yml
```

### 使用 conda-pack 打包 (已执行)

```bash
conda install -n base conda-pack -c conda-forge -y
conda pack -n pyXRD_EDS_XAS_ENV -o pyXRD_EDS_XAS_ENV.tar.gz
```

---

## 八、自动化构建脚本

以下脚本可一键构建完整环境：

```bash
#!/bin/bash
# build_pyXRD_EDS_XAS_ENV.sh
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
import ase; print('OK: ase')
import jupyterlab; print('OK: jupyterlab')
"

echo "=== Environment build complete ==="
echo "Location: $(conda info --base)/envs/$ENV_NAME"
echo "Activate: conda activate $ENV_NAME"
```

### 使用方法

```bash
chmod +x build_pyXRD_EDS_XAS_ENV.sh
./build_pyXRD_EDS_XAS_ENV.sh
```

---

## 九、获取压缩包

已生成的压缩包位于工作区：`/workspace/pyXRD_EDS_XAS_ENV.tar.gz` (755 MB)

可通过界面左侧「项目文件」面板下载。
