# Mentoria SQL — ClassicModels

Entorno Jupyter listo para ejecutar con Docker. Incluye los notebooks del Taller 2
(SQL + pandas + limpieza de datos) y la base de datos ClassicModels en SQLite.

## Requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y en marcha.

## Arrancar el entorno

```bash
docker compose up
```

La primera vez descarga la imagen base (~3 GB). Las siguientes arranca en segundos.

Abre el navegador en:

```
http://localhost:8888
```

Token de acceso: **classicmodels**

## Parar el entorno

```bash
docker compose down
```

## Estructura del repo

```
mentoria-sql/
├── Dockerfile
├── docker-compose.yml
├── notebooks/
│   ├── taller_2_v3.ipynb          <- notebook principal del taller
│   └── extra/
│       ├── Extra_Exercicis_ClassicModels.ipynb
│       └── ExtraExercices_UNSOLVED.ipynb
└── data/
    ├── classic.db                  <- base de datos ClassicModels (SQLite)
    └── estructura_tablas.csv
```

## Base de datos

La ruta dentro del contenedor es `/home/jovyan/work/data/classic.db`.
El notebook la detecta automaticamente — no hace falta cambiar ninguna ruta.

Para uso local sin Docker, exporta la variable de entorno antes de abrir Jupyter:

```bash
# Linux / Mac
export DB_PATH=/ruta/a/classic.db

# Windows (PowerShell)
$env:DB_PATH = "C:\ruta\a\classic.db"
```

## Tablas disponibles en classic.db

| Tabla | Descripcion |
|---|---|
| customers | Clientes |
| orders | Pedidos |
| orderdetails | Lineas de pedido (productos por pedido) |
| products | Catalogo de productos |
| productlines | Categorias de productos |
| employees | Empleados |
| offices | Oficinas |
| payments | Pagos recibidos |

Relaciones clave: `customers -> orders -> orderdetails -> products`
