@echo off 
set CONF_PATH=C:\zabbix\base.json
set CLUSTER=38cf94b3-a78c-450d-a9b3-0473568cec53
echo  {"data": > "%CONF_PATH%"
echo    [ >> "%CONF_PATH%"
for /f "tokens=3" %%i in ('C:\"Program Files"\1cv8\8.3.13.1865\bin\rac.exe infobase --cluster=%CLUSTER% summary list') ^
do for /f "tokens=3" %%n in ('C:\"Program Files"\1cv8\8.3.13.1865\bin\rac.exe infobase --cluster=%CLUSTER% summary info --infobase %%i ^| find  "name"') ^
do echo {"{#BASE_1C}":"%%i", "{#BASE_NAME}":"%%n"},>> "%CONF_PATH%"
echo {"{#Autor}":"Chirkov Anton"} >> "%CONF_PATH%"
echo    ] >> "%CONF_PATH%"
echo } >> "%CONF_PATH%"