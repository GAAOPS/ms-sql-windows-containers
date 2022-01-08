## Warning: Restarting windows container causes the machine key to change and hence if you have any encryption configured then restarting SQL On Windows containers
## breaks the encryption key chain in SQL Server. 

ARG Server_Tag
# Windows server core
FROM mcr.microsoft.com/windows/servercore:$Server_Tag
# ARG values that appear before the FROM directive are not available after the FROM directive.
ARG EXE_LINK
ARG BOX_LINK
ARG SERVICE_NAME

# Download Links:
ENV exe=${EXE_LINK}
ENV box=${BOX_LINK}
ENV service=${SERVICE_NAME}




ENV sa_password="_" \
    attach_dbs="[]" \
    ACCEPT_EULA="_" \
    sa_password_path="C:\ProgramData\Docker\secrets\sa-password"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# make install files accessible
COPY start.ps1 /
WORKDIR /

RUN Invoke-WebRequest -Uri $env:box -OutFile SQL.box ; \
        Invoke-WebRequest -Uri $env:exe -OutFile SQL.exe ; \
        Start-Process -Wait -FilePath .\SQL.exe -ArgumentList /qs, /x:setup ; \
        .\setup\setup.exe /q /ACTION=Install /INSTANCENAME=MSSQLSERVER /FEATURES=SQLEngine /UPDATEENABLED=0 /SQLSVCACCOUNT='NT AUTHORITY\NETWORK SERVICE' /SQLSYSADMINACCOUNTS='BUILTIN\ADMINISTRATORS' /TCPENABLED=1 /NPENABLED=0 /IACCEPTSQLSERVERLICENSETERMS /SQLBACKUPDIR='C:\Server\MSSQL\Backup' /SQLUSERDBDIR='C:\Server\MSSQL\DB' /SQLUSERDBLOGDIR='C:\Server\MSSQL\DB' ; \
        Remove-Item -Recurse -Force SQL.exe, SQL.box, setup

RUN stop-service MSSQLSERVER ; \
        set-itemproperty -path ('HKLM:\software\microsoft\microsoft sql server\' + $($env:service) + '.MSSQLSERVER\mssqlserver\supersocketnetlib\tcp\ipall') -name tcpdynamicports -value '' ; \
        set-itemproperty -path ('HKLM:\software\microsoft\microsoft sql server\' + $($env:service) + '.MSSQLSERVER\mssqlserver\supersocketnetlib\tcp\ipall') -name tcpport -value 1433 ; \
        set-itemproperty -path ('HKLM:\software\microsoft\microsoft sql server\' + $($env:service) + '.MSSQLSERVER\mssqlserver') -name LoginMode -value 2 ;

HEALTHCHECK CMD [ "sqlcmd", "-Q", "select 1" ]

CMD .\start -sa_password $env:sa_password -ACCEPT_EULA $env:ACCEPT_EULA -attach_dbs \"$env:attach_dbs\" -Verbose