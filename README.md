[RUS]
Для настройки необходимо:
1) в Zabbix Server импортировать шаблон zbx_export_templates.xml
2) в файле zabbix_1c.bat настроить переменные - id кластера и путь до нового json файла в папке с zabbix agent и изменить версию 1с, если нужно
	а) получить id кластера можно командой ниже и ввести id в переменнную CLUSTER (по-умолчанию пуста!)
cd "C:\Program Files\1cv8\8.3.13.1865\bin\" & for /f "tokens=3" %i in ('rac.exe cluster list ^| findstr "cluster"') do @echo %i
	б) путь введите в переменную CONF_PATH проверена работоспособность пути только без пробелов
3) В конфигурацию zabbix-agent добавить строчки:
UserParameter=1c.test,type C:\zabbix\base.json
UserParameter=list-clister,cd "C:\Program Files\1cv8\8.3.13.1865\bin\" & for /f "tokens=3" %i in ('rac.exe cluster list ^| findstr "cluster"') do @echo %i
#1c-sessions
UserParameter=onec-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 |  find /c "1CV8C"
UserParameter=onec-bgj[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "BackgroundJob"
UserParameter=web-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "WebClient"
UserParameter=fat-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "1CV8"
UserParameter=designer-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "Designer"
4) Включить службу RAS (укажите свою версию 1С, если нужно)
sc create "1C:Enterprise RAS" binpath= "C:\Program Files\1cv8\8.3.13.1865\bin\ras.exe cluster --service" displayname= "1C:Enterprise RAS" start= auto 
net start "1C:Enterprise RAS"
5) Добавить скрипт zabbix_1c.bat в планировщик задач или запустить вручную
[ENG]