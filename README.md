[RUS]
Для настройки необходимо:
1) в Zabbix Server импортировать шаблон `zbx_export_templates.xml`
2) в файле `zabbix_1c.bat` настроить переменные - id кластера и путь до нового json файла в папке с zabbix agent и изменить версию 1с, если нужно
	- получить id кластера можно командой ниже и ввести id в переменнную CLUSTER (по-умолчанию пуста!)
`
cd "C:\Program Files\1cv8\8.3.13.1865\bin\" & for /f "tokens=3" %i in ('rac.exe cluster list ^| findstr "cluster"') do @echo %i
`
	- путь введите в переменную CONF_PATH проверена работоспособность пути только без пробелов
3) В конфигурацию zabbix-agent добавить строчки:<br>
`UserParameter=1c.test,type C:\zabbix\base.json`<br>
`UserParameter=list-clister,cd "C:\Program Files\1cv8\8.3.13.1865\bin\" & for /f "tokens=3" %i in ('rac.exe cluster list ^| findstr "cluster"') do @echo %i`<br>
`UserParameter=onec-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 |  find /c "1CV8C"`<br>
`UserParameter=onec-bgj[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "BackgroundJob"`<br>
`UserParameter=web-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "WebClient"`<br>
`UserParameter=fat-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "1CV8"`<br>
`UserParameter=designer-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "Designer"`<br>
4) Включить службу RAS (укажите свою версию 1С, если нужно)
`sc create "1C:Enterprise RAS" binpath= "C:\Program Files\1cv8\8.3.13.1865\bin\ras.exe cluster --service" displayname= "1C:Enterprise RAS" start= auto `<br>
`net start "1C:Enterprise RAS"`<br>
5) Добавить скрипт zabbix_1c.bat в планировщик задач или запустить вручную<br><br>
[ENG]
For configure:
1) Import the template  `zbx_export_templates.xml` to the  Zabbix Server
2) in script `zabbix_1c.bat` configure variable - id cluster and path to new json file in a folder zabbix agent. Change 1C version, if u need it
	- you can get cluster id using the command bellow:
`
cd "C:\Program Files\1cv8\8.3.13.1865\bin\" & for /f "tokens=3" %i in ('rac.exe cluster list ^| findstr "cluster"') do @echo %i
`
	- enter path to variable CONF_PATH (tested on path without spaces)
3) In configure file zabbix-agent add this:<br>
`UserParameter=1c.test,type C:\zabbix\base.json`<br>
`UserParameter=list-clister,cd "C:\Program Files\1cv8\8.3.13.1865\bin\" & for /f "tokens=3" %i in ('rac.exe cluster list ^| findstr "cluster"') do @echo %i`<br>
`UserParameter=onec-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 |  find /c "1CV8C"`<br>
`UserParameter=onec-bgj[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "BackgroundJob"`<br>
`UserParameter=web-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "WebClient"`<br>
`UserParameter=fat-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "1CV8"`<br>
`UserParameter=designer-session[*],"C:\Program Files\1cv8\8.3.13.1865\bin\rac.exe" session --cluster=$1 list --infobase=$2 | find /c "Designer"`<br>
4) Enable RAS service (change 1С version, if you need)
`sc create "1C:Enterprise RAS" binpath= "C:\Program Files\1cv8\8.3.13.1865\bin\ras.exe cluster --service" displayname= "1C:Enterprise RAS" start= auto `<br>
`net start "1C:Enterprise RAS"`<br>
5) Add zabbix_1c.bat in task scheduler or just run it<br><br>
