# Data layout

Datasets used by notebooks are organized under `data/raw/`.

## Available now

- `data/raw/twitter/twitter_training.csv`
- `data/raw/twitter/twitter_validation.csv`

## Additional expected datasets

- `data/raw/credit-score/train.csv` for `CREDIT SCORING MODEL.ipynb`
- `data/raw/weather-dataset/dataset/` image directory for `image-recognition.ipynb`

## Known public sources

- Twitter sentiment (already included):
	- https://www.kaggle.com/datasets/jp797498e/twitter-entity-sentiment-analysis
- Credit score classification:
	- https://www.kaggle.com/datasets/parisrohan/credit-score-classification
- Weather image recognition (contains `dataset/` folder):
	- https://www.kaggle.com/datasets/jehanbhathena/weather-dataset

## Quick setup (PowerShell)

Run from repository root:

- `scripts/download_data.ps1`

## Notes

Only datasets with clear redistribution conditions should be committed.
For restricted/competition datasets, store instructions and download scripts instead of raw files.
