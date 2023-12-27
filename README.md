# Despliegue de Microservicios y Base de Datos en AWS

Este repositorio contiene un ejercicio compuesto por 5 funciones Lambda que actúan como microservicios, junto con una base de datos PostgreSQL en RDS. Las entidades gestionadas por la base de datos incluyen Files, Tests, Testsequipments y Measurements. Además, se proporciona un API Gateway autoconfigurado mediante Terraform, con endpoints listos para su uso.

## Prerrequisitos

Asegúrate de tener instaladas las siguientes herramientas antes de comenzar:

- Git
- Terraform
- AWS CLI
- Python (para ejecutar scripts y empaquetar el código Lambda)
- PostgreSQL Client (para ejecutar scripts SQL)

## Configuración entorno de funciones Lambda 

Las funciones lambda en el fichero lambda_files dependen de un cliente de Postgres que se llama psycopg2. Para empaquetarla dentro del entorno de ejecución de AWS Lambda debemos empaquetar las dependencias de los paquetes de Pipy para que estén disponibles a la hora de ejecutar el código. Para poder hacer esto hemos creado un entorno virtual en Python (myenv) donde instalamos localmente los paquetes requeridos que posteriormente se empaqueta en un zip. Adicionalmente el paquete psycopg2 depende de librerías nativas de Linux (extensión .so) que han de incluirse en el fichero Zip correspondiente. Deben ser compiladas nativamente en Linux para lo cual hemos arrancado una instancia en EC2 con Ubuntu 22.02 donde se han instalado los paquetes de gcc necesarios para la compilación de psycopg2 y se han generado las librerías de enlace dinámico necesarias para el posterior empaquetado.

```bash
-rw-rw-rw-   1 user     group     3133185 Dec 27 09:17 libcrypto.so.1.1
-rw-rw-rw-   1 user     group      646065 Dec 27 09:17 libssl.so.1.1
-rw-rw-rw-   1 user     group      345209 Dec 27 09:17 libgssapi_krb5.so.2.2
-rw-rw-rw-   1 user     group      219953 Dec 27 09:17 libk5crypto.so.3.1
-rw-rw-rw-   1 user     group       17913 Dec 27 09:17 libkeyutils.so.1.5
-rw-rw-rw-   1 user     group     1018953 Dec 27 09:17 libkrb5.so.3.3
-rw-rw-rw-   1 user     group       76873 Dec 27 09:17 libkrb5support.so.0.1
-rw-rw-rw-   1 user     group       60977 Dec 27 09:17 liblber.so.2.0.200
-rw-rw-rw-   1 user     group      447329 Dec 27 09:17 libldap.so.2.0.200
-rw-rw-rw-   1 user     group      406817 Dec 27 09:17 libpcre.so.1.2.0
-rw-rw-rw-   1 user     group      178337 Dec 27 09:17 libselinux.so.1
-rw-rw-rw-   1 user     group      370777 Dec 27 09:17 libpq.so.5
-rw-rw-rw-   1 user     group      119217 Dec 27 09:17 libsasl2.so.3.0.0
-rw-rw-rw-   1 user     group       17497 Dec 27 09:17 libcom_err.so.2.1
```

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
