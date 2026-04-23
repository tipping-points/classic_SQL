# Guia del Profesor — Taller 2: SQL, Pandas y Limpieza de Datos

---

## Antes de la clase (preparacion previa)

### 1. Clonar y arrancar el entorno

```bash
git clone https://github.com/tipping-points/classic_SQL.git
cd classic_SQL
docker compose up
```

Verifica que Jupyter carga en `http://localhost:8888` con token `classicmodels`
y que el notebook puede conectar a la base de datos ejecutando la celda de setup.

### 2. Que abre cada estudiante

Cada estudiante clona el repo y trabaja en:
- `notebooks/taller_2_v3_ESTUDIANTE.ipynb` — su copia de trabajo (stubs, sin soluciones)

Tu referencia durante la clase:
- `notebooks/taller_2_v3.ipynb` — version completa con codigo, analisis y variantes

### 3. Comprueba antes de empezar

- [ ] Docker Desktop en marcha
- [ ] `docker compose up` sin errores
- [ ] Jupyter accesible en localhost:8888
- [ ] Celda de setup ejecuta sin error (conexion a classic.db)
- [ ] Tienes el notebook profesor abierto en una pantalla y el estudiante proyectado

---

## Estructura de la sesion (duracion orientativa: 3-4 horas)

| Bloque | Duracion | Contenido |
|---|---|---|
| Intro | 10 min | Que es ClassicModels, esquema de tablas |
| Paso 0 | 10 min | Setup Docker, conexion, explorar esquema |
| Seccion 1 | 60 min | 7 ejercicios SQL puro |
| Seccion 2 | 40 min | 3 ejercicios SQL + pandas + graficos |
| Seccion 3 | 20 min | CASE WHEN, CTEs, subconsultas |
| Seccion 4 | 30 min | Limpieza de datos (NULLs, tipos, outliers) |
| Seccion 5 | 30 min | Challenges autonomos |
| Cierre | 10 min | Repaso, preguntas, proximos pasos |

---

## Paso a paso detallado

---

### INTRO (10 min)

**Que decirles:**
"Vamos a trabajar con ClassicModels, una empresa ficticia que vende modelos de coches en miniatura.
Tiene 8 tablas relacionadas entre si. Nuestra tarea: extraer informacion con SQL y enriquecerla con Python."

**Muestra el diagrama de relaciones** (esta en el README y en la celda de esquema):
```
customers -> orders -> orderdetails -> products -> productlines
employees -> offices
customers -> payments
```

**Pregunta al grupo:** "Si quiero saber cuanto factura cada cliente, que tablas necesito?"
(Respuesta: customers + orders + orderdetails)

---

### PASO 0 — Setup y exploración del esquema (10 min)

**Celda de setup (celda 2):**
- Explica que `os.environ.get('DB_PATH', '...')` permite cambiar la ruta sin tocar el codigo.
- Con Docker la ruta es automatica — no hace falta hacer nada.
- Ejecuta y verifica que imprime "Conexion establecida."

**Celda de esquema (celda 4):**
- Ejecuta y recorre las tablas con el grupo.
- Senala: columnas con clave primaria (icono de llave), columnas nullable.
- Pregunta: "En que tablas aparece customerNumber?" (customers, orders, payments)
- Pregunta: "Que columna une orders con orderdetails?" (orderNumber)

**Concepto clave a transmitir:**
> Antes de escribir una consulta, siempre exploramos el esquema.
> Los nombres de columna que terminan en Number o Code son claves de union entre tablas.

---

### SECCION 1 — SQL Puro (60 min, ~8 min por ejercicio)

**Dinamica para cada ejercicio:**
1. Lees el prompt en voz alta.
2. Das 2-3 minutos para que escriban la consulta en su notebook de estudiante.
3. Ejecutas la solucion en tu pantalla y comentas el resultado.
4. Explicas el analisis del codigo (celda de analisis en tu notebook).

---

#### Ejercicio 1 — Pedidos por cliente (8 min)

**Conceptos:** INNER JOIN, COUNT, GROUP BY, ORDER BY, alias de tabla.

**Guia para comentar:**
- "El alias `c` y `o` son convencion — no es obligatorio pero es estandar."
- "COUNT(o.orderNumber) cuenta solo filas no-NULL. Como orderNumber es clave primaria, siempre funciona."
- "GROUP BY es obligatorio siempre que mezclas COUNT/SUM con columnas normales."

**Pregunta de reflexion:** "Que pasa si cambio INNER JOIN por LEFT JOIN?"
(Aparecen los ~24 clientes sin pedidos con total_pedidos = 0)

**Muestra la variante** con pd.read_sql + LEFT JOIN para ver ambos grupos.

---

#### Ejercicio 2 — Top 5 productos mas vendidos (8 min)

**Conceptos:** SUM, aritmetica en SQL (quantityOrdered * priceEach), LIMIT.

**Guia para comentar:**
- "SQL puede hacer aritmetica directamente: multiplicar columnas, sumar, etc."
- "LIMIT siempre va al final, despues del ORDER BY."
- "GROUP BY p.productCode, p.productName — agrupamos por la clave primaria para evitar colisiones de nombre."

**Muestra la variante** de margen: busca si alguien se sorprende de que el producto mas vendido en unidades no es el mas rentable.

---

#### Ejercicio 3 — Ventas por pais (8 min)

**Conceptos:** JOIN de 3 tablas en cadena.

**Guia para comentar:**
- Dibuja en la pizarra: customers -> orders -> orderdetails.
- "Cada JOIN une dos tablas. Los JOINs se encadenan: el resultado del primero se une con el siguiente."
- "No necesitamos la tabla products porque el precio ya esta en orderdetails.priceEach."

**Pregunta de reflexion:** "USA tiene 3x mas ventas que Espana. Pero, tiene 3x mas clientes?"
(Muestra la variante con num_clientes y venta_por_cliente — la diferencia es menos extrema)

---

#### Ejercicio 4 — Inventario por linea de producto (5 min)

**Conceptos:** Agregacion sobre una sola tabla, ROUND(AVG(...)).

**Guia para comentar:**
- "Este es el caso mas simple: una sola tabla, no necesita JOIN."
- "ROUND(AVG(buyPrice), 2) — las funciones de agregacion se pueden anidar con funciones escalares."
- "Trains tiene solo 3 referencias y el inventario mas bajo. Linea de nicho?"

---

#### Ejercicio 5 — Clientes sin pedidos recientes (10 min)

**Conceptos:** LEFT JOIN, MAX, HAVING, parametros enlazados.

**Este ejercicio tiene un bug clasico — usalo como momento didactico:**
> "El notebook anterior usaba datetime.now() como fecha de corte.
> El problema: los datos son de 2003-2005. Con datetime.now() todos los clientes
> aparecerian como inactivos. El codigo 'funciona' pero el resultado es inutil."

**Guia para comentar:**
- "LEFT JOIN devuelve NULL en las columnas de orders para clientes sin pedidos."
- "MAX(NULL) = NULL — por eso podemos detectar clientes sin pedidos."
- "HAVING filtra despues de GROUP BY. WHERE filtra antes — no puede usar alias de agregacion."
- "El `?` es un parametro enlazado. Nunca concatenes variables directamente en SQL — riesgo de SQL injection."

**Pregunta de reflexion:** "Hay clientes con creditLimit alto que nunca han pedido. Que estrategia de negocio sugeririas?"

---

#### Ejercicio 6 — WHERE, LIKE, BETWEEN (7 min)

**Conceptos:** Operadores de filtro fundamentales.

**Guia para comentar:**
- "LIKE '%Ferrari%' — el % es comodin. 'Ferrari%' solo encontraria los que empiezan por Ferrari."
- "BETWEEN 50 AND 100 — los extremos son INCLUSIVOS."
- "IN ('A', 'B', 'C') es mas limpio que tres condiciones OR."

**Tabla de referencia rapida** (esta en la celda de analisis):
- `=`, `<>`, `LIKE`, `BETWEEN`, `IN`, `IS NULL`, `IS NOT NULL`

---

#### Ejercicio 7 — Funciones de fecha (7 min)

**Conceptos:** strftime, extraer componentes de fecha, COUNT DISTINCT.

**Guia para comentar:**
- "Las fechas en SQLite son texto. strftime('%Y', fecha) extrae el anio."
- "COUNT(DISTINCT o.orderNumber) — sin DISTINCT un pedido con 5 productos contaria 5 veces."
- "2005 parece muy bajo — pero los datos terminan en mayo 2005, no es una caida."

**Muestra el patron estacional:** noviembre-diciembre son los meses fuertes.
"Tiene sentido para una empresa de regalos. Coincide con Navidad."

---

### SECCION 2 — SQL + Pandas (40 min)

**Intro de seccion (2 min):**
> "Hasta ahora usabamos cursor.execute + fetchall. Ahora cambiamos a pd.read_sql
> que nos da directamente un DataFrame. SQL sigue haciendo el trabajo pesado
> (filtrar, unir, agregar). Pandas se encarga de columnas calculadas y visualizaciones."

Muestra la tabla de la seccion en el notebook (SQL vs pandas — que hace cada uno mejor).

---

#### Ejercicio 8 — Margen bruto por producto (12 min)

**Guia para comentar:**
- "SQL calcula la suma; pandas calcula el ratio (precio_medio_venta = total / unidades)."
- "Esta division seria un subquery en SQL puro. En pandas es una linea."
- "groupby('productLine')['margen_pct'].mean() — para ver si alguna linea tiene mas margen."

**Pregunta:** "Que linea de producto tiene el margen mas alto?"

---

#### Ejercicio 9 — Grafico de barras horizontal (15 min)

**Guia para comentar:**
- "LIMIT 10 en SQL — pedimos solo lo que necesitamos, no filtramos en pandas despues."
- "barh en lugar de bar — mas legible cuando los nombres son largos."
- "[::-1] invierte el orden — matplotlib dibuja de abajo a arriba en barh."
- "FuncFormatter para formatear el eje X en millones."

**Haz que customicen:** "Alguien que anada la linea de media con axvline?"
(Esta el hint en la celda de analisis: `ax.axvline(media, color='red', linestyle='--')`)

---

#### Ejercicio 10 — Top 10 clientes (13 min)

**Guia para comentar:**
- "Segunda consulta separada para el total global — mas legible que una subconsulta SQL."
- "El top 2 representa ~18% del total. Riesgo de concentracion de cliente."
- "Vectorizacion de pandas: df['col'] / escalar opera sobre toda la columna a la vez."

---

### SECCION 3 — SQL Avanzado (20 min)

---

#### CASE WHEN + CTE (12 min)

**Intro:**
> "Las CTEs son como variables en SQL. Defines una consulta con nombre
> y la reutilizas en la consulta principal. Sin CTEs necesitariamos subconsultas anidadas."

**Guia para comentar:**
- "WITH ventas_cliente AS (...) — define la CTE."
- "CASE WHEN evalua condiciones en orden. La primera que se cumple gana."
- "Sin la CTE, no podriamos usar el alias 'total_facturado' dentro del CASE WHEN."

**Muestra la distribucion:** cuantos clientes Premium, Estandar, Basico.
"Los Premium son pocos pero concentran gran parte del revenue — tipico en B2B."

---

#### Subconsultas NOT IN vs LEFT JOIN (8 min)

**Guia para comentar:**
- "Tres formas de resolver el mismo problema. Todas correctas en SQLite."
- "En BDs con millones de filas: LEFT JOIN + IS NULL suele ser el mas eficiente."
- "NOT EXISTS es el mas explicito semanticamente."

**Pregunta:** "Algunos de estos clientes sin pedidos tienen creditLimit alto. Que implicacion tiene?"

---

### SECCION 4 — Limpieza de Datos (30 min)

**Intro de seccion (2 min):**
> "El 70-80% del tiempo en un proyecto real de Data Science es limpieza.
> No el modelo, no la visualizacion — la limpieza.
> Vamos a ver el proceso de diagnostico sistematico."

---

#### Limpieza 1 — Diagnostico de NULLs (10 min)

**Guia para comentar:**
- "df.isnull().sum() — un numero por columna. Filtramos los que son > 0."
- "orders.shippedDate tiene NULLs — son pedidos no enviados todavia. NULL valido."
- "employees.reportsTo tiene exactamente 1 NULL — el CEO. NULL valido."

**Concepto clave:**
> "No todos los NULLs son errores. Antes de limpiar, entiende que significa el NULL."

---

#### Limpieza 2 — Tipos y conversion de fechas (10 min)

**Guia para comentar:**
- "SQLite guarda fechas como texto. Pandas las carga como 'object' (string)."
- "Con tipo object no puedes restar fechas, calcular medias, ni comparar bien."
- "pd.to_datetime(col, errors='coerce') — errors='coerce' convierte invalidos a NaT en vez de crashear."
- ".dt.days extrae dias de un Timedelta."

**Muestra el resultado:** dias medios de fabricacion, pedidos con retraso.
"Un X% de pedidos se envian despues de la fecha requerida. Interesante para operaciones."

---

#### Limpieza 3 — Outliers con IQR (10 min)

**Guia para comentar:**
- "IQR = Q3 - Q1. El rango del 50% central de los datos."
- "Limites de Tukey: [Q1 - 1.5*IQR, Q3 + 1.5*IQR]. Factor 1.5 es convencion."
- "IQR es mas robusto que media +/- 3sigma porque los outliers no distorsionan Q1 y Q3."

**Pregunta:** "Encontramos lineas de pedido con importe muy alto. Son errores o pedidos grandes legítimos?"
(Respuesta: probablemente pedidos legítimos grandes — hay que investigar antes de eliminar.)

---

### SECCION 5 — Challenges autonomos (30 min)

**Dinamica:**
- Los estudiantes eligen los challenges que mas les interesan.
- Trabajan en parejas o individualmente.
- Tu circulas y ayudas con pistas, no con soluciones directas.

**Challenges mas accesibles para empezar (sugiere estos primero):**
- Challenge 1 (promedio de ventas) — solo GROUP BY + division
- Challenge 3 (clientes con >4 pedidos enviados) — WHERE + HAVING
- Challenge 9 (stock bajo) — WHERE simple

**Challenges mas avanzados (para quien acaba rapido):**
- Challenge 5 (empleados y clientes) — JOIN de 4 tablas
- Challenge 10 (deuda de clientes) — CTE doble
- Challenge 7 (correlacion precio-cantidad) — analisis estadistico

---

### CIERRE (10 min)

**Repaso rapido (5 min):**

| Concepto | Cuando usarlo |
|---|---|
| INNER JOIN | Solo quiero filas con correspondencia en ambas tablas |
| LEFT JOIN | Quiero todas las filas de la tabla izquierda, con o sin correspondencia |
| GROUP BY | Siempre que uso COUNT, SUM, AVG con otras columnas |
| HAVING | Filtrar sobre el resultado de un GROUP BY |
| CTE (WITH) | Cuando necesito reutilizar una subconsulta o mejorar la legibilidad |
| CASE WHEN | Logica condicional dentro de SQL |
| pd.read_sql | Pasar resultados SQL directamente a un DataFrame |
| pd.to_datetime | Convertir columnas de fecha de string a datetime |

**Pregunta de cierre al grupo:**
"Si tuvierais que analizar los datos de vuestra empresa, cual seria la primera consulta que escribiriais?"

**Proximos pasos que puedes mencionar:**
- Window functions (RANK, OVER, PARTITION BY) — el siguiente nivel de SQL
- SQLAlchemy — ORM para conectar Python con bases de datos en produccion
- Pandas avanzado: merge, pivot_table, apply
- Visualizacion: Seaborn, Plotly para graficos interactivos

---

## Preguntas frecuentes durante la clase

**"Por que no funciona mi consulta?"**
1. Revisa los nombres de tabla y columna — SQLite distingue mayusculas en datos, no en palabras clave.
2. Asegurate de que el GROUP BY incluye todas las columnas no-agregadas del SELECT.
3. Comprueba que el JOIN usa la columna correcta en ambas tablas.

**"Cual es la diferencia entre WHERE y HAVING?"**
- WHERE filtra filas antes de agrupar (no puede usar alias de agregacion).
- HAVING filtra grupos despues de GROUP BY (puede usar COUNT, SUM, etc.).

**"Cuando uso SQL y cuando pandas?"**
- SQL: filtrar, unir tablas, agregar — reduce el volumen de datos en la fuente.
- Pandas: columnas calculadas, visualizaciones, estadisticas sobre el DataFrame ya reducido.

**"Por que LEFT JOIN + IS NULL en vez de NOT IN?"**
- Ambos funcionan. LEFT JOIN + IS NULL es mas eficiente con grandes volumenes de datos.
- NOT IN tiene un comportamiento inesperado si la subconsulta devuelve algún NULL.
