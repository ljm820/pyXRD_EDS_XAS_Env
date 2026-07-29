# pyXRD_EDS_XAS_Env-v1 科学仪器数据分析 Python 环境

## 环境概述

| 项目 | 详情 |
|------|------|
| **环境名称** | `pyXRD_EDS_XAS_Env-v1` |
| **Python 版本** | 3.12.13 |
| **打包方式** | conda-pack (Miniconda3) |
| **压缩包大小** | 592 MB |
| **解压后大小** | ~1.9 GB |
| **操作系统** | Linux x86_64 (glibc 2.17+) |

## 与 v0 (pyXRD_EDS_XAS_ENV) 的对比

| 特性 | v0 | v1 |
|------|-----|-----|
| Python | 3.11.15 | 3.12.13 |
| pymatgen | 2026.5.4 | 2025.10.7 |
| crystal_toolkit | 不支持 | 2026.7.20 |
| pymatviz | 不支持 | 0.18.0 |
| tensorflow | 已移除 | 未安装 |
| PyXplore | 正常安装 | --no-deps (避免依赖冲突) |
| 压缩包大小 | 755 MB | 592 MB |

## v1 核心改进

pymatgen 2026.x 重构了 `pymatgen.core` 成为命名空间包，导致 `crystal_toolkit` 和 `pymatviz` 中的 `from pymatgen.core import Lattice` 等导入失败。v1 通过使用 pymatgen 2025.10.7（同时提供 `pymatgen.core` 扁平 re-export 和 `pymatgen.core.graphs` 模块）实现了三个包的兼容共存。

## 核心功能模块

| 模块 | 包名 | 版本 | 功能 |
|------|------|------|------|
| **EDS/仪器数据读取** | hyperspy | 2.4.0 | 多维光谱图像分析 |
| | rosettasciio | 0.14.0 | 40+ 科学仪器格式读写 (含 EDAX) |
| **XAS 吸收谱分析** | xraylarch | 2026.2.2 | XAS/EXAFS/XANES/XRF/XRD 分析 |
| **XRD 衍射谱精修** | PyXplore (PyWPEM) | 2026.7.22 | AI 驱动 XRD 全谱精修 |
| **材料科学计算** | pymatgen | 2025.10.7 | 晶体结构、相图、电子结构分析 |
| | ase | 3.29.0 | 原子尺度模拟环境 |
| | crystal_toolkit | 2026.7.20 | Dash 组件晶体结构可视化 |
| | pymatviz | 0.18.0 | 材料科学可视化 |
| **核心计算** | numpy | 2.4.6 | 数值计算 |
| | scipy | 1.18.0 | 科学计算 |
| | pandas | 3.0.5 | 数据处理 |
| | scikit-learn | 1.9.0 | 机器学习 |
| | sympy | 1.14.0 | 符号计算 |
| | matplotlib | 3.11.1 | 数据可视化 |
| **交互开发** | jupyterlab | 4.6.2 | 交互式笔记本 |
| | ipykernel | 7.3.0 | Jupyter kernel |
| | ipywidgets | 8.1.8 | 交互式控件 |

---

## 一、使用 conda-pack 安装 (已生成)

### 1. 解压环境

```bash
mkdir -p ~/miniconda3/envs
tar -xzf pyXRD_EDS_XAS_Env-v1.tar.gz -C ~/miniconda3/envs/pyXRD_EDS_XAS_Env-v1
```

### 2. 激活并解包

```bash
# 激活环境
source ~/miniconda3/envs/pyXRD_EDS_XAS_Env-v1/bin/activate

# 解包 conda-pack 环境
conda-unpack
```

### 3. 验证

```bash
conda activate pyXRD_EDS_XAS_Env-v1
python3 -c "
import hyperspy; print('hyperspy:', hyperspy.__version__)
import larch; print('xraylarch:', larch.version.__version__)
import PyXplore; print('PyXplore:', PyXplore.__version__)
import pymatgen; print('pymatgen:', pymatgen.__version__)
import crystal_toolkit; print('crystal_toolkit: OK')
import pymatviz; print('pymatviz:', pymatviz.__version__)
import rsciio.edax; print('EDAX reader: OK')
"
```

---

## 二、手动从头构建 (参考)

### 前置条件

```bash
# 安装 Miniconda3 (如未安装)
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/miniconda3
source ~/miniconda3/bin/activate
```

### 构建步骤

```bash
# 1. 创建 Python 3.12 环境
conda create -n pyXRD_EDS_XAS_Env-v1 python=3.12 -y
conda activate pyXRD_EDS_XAS_Env-v1

# 2. 安装 pymatgen (关键: 必须使用 2025.10.7 版本)
#    此版本同时支持 pymatgen.core 扁平 re-export 和 pymatgen.core.graphs
pip install 'pymatgen==2025.10.7'

# 3. 安装 crystal_toolkit 和 pymatviz
#    crystal_toolkit 会自动拉取 emmet-core 0.87.1 和 mp-api 0.46.4
pip install crystal-toolkit pymatviz

# 4. 安装 hyperspy 和仪器格式支持
pip install 'hyperspy[all]' rosettasciio

# 5. 安装 xraylarch
pip install xraylarch

# 6. 安装 PyXplore (无依赖模式, 避免其严格版本引脚降级已安装包)
pip install --no-deps PyXplore

# 7. 安装 jupyterlab 和交互工具
pip install jupyterlab ipywidgets ipympl ipykernel

# 8. 安装额外科学计算包
pip install scikit-learn scikit-image pybaselines

# 9. 验证所有包
python3 -c "
import hyperspy, larch, PyXplore, pymatgen
import crystal_toolkit, pymatviz, ase
import rsciio.edax
import numpy, scipy, pandas, sklearn, sympy, matplotlib
import jupyterlab, h5py, dask, numba
print('All packages OK')
"

# 10. 清理缓存
pip cache purge

# 11. 打包
conda install -n base conda-pack -y
conda-pack -n pyXRD_EDS_XAS_Env-v1 -o pyXRD_EDS_XAS_Env-v1.tar.gz --ignore-missing-files
```

---

## 三、一键构建脚本

执行 `bash build_pyXRD_EDS_XAS_Env-v1.sh` 即可自动完成上述所有步骤。

---

## 四、各模块使用示例

### 1. EDS 能谱分析 (hyperspy + rosettasciio)

```python
import hyperspy.api as hs

# 读取 EDAX EDS 谱图
signal = hs.load("sample.spc")

# 或使用 rosettasciio 直接读取
from rsciio.edax import file_reader
data = file_reader("sample.spc")

# 查看信号
print(signal)
signal.plot()
```

### 2. XRD 全谱精修 (PyXplore / PyWPEM)

```python
from PyXplore import XRDRefinement

refiner = XRDRefinement()
refiner.load_data("sample.xy")
refiner.set_phases(["TiO2_rutile.cif"])
result = refiner.refine()

print(result.parameters)
result.plot()
```

### 3. XAS 谱分析 (xraylarch)

```python
import larch
from larch.xafs import pre_edge, autobk

# 读取 XAS 数据
dat = larch.io.read_athena("sample.prj")

# 预处理
pre_edge(dat, e0=7112, pre1=-150, pre2=-30, norm1=150, norm2=800)

# EXAFS 背景扣除
autobk(dat, rbkg=1.0, kweight=2)

# 查看结果
print(dat)
```

### 4. 晶体结构可视化 (crystal_toolkit)

```python
from pymatgen.core import Structure, Lattice
from crystal_toolkit import StructureMoleculeComponent

# 创建结构
si = Structure(
    Lattice.cubic(5.43),
    ["Si", "Si"],
    [[0, 0, 0], [0.25, 0.25, 0.25]]
)

# 在 Jupyter 中交互式显示
StructureMoleculeComponent(si).display()
```

### 5. 材料可视化 (pymatviz)

```python
import pymatviz as pmv
from pymatgen.core import Structure, Composition

# 绘制相图
pmv.ptable_heatmap(Composition("LiFePO4").fractional_composition)
```

---

## 五、飞牛云文件上传

本环境的交付文件包括:

- `pyXRD_EDS_XAS_Env-v1.tar.gz` — 完整 conda 环境压缩包 (592 MB)
- `pyXRD_EDS_XAS_Env-v1_README.md` — 本文档
- `build_pyXRD_EDS_XAS_Env-v1.sh` — 一键构建脚本

**上传方式**: 飞牛共享链接 (`https://share.fnnas.net/s/91dfd3b634ba40079a`) 是 React SPA 应用，文件上传通过 FN Connect 中继连接至用户 NAS，无法通过 curl 命令行直接完成。请在浏览器中打开链接，手动拖拽以上文件上传。

**推荐命名**: 上传时请使用名称 `MonkeyCode-CondaEnv`。

---

## 六、常见问题

### Q: PyXplore 导入时报版本警告?
A: PyXplore 严格锁定了 numpy==1.26.4 和 pymatgen==2024.4.13，但实际在新版本上功能正常。警告可忽略。

### Q: crystal_toolkit 需要 materials project API key?
A: 部分功能 (如相图查询) 需要 MP API key。可在 https://materialsproject.org 注册后设置环境变量 `MP_API_KEY`。

### Q: xraylarch 导入方式?
A: 使用 `import larch` (不是 `import xraylarch`)。
