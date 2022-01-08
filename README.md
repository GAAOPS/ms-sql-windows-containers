# mssql-server-windows-developer
This is the Dockerfile for the latest version of SQL Server Developer Edition for Windows Containers.

## How to build:
you can use build.ps1 like this:
```
.\build.ps1 -SqlVersion <2017|2019> -ServerTag <Windows server core tag> -Tag <repo and tag>

 # For SQL Server 2017 on Windows server core 2022:
 .\build.ps1 -SqlVersion 2017 -ServerTag "ltsc2022" -Tag "myrepo/sql:dev-2017-win-lts2022"

 # For SQL Server 2019 on Windows server core 2022:
  .\build.ps1 -SqlVersion 2019 -ServerTag "ltsc2022" -Tag "myrepo/sql:dev-2019-win-lts2022"
```

**Notice**: For SQL Server 2019 the **MAXDOP** is not specified: https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-from-the-command-prompt?view=sql-server-ver15

## Tags:
- dev-2017-win-lts2022: SQL Server 2017 on Windows Server Core 2022
- dev-2019-win-lts2022: SQL Server 2017 on Windows Server Core 2022
- dev-2017-win-lts2019: SQL Server 2017 on Windows Server Core 2019
- dev-2019-win-lts2019: SQL Server 2017 on Windows Server Core 2019


## Usage:
### docker:
````
docker run -d -p 1433:1433 -v C:/temp/:C:/temp/ -e sa_password=<YOUR SA PASSWORD> -e ACCEPT_EULA=Y -e attach_dbs="<DB-JSON-CONFIG>" ghodrat/ms-sql-server:dev-2017-win-lts2022
````

### docker compose:

````
version: "3.9"
services:
  db_1:
    image: ghodrat/ms-sql-server:dev-2017-win-lts2022
    ports:
      - "10501:1433"
    environment:
      sa_password: Your_password123
      ACCEPT_EULA: "Y"
    volumes:
      - .\db_1\dbs:C:\Server\MSSQL\DB
      - .\db_1\logs:C:\Server\MSSQL\LOG
      - .\db_1\backups:C:\Server\MSSQL\Backup
````

*official repo:* https://github.com/microsoft/mssql-docker/tree/master/windows

