# ML Notebooks Collection

![Python](https://img.shields.io/badge/python-3.10%2B-3776AB?style=flat&logo=python&logoColor=white)
![Notebook](https://img.shields.io/badge/notebook-Jupyter-F37626?style=flat&logo=jupyter&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-learning%20repository-57606a)

## What is this

A collection of exploratory machine learning notebooks across tabular, computer vision, and NLP tasks.

## Why it exists

This repository serves as a learning and experimentation space for applied ML practice across multiple problem types.

## Architecture / Stack

- Python ecosystem notebooks
- scikit-learn / TensorFlow workflows
- Notebook-driven exploratory analysis

## Installation

```bash
git clone https://github.com/fbenkhelifa/ml-notebooks-collection.git
cd ml-notebooks-collection
python -m venv .venv
# Windows PowerShell
.\.venv\Scripts\Activate.ps1
pip install numpy pandas scikit-learn tensorflow matplotlib seaborn jupyter
```

## Usage

Open notebooks in Jupyter or VS Code and run cells in order:

- `CREDIT SCORING MODEL.ipynb`
- `image-recognition.ipynb`
- `twitter-sentiment-analysis.ipynb`

## Project structure

```text
ml-notebooks-collection/
├── CREDIT SCORING MODEL.ipynb
├── image-recognition.ipynb
├── twitter-sentiment-analysis.ipynb
├── twitter_training.csv
├── twitter_validation.csv
├── README.md
├── .gitignore
└── LICENSE
```

## Limitations

- Notebook-centric codebase with limited modular reuse
- No CI/test pipeline
- Includes local dataset artifacts for direct notebook execution

## Roadmap

1. Split notebooks into themed subfolders (`cv/`, `nlp/`, `tabular/`).
2. Add environment lock file for reproducibility.
3. Promote strongest case studies to standalone production repositories.

## License

MIT License (see `LICENSE`).