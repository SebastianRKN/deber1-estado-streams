# Respuestas · Deber 1

Preparadas con asistencia de Codex a partir del código, las pruebas automatizadas
y los dos videos proporcionados: el primero evidencia Future y el segundo Stream.
Todavía falta confirmar las observaciones del contador en el teléfono.

## 1. setState y el botón atrás

La prueba de widgets reprodujo que «Volver» devuelve el entero actualizado y el visor
lo muestra. Atrás del sistema cierra la ruta sin devolver ese entero: el repositorio
contiene el nuevo número, pero `_contador` del State del visor conserva la copia anterior.
Lo desactualizado es el estado local que dibuja el visor, no el dato persistido.
Se coordinan cinco puntos: estado del visor, argumentos al abrir Control, constructor/estado
de Control, `Navigator.pop` con resultado y recepción de ese resultado con `setState`.
Los casos de uso también se inyectan desde `main.dart`.

## 2. Riverpod y el botón atrás

El contador vive en un Notifier expuesto por `contadorProvider`, dentro del contenedor
de ProviderScope situado por encima de las rutas. Las dos pantallas acceden a ese estado:
Control invoca métodos y Visor observa el valor. Cerrar una ruta no requiere devolver
ningún número. La prueba de navegación con atrás conserva el valor actualizado.

## 3. BlocObserver

El observador registra cada transición del Cubit con el valor anterior y el nuevo,
por ejemplo `ContadorCubit: 3 -> 4`. Permite reconstruir la secuencia y descubrir
incrementos repetidos o inesperados. Sería útil al depurar un carrito cuyo total cambia
dos veces por una pulsación. En estas otras dos implementaciones no se añadió un registro
equivalente; también sería posible instrumentarlas. El observador registra cambios,
no todas las acciones que no producen un estado distinto.

## 4. Prueba de arquitectura

Estos comandos se ejecutaron desde la raíz del repositorio; por eso las rutas incluyen
`parte_a_contador/`. En esa carpeta, el equivalente del enunciado usa `lib/domain`,
`lib/data` y `lib/presentation`.


```text
$ git diff version/setstate version/riverpod -- parte_a_contador/lib/domain parte_a_contador/lib/data
```
Salida real: vacía (cero líneas).

```text
$ git diff version/setstate version/bloc -- parte_a_contador/lib/domain parte_a_contador/lib/data
```
Salida real: vacía (cero líneas).

```text
$ git diff version/setstate version/bloc --stat -- parte_a_contador/lib/presentation
 .../lib/presentation/estado/contador_cubit.dart    |  29 ++++++
 .../presentation/pantallas/pantalla_control.dart   |  75 +++-----------
 .../lib/presentation/pantallas/pantalla_visor.dart | 108 +++++----------------
 3 files changed, 67 insertions(+), 145 deletions(-)
```


| Comparación | Resultado real |
|---|---|
| setState vs Riverpod, domain y data | Sin diferencias |
| setState vs Cubit, domain y data | Sin diferencias |
| setState vs Cubit, presentation | Tres archivos con diferencias |

Los dos resultados vacíos demuestran que los archivos de dominio y datos son idénticos
entre versiones. El tercero muestra que la presentación sí cambia. Sustituir Riverpod
requiere reemplazar su administrador y el código de las pantallas que lo consume,
además del cableado en `main.dart` y las dependencias; no los contratos, casos de uso
ni la persistencia. Las tres ramas parten del mismo commit base.

## 5. Comparación y elección

| Aspecto | setState | Riverpod | Cubit |
|---|---|---|---|
| ¿Dónde vive el contador? | En el State del visor y una copia en Control | En ContadorNotifier, dentro de ProviderScope | En ContadorCubit, dentro de BlocProvider |
| ¿Las pantallas se pasan datos? | Sí: valor y casos de uso; resultado al volver | No | No |
| Archivos de presentation creados/modificados | 2: visor y control | 3: provider, visor y control | 3: cubit, visor y control |
| ¿Qué pasa con atrás del sistema? | El visor conserva la copia anterior | El visor muestra el estado compartido actual | El visor muestra el estado compartido actual |
| ¿Se modificó domain entre versiones? | No | No | No |

Para una sola pantalla con un estado sencillo elegiría setState: requiere menos piezas
y el estado queda cerca de quien lo usa. Para ocho pantallas que comparten cinco datos
elegiría Riverpod por sus providers y la inyección de dependencias; Cubit también sería
apropiado si el equipo prefiere métodos explícitos y observación central de transiciones.

setState es correcto para estado local sencillo que solo necesita una pantalla o widget.
No hace falta un administrador global para expandir un panel o seleccionar una opción local.

## 6. La foto con Future

La consulta devuelve el estado del momento en que se ejecuta. Al apagar Wi-Fi no se
ejecuta otra consulta automáticamente; por eso permanece el resultado anterior y su hora.
Era un dato correcto del momento anterior, que ya no describe el estado actual.
En el video proporcionado, después de apagar Wi-Fi, la pantalla conserva «Wi-Fi»
y la hora 22:53:14. Tras consultar de nuevo muestra «Sin conexión» con la hora
22:53:18. Al reconectar, conserva el resultado anterior hasta otra consulta.
Esto evidencia que Future conserva la foto hasta que se solicita una nueva.

## 7. Cancelar la suscripción

Si se elimina `cancel()` de `close()`, cada visita puede dejar una suscripción viva.
Tras cincuenta entradas y salidas pueden acumularse listeners y referencias a Cubits cerrados,
gastando recursos y ejecutando callbacks innecesarios. Sin una protección adicional,
también se puede intentar emitir después del cierre y provocar errores.
Comprobar `isClosed` evita ese emit, pero no libera la suscripción: hay que cancelarla.
Una prueba abre y cierra cincuenta Cubits y verifica que no queden listeners activos.

## 8. Foto y película

Con Future pulso Consultar mientras tengo Wi-Fi y guardo una foto del estado y su hora.
Si lo apago, esa foto no cambia. Con Stream la app escucha los avisos y va mostrando
Wi-Fi, Sin conexión y Wi-Fi nuevamente a medida que cambian, sin pulsar Consultar.
Esto se observa en el segundo video: la pestaña Con Stream permanece seleccionada,
se apaga Wi-Fi desde los ajustes rápidos y aparece Sin conexión; al reconectar,
la pantalla vuelve a Wi-Fi sin pulsar un botón de consulta en la app.

Pediría con Future el detalle de un pedido al abrirlo y el resultado de enviar un formulario.
Observaría con Stream los mensajes entrantes de un chat y la ubicación de un repartidor.
En este ejercicio se observa el tipo de conexión disponible, no se certifica acceso a Internet.

## Confirmación antes de entregar

- [ ] Probé el contador en las tres ramas y confirmé las observaciones.
- [ ] Cerré y volví a abrir el contador y comprobé persistencia real.
- [ ] Vi el BlocObserver en la consola durante la prueba del celular.
- [x] Los videos muestran Wi-Fi / sin conexión en Future y en Stream.
- [ ] Si dispongo de datos móviles, comprobé también esa transición.
- [x] Añadí al repositorio el video proporcionado como `demo.mp4`.
- [ ] Revisé estas respuestas para que describan lo que efectivamente observé.
