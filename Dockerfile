FROM quay.io/jupyter/scipy-notebook:latest

# scipy-notebook ya incluye: pandas, numpy, matplotlib, scipy, scikit-learn
# sqlite3 forma parte de la libreria estandar de Python — no requiere instalacion

WORKDIR /home/jovyan/work
