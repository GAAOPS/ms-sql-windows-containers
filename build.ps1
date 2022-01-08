param(
    [ValidateSet("2017","2019")]
    [String]
    $SqlVersion,
    [Parameter(Mandatory=$true)]
    $ServerTag,
    [Parameter(Mandatory=$true)]
    $Tag
)

if($SqlVersion -eq "2017"){
    $EXE_LINK = "https://go.microsoft.com/fwlink/?linkid=840945"
    $BOX_LINK = "https://go.microsoft.com/fwlink/?linkid=840944"
    $SERVICE_NAME = "mssql14"
} elseif($SqlVersion -eq "2019"){
    $EXE_LINK = "https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLServer2019-DEV-x64-ENU.exe"
    $BOX_LINK = "https://download.microsoft.com/download/7/c/1/7c14e92e-bdcb-4f89-b7cf-93543e7112d1/SQLServer2019-DEV-x64-ENU.box"
    $SERVICE_NAME = "mssql15"
}else{
    throw "Sql Version not found"
}

docker build . --build-arg Server_Tag=$ServerTag --build-arg EXE_LINK=$EXE_LINK --build-arg BOX_LINK=$BOX_LINK  --build-arg SERVICE_NAME=$SERVICE_NAME -t $Tag 
#--no-cache
