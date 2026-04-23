# Mentoria SQL - ClassicModels

Entorno Jupyter listo para ejecutar con Docker. Incluye los notebooks del Taller 2
(SQL + pandas + limpieza de datos) y la base de datos ClassicModels en SQLite.

## Requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y en marcha.

## Arrancar el entorno

**Mac / Linux**
```bash
git clone https://github.com/tipping-points/classic_SQL.git
cd classic_SQL
make up
```

**Windows**
```bat
git clone https://github.com/tipping-points/classic_SQL.git
cd classic_SQL
start.bat
```

O directamente:
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
make down        # Mac / Linux
stop.bat         # Windows
docker compose down  # cualquier sistema
```

## Si el puerto 8888 ya esta ocupado

Edita `docker-compose.yml` y cambia el puerto izquierdo:

```yaml
ports:
  - "8889:8888"   # cambia 8888 por otro puerto libre
```

Luego accede en `http://localhost:8889`.

## Sin Docker (uso local)

Instala las dependencias:

```bash
pip install -r requirements.txt
```

Antes de abrir Jupyter, indica la ruta a la base de datos:

```bash
# Linux / Mac
export DB_PATH=/ruta/a/classic.db

# Windows (PowerShell)
$env:DB_PATH = "C:\ruta\a\classic.db"
```

## Estructura del repo

```
classic_SQL/
├── Dockerfile
├── docker-compose.yml
├── Makefile                              <- comandos rapidos (Mac/Linux)
├── start.bat / stop.bat                  <- comandos rapidos (Windows)
├── requirements.txt                      <- dependencias para uso local
├── notebooks/
│   ├── taller_2_v3.ipynb                 <- notebook completo (PROFESOR)
│   ├── taller_2_v3_ESTUDIANTE.ipynb      <- notebook con stubs (ESTUDIANTE)
│   ├── ClassicModels_curso_SQL.ipynb     <- teoria SQL del curso
│   └── extra/
│       ├── Extra_Exercicis_ClassicModels.ipynb
│       └── ExtraExercices_UNSOLVED.ipynb
└── data/
    ├── classic.db                        <- base de datos principal
    ├── test.db                           <- base de datos de practica
    └── estructura_tablas.csv
```

## Tablas en classic.db

| Tabla | Descripcion |
|---|---|
| customers | Clientes |
| orders | Pedidos |
| orderdetails | Lineas de pedido |
| products | Catalogo de productos |
| productlines | Categorias |
| employees | Empleados |
| offices | Oficinas |
| payments | Pagos |

Relacion principal: `customers -> orders -> orderdetails -> products`
