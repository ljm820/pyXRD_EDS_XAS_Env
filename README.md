# pyXRD_EDS_XAS_Env - 科学仪器数据分析 Python 环境

[![Python](https://img.shields.io/badge/Python-3.11%20|%203.12-blue)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![GitHub release](https://img.shields.io/badge/Releases-Download-orange)](https://github.com/ljm820/pyXRD_EDS_XAS_Env/releases)

面向 XRD / EDS / XAS 科学仪器数据分析的完整 Python 环境方案，提供 conda-pack 预构建环境包、一键构建脚本和完整文档。

---

## 环境版本对比

| 特性 | v0 (pyXRD_EDS_XAS_ENV) | v1 (pyXRD_EDS_XAS_Env-v1) |
|------|------------------------|---------------------------|
| **Python** | 3.11.15 | 3.12.13 |
| **pymatgen** | 2026.5.4 | 2025.10.7 |
| **crystal_toolkit** | 不支持 | 2026.7.20 |
| **pymatviz** | 不支持 | 0.18.0 |
| **PyXplore** | 正常安装 | --no-deps (避免依赖冲突) |
| **tensorflow** | 已移除 | 未安装 |
| **压缩包** | 755 MB | 592 MB |
| **解压后** | ~2.5 GB | ~1.9 GB |

## 核心功能模块

| 模块 | 包名 | 功能 | v0 版本 | v1 版本 |
|------|------|------|---------|---------|
| **EDS/仪器读取** | hyperspy | 多维光谱图像分析 | 2.4.0 | 2.4.0 |
| | rosettasciio | 40+ 仪器格式 (含 EDAX) | 0.14.0 | 0.14.0 |
| **XAS 分析** | xraylarch | XAS/EXAFS/XANES/XRF | 2026.2.2 | 2026.2.2 |
| **XRD 精修** | PyXplore | AI 驱动全谱精修 | 2026.7.22 | 2026.7.22 |
| **材料计算** | pymatgen | 晶体结构/相图/电子结构 | 2026.5.4 | 2025.10.7 |
| | ase | 原子尺度模拟 | 3.26.0 | 3.29.0 |
| **可视化** | crystal_toolkit | Dash 晶体结构可视化 | — | 2026.7.20 |
| | pymatviz | 材料科学可视化 | — | 0.18.0 |
| **科学计算** | numpy | 数值计算 | 2.4.6 | 2.4.6 |
| | scipy | 科学计算 | 1.15.3 | 1.18.0 |
| | pandas | 数据处理 | 2.3.3 | 3.0.5 |
| | scikit-learn | 机器学习 | 1.7.2 | 1.9.0 |
| | sympy | 符号计算 | 1.14.0 | 1.14.0 |
| | matplotlib | 数据可视化 | 3.11.1 | 3.11.1 |
| **交互开发** | jupyterlab | 交互式笔记本 | 4.6.2 | 4.6.2 |

---

## 快速开始

### 1. 下载环境压缩包

从 [Releases](https://github.com/ljm820/pyXRD_EDS_XAS_Env/releases) 下载对应版本的 `tar.gz` 文件。

### 2. 解压并安装

```bash
# 创建环境目录
mkdir -p ~/miniconda3/envs/pyXRD_EDS_XAS_Env-v1

# 解压
tar -xzf pyXRD_EDS_XAS_Env-v1.tar.gz -C ~/miniconda3/envs/pyXRD_EDS_XAS_Env-v1

# 激活环境
source ~/miniconda3/envs/pyXRD_EDS_XAS_Env-v1/bin/activate

# 解包 conda-pack 环境
conda-unpack
```

### 3. 验证环境

```bash
conda activate pyXRD_EDS_XAS_Env-v1
python3 -c "
import hyperspy; print('hyperspy:', hyperspy.__version__)
import larch; print('xraylarch:', larch.version.__version__)
import pymatgen; print('pymatgen:', pymatgen.__version__)
import crystal_toolkit; print('crystal_toolkit: OK')
import pymatviz; print('pymatviz:', pymatviz.__version__)
import rsciio.edax; print('EDAX reader: OK')
"
```

或执行验证脚本：

```bash
bash verify/verify_environment.sh
```

---

## 各模块快速示例

### EDS 能谱分析 (hyperspy)

```python
import hyperspy.api as hs
signal = hs.load("sample.spc")
signal.plot()
```

### XRD 全谱精修 (PyXplore)

```python
from PyXplore import XRDRefinement
refiner = XRDRefinement()
refiner.load_data("sample.xy")
refiner.set_phases(["TiO2_rutile.cif"])
result = refiner.refine()
result.plot()
```

### XAS 谱分析 (xraylarch)

```python
import larch
from larch.xafs import pre_edge, autobk
dat = larch.io.read_athena("sample.prj")
pre_edge(dat, e0=7112, pre1=-150, pre2=-30, norm1=150, norm2=800)
autobk(dat, rbkg=1.0, kweight=2)
```

### 晶体结构可视化 (crystal_toolkit, 仅 v1)

```python
from pymatgen.core import Structure, Lattice
from crystal_toolkit import StructureMoleculeComponent
si = Structure(Lattice.cubic(5.43), ["Si", "Si"], [[0,0,0], [0.25,0.25,0.25]])
StructureMoleculeComponent(si).display()
```

---

## 项目文件结构

```
pyXRD_EDS_XAS_Env/
├── README.md                          # 项目总览（本文档）
├── v0/                                # v0 版本文档
│   ├── README.md                      # v0 详细文档
│   └── build_pyXRD_EDS_XAS_ENV.sh     # v0 构建脚本
├── v1/                                # v1 版本文档
│   ├── README.md                      # v1 详细文档
│   └── build_pyXRD_EDS_XAS_Env-v1.sh  # v1 构建脚本
├── docs/                              # 完整方案文档
│   └── pyXRD_EDS_XAS_Env_完整搭建方案.docx
├── verify/                            # 环境验证
│   └── verify_environment.sh
├── .gitignore
└── .gitattributes
```

环境压缩包（tar.gz）文件通过 [GitHub Releases](https://github.com/ljm820/pyXRD_EDS_XAS_Env/releases) 发布。

---

## 版本选择建议

| 使用场景 | 推荐版本 |
|----------|----------|
| 无需 crystal_toolkit/pymatviz，追求最新 pymatgen | v0 |
| 需要晶体结构可视化 (crystal_toolkit + pymatviz) | v1 |
| 需要 Python 3.12 / 最小体积 | v1 |
| 需要最新 numpy/scipy/pandas | v1 |

---

## 技术说明

### v1 核心突破

pymatgen 2026.x 重构了 `pymatgen.core` 为命名空间包，导致 crystal_toolkit 和 pymatviz 中的 `from pymatgen.core import Lattice` 等导入失败。v1 通过使用 pymatgen 2025.10.7 实现了三个包兼容共存 — 此版本同时提供 `pymatgen.core` 扁平 re-export 和 `pymatgen.core.graphs` 模块。

### PyXplore 版本引脚

PyXplore 严格锁定了 `numpy==1.26.4`、`pymatgen==2024.4.13`，v1 采用 `--no-deps` 安装避免降级冲突，实际功能在较新版本上正常运行。

### 条件要求

- Linux x86_64 (glibc 2.17+)
- Miniconda3 或 Anaconda3
- 建议 4GB+ 可用磁盘空间

---

## 许可证

MIT License
