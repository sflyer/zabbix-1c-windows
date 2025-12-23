$confPath = "C:\zabbix\base.json"
$racPath = ".\rac.exe"
$result = @()
$lines = wmic process where "name='ras.exe'" get CommandLine | Select-Object -Skip 1
foreach ($lineObj in $lines) {
    $line = $lineObj.Trim()
    if ($line -match '--port=(\d+)') {
        $port = $matches[1]
        $path = $lineObj -replace '^"|"$', ''
        $directory = Split-Path -Path $path
        Set-Location $directory
        $clusterOutput = & "$racPath" "cluster" "list" "localhost:$port"
        $pattern = 'cluster\s*:\s*([a-fA-F0-9\-]+)'
        $match = [System.Text.RegularExpressions.Regex]::Match($clusterOutput, $pattern)
        if ($match.Success) {
            $clusterUuid = $match.Groups[1].Value
        } else {
            $clusterUuid = ""
            echo "0"
        }
        $result += [PSCustomObject]@{
            Port = $port
            ClusterUUID = $clusterUuid
        }
    }
}

$result
$output = @()
$output += '{"data":['
foreach ($item in $result) {
    $port = $item.Port
    $clusterUuid = $item.ClusterUUID
    $args = @("infobase", "--cluster=$clusterUuid", "summary", "list", "localhost:$port")
    $infobasesOutput = & "$racPath" @args
    $infobases = $infobasesOutput | Select-String -Pattern 'infobase\s*:\s*(.+)' | ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() }
    foreach ($infobase in $infobases) {
        $args1 = @("infobase", "--cluster=$clusterUuid", "summary", "info", "localhost:$port", "--infobase=$infobase")
        $nameOutput = & "$racPath" @args1
        $nameLine = $nameOutput | Select-String -Pattern "name\s*:\s*(.+)"
        $name = ""
        if ($nameLine) {
            if ($nameLine -match 'name\s*:\s*(.+)') {
                $name = $matches[1].Trim()
            }
        }
        $jsonPart = @{
            "{#BASE_1C}" = $infobase
            "{#BASE_NAME}" = $name
            "{#CLUSTER}"   = $clusterUuid
            "{#PORT}"   = $port
        } | ConvertTo-Json -Compress
        $output += $jsonPart + ","
    }
}
if ($output[-1].Trim().EndsWith(",")) {
    $output[-1] = $output[-1].TrimEnd(',')
}
$output += "]}"
$output += ""
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($confPath, $output, $Utf8NoBomEncoding)
