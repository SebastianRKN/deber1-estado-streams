$ErrorActionPreference = 'Stop'
$raiz = Split-Path $PSScriptRoot -Parent

foreach ($proyecto in @('parte_a_contador', 'parte_b_conexion')) {
    $dominio = Join-Path $raiz "$proyecto/lib/domain"
    $importsExternos = Get-ChildItem -LiteralPath $dominio -Recurse -Filter '*.dart' |
        Select-String -Pattern 'package:|/data/|/presentation/'
    if ($importsExternos) { throw "Dependencia prohibida en domain: $importsExternos" }
    $presentacion = Join-Path $raiz "$proyecto/lib/presentation"
    $filtraciones = Get-ChildItem -LiteralPath $presentacion -Recurse -Filter '*.dart' |
        Select-String -Pattern 'shared_preferences|connectivity_plus|/data/'
    if ($filtraciones) { throw "Dependencia de datos en presentation: $filtraciones" }
}

$archivos = @(Get-ChildItem -LiteralPath (Join-Path $raiz 'parte_b_conexion/lib') -Recurse -Filter '*.dart' |
    Select-String -Pattern 'connectivity' -List | Select-Object -ExpandProperty Path)
if ($archivos.Count -ne 1 -or -not $archivos[0].EndsWith('conexion_plus_repository.dart')) {
    throw "El paquete de conexión aparece fuera de su adaptador: $archivos"
}
foreach ($otra in @('version/riverpod', 'version/bloc')) {
    git -C $raiz diff --exit-code version/setstate $otra -- parte_a_contador/lib/domain parte_a_contador/lib/data
    if ($LASTEXITCODE -ne 0) { throw "domain/data difieren en $otra" }
}
Write-Output 'PASS: domain y data idénticos en las tres ramas; imports respetan las capas.'
Write-Output 'Único archivo que usa el paquete de conexión:'
Write-Output $archivos[0]
