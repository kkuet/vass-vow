# Despliegue de Microservicios y Base de Datos en AWS

Este repositorio contiene un ejercicio compuesto por 5 funciones Lambda que actúan como microservicios, junto con una base de datos PostgreSQL en RDS. Las entidades gestionadas por la base de datos incluyen Files, Tests, Testsequipments y Measurements. Además, se proporciona un API Gateway autoconfigurado mediante Terraform, con endpoints listos para su uso.

## Prerrequisitos

Asegúrate de tener instaladas las siguientes herramientas antes de comenzar:

- Git
- Terraform
- AWS CLI
- Python (para ejecutar scripts y empaquetar el código Lambda)
- PostgreSQL Client (para ejecutar scripts SQL)

## Configuración Inicial

Para la generación automática de la infraestructura, sigue estos pasos:

1. **Clonar el Repositorio:**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   ```
  
2. Empaquetar y Subir Código Lambda:
    Ejecuta el script createlambda.bat para empaquetar el código Lambda con las dependencias necesarias (psycopg2 y SQLAlchemy) y subir un archivo zip temporal a S3.
   ```bash
      createlambda.bat
   ```

3. Ejecutar Terraform:
Asegúrate de tener configuradas tus credenciales de AWS. Luego, ejecuta Terraform para desplegar la infraestructura en Amazon AWS, incluyendo el servidor, la base de datos y el frontal del API Gateway.

```bash

    terraform apply
````

Nota: Ajusta las variables en el archivo correspondiente según sea necesario.

Ejecutar el Script tables.sql:
Una vez generada la base de datos, ejecuta el script tables.sql para la creación de la estructura de modelos en SQL.

AWS CloudFront - CDN

Este ejercicio utiliza AWS CloudFront como CDN para optimizar la entrega de contenido. Aprovecha la red de distribución global de AWS para mejorar la velocidad y la escalabilidad de tu aplicación.
Estructura del Proyecto

La organización del proyecto es la siguiente:

lua

/proyecto
|-- /lambda_functions
|   |-- lambda_function_1
|   |-- lambda_function_2
|   |-- ...
|-- /terraform
|   |-- main.tf
|   |-- variables.tf
|-- tables.sql
|-- package_and_upload.sh
|-- README.md

    /lambda_functions: Contiene el código de las funciones Lambda.
    /terraform: Incluye los archivos de configuración de Terraform para desplegar la infraestructura.
    tables.sql: Script SQL para la generación de la estructura del modelo en la base de datos.

Uso de la API Gateway

Una vez desplegada la infraestructura, la API Gateway proporciona los siguientes endpoints:

    /files
    /tests
    /testsequipments
    /measurements
