[RUS]
Для настройки необходимо:
1) в Zabbix Server импортировать шаблон `zbx_export_templates.xml`
2) Запустить скрипт make_json.ps1.
3) В конфигурацию zabbix-agent добавить строчки:<br>
`UserParameter=1c.test,type C:\zabbix\base.json`<br>
`UserParameter=list-clister,cd "C:\Program Files\1cv8\8.3.27.1606\bin\" & for /f "tokens=3" %i in ('rac.exe cluster list ^| findstr "cluster"') do @echo %i`<br>
`UserParameter=session[*],"C:\Program Files\1cv8\8.3.27.1606\bin\rac.exe" session --cluster=$2 list --infobase=$1 localhost:$3 | find /c "$4"`<br>
Вместо `8.3.27.1606` в `UserParameter` нужно вписать свою версию 1С.
4) Включить службу RAS (укажите свою версию 1С, если нужно)<br>
`sc create "1C:Enterprise RAS" binpath= "C:\Program Files\1cv8\8.3.27.1606\bin\ras.exe cluster --service" displayname= "1C:Enterprise RAS" start= auto `<br>
`net start "1C:Enterprise RAS"`<br>
5) Добавить скрипт make_json.ps1 в планировщик задач или запустить вручную<br><br>
[ENG]
For configure:
1) Import the template  `zbx_export_templates.xml` to the  Zabbix Server
2) Run script make_json.ps1.
3) In configure file zabbix-agent add this:<br>
`UserParameter=1c.test,type C:\zabbix\base.json`<br>
`UserParameter=list-clister,cd "C:\Program Files\1cv8\8.3.27.1606\bin\" & for /f "tokens=3" %i in ('rac.exe cluster list ^| findstr "cluster"') do @echo %i`<br>
`UserParameter=session[*],"C:\Program Files\1cv8\8.3.27.1606\bin\rac.exe" session --cluster=$2 list --infobase=$1 localhost:$3 | find /c "$4"`<br>
Instead of `8.3.27.1606` in `UserParameter` you need to enter your 1C version.
4) Enable RAS service (change 1С version, if you need)<br>
`sc create "1C:Enterprise RAS" binpath= "C:\Program Files\1cv8\8.3.27.1606\bin\ras.exe cluster --service" displayname= "1C:Enterprise RAS" start= auto `<br>
`net start "1C:Enterprise RAS"`<br>
5) Add make_json.ps1 in task scheduler or just run it<br><br>
