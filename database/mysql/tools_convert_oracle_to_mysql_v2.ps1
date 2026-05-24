param()
$ErrorActionPreference='Stop'
function Convert-OracleFile {
  param([string]$InputPath,[string]$OutputPath,[string]$TargetTable)
  $text = Get-Content $InputPath -Raw
  $matches = [regex]::Matches($text, 'Insert into\s+WEB\.[A-Z_]+\s*\((?<cols>.*?)\)\s*values\s*\((?<vals>.*?)\);', [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine("-- generated from $InputPath")
  foreach($m in $matches){
    $cols = ($m.Groups['cols'].Value -replace '\s+','')
    $vals = $m.Groups['vals'].Value
    $vals = [regex]::Replace($vals, "to_date\('([^']*)','[^']*'\)", "'$1'", 'IgnoreCase')
    $vals = [regex]::Replace($vals, "to_timestamp\('([^']*)','[^']*'\)", "'$1'", 'IgnoreCase')
    $vals = $vals -replace "\\", "\\\\"
    [void]$sb.Append("INSERT INTO $TargetTable ($cols) VALUES ($vals);")
    [void]$sb.AppendLine()
  }
  Set-Content -Path $OutputPath -Value $sb.ToString() -Encoding UTF8
}
Convert-OracleFile -InputPath 'Oracle_Exports/SUPPLIERS_DATA_TABLE.sql' -OutputPath 'database/mysql/021b_suppliers_values_v2.sql' -TargetTable 'syntec_suppliers_staging_v2'
Convert-OracleFile -InputPath 'Oracle_Exports/PRODUCTS_DATA_TABLE.sql' -OutputPath 'database/mysql/021b_products_values_v2.sql' -TargetTable 'syntec_products_staging_v2'
Write-Output 'done'
