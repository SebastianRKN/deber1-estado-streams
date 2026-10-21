# Verificación del deber

Verificado el 20 de octubre de 2026 con Flutter 3.47.1 y Dart 3.13.1 en Windows.
PASS significa que se ejecutó la comprobación; NOT RUN significa que falta ejecutarla.

| Proyecto / rama | flutter analyze | flutter test | APK release |
|---|---|---|---|
| Parte A · version/setstate | PASS, sin incidencias | PASS, 5 pruebas | PASS |
| Parte A · version/riverpod | PASS, sin incidencias | PASS, 5 pruebas | PASS |
| Parte A · version/bloc | PASS, sin incidencias | PASS, 6 pruebas | PASS |
| Parte B · conexión | PASS, sin incidencias | PASS, 13 pruebas | PASS |

`main` contiene la implementación Cubit y la misma Parte B verificada.
Las tres ramas nacieron del commit base `96bd8b6`; `main` incorporó después la versión Cubit.
Las verificaciones compartidas de persistencia se ejecutan en cada versión; no son
29 pruebas diferentes: son 29 ejecuciones exitosas entre los cuatro conjuntos.

## Alcance de las pruebas

- Estado inicial, incremento, decremento, negativos y recuperación mediante otra
  instancia del repositorio, usando el almacenamiento simulado de SharedPreferences.
- Navegación de widgets: devolución explícita con setState y atrás del sistema;
  conservación del estado compartido en Riverpod y Cubit.
- Veinte incrementos concurrentes y un decremento sin pérdida de valor en los
  administradores de estado compartido.
- Captura del mensaje `ContadorCubit: 0 -> 1` del BlocObserver.
- Future conserva el resultado hasta una nueva consulta; Stream actualiza el widget.
- Cierre durante una consulta pendiente, inicialización repetida, avisos duplicados,
  cincuenta aperturas/cierres sin listeners residuales, recuperación de error y
  prevención de que una consulta lenta sobrescriba un aviso más reciente.
- Traducción del adaptador real con canal nativo simulado: Wi-Fi tiene prioridad,
  móvil, lista vacía, none y otra interfaz según la política del enunciado.

Los dobles de prueba solo existen en `test/`. Las aplicaciones compiladas usan los
repositorios reales: no hay botones de simulación ni estados de red inventados.

## Arquitectura

- PASS: `domain` y `data` son idénticos en las tres ramas; ambos `git diff` vacíos.
- PASS: el diff de `presentation` sí tiene diferencias, reproducidas en RESPUESTAS.md.
- PASS: ningún import de paquetes externos en `domain`.
- PASS: presentación no importa `data`, SharedPreferences ni el paquete de conexión.
- PASS: la búsqueda `connectivity` en `parte_b_conexion/lib` devuelve únicamente
  `data/repositories/conexion_plus_repository.dart`.
- PASS: el Cubit cancela su StreamSubscription con await en close().

Comprobación reproducible desde PowerShell, en la raíz:

```powershell
./tools/verificar_arquitectura.ps1
```

## Android

Los cuatro instaladores se compilaron con `flutter build apk --release`.
La Parte B declara `android.permission.ACCESS_NETWORK_STATE` en el APK resultante.
Se comprobó con `aapt dump badging`: mínimo API 24 (Android 7), objetivo API 36 y
arquitecturas arm64-v8a, armeabi-v7a y x86_64.
Los APK están firmados con la clave de desarrollo para instalación directa.

## Pendiente del estudiante

| Comprobación | Estado |
|---|---|
| Instalación y ejecución de Parte B en un teléfono físico | PASS: visible en el video proporcionado |
| Persistencia después de cerrar realmente la app en Android | NOT RUN |
| Future con Wi-Fi y sin conexión en el teléfono | PASS: el video muestra la consulta manual y el resultado anterior hasta volver a consultar |
| Stream automático y datos móviles en el teléfono | NOT RUN: no aparecen en el video |
| Archivo demo.mp4 según B.3 | FAIL: dura 22,34 segundos y muestra Con Future; se solicita Con Stream y 15–20 segundos |

La compilación y las pruebas de widgets no demuestran por sí solas el funcionamiento
del sensor de conexión en un teléfono concreto. Revisar el video y confirmar
las observaciones en RESPUESTAS.md antes de la entrega académica. Reemplazar demo.mp4
por una grabación de Con Stream que muestre los cambios automáticos al apagar y
encender Wi-Fi, sin pulsar Consultar. El video actual sirve como evidencia de Future,
pero no satisface la demostración solicitada en B.3.
