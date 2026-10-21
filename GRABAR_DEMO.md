# Prueba en celular y grabación

## Antes del video

1. Abre la Parte B. Desactiva datos móviles temporalmente para que apagar Wi-Fi
   produzca «Sin conexión», y comprueba que el teléfono esté conectado a una red Wi-Fi.
2. En «Con Future», pulsa «Consultar ahora»: aparecerán Wi-Fi y la hora.
3. Apaga Wi-Fi y regresa a la app sin pulsar Consultar. Debe conservar la foto anterior.
4. Pulsa Consultar otra vez: debe mostrar Sin conexión. Enciende Wi-Fi de nuevo.
5. Abre «Con Stream» y espera a que muestre Wi-Fi. Ya puedes grabar.

## Video de 15–20 segundos (demo.mp4)

| Tiempo aproximado | Acción |
|---|---|
| 0–3 s | Muestra la pestaña Con Stream con Wi-Fi |
| 3–7 s | Baja ajustes rápidos, apaga Wi-Fi y cierra el panel |
| 7–11 s | Deja visible Sin conexión, sin tocar botones de la app |
| 11–15 s | Enciende Wi-Fi desde ajustes rápidos y cierra el panel |
| 15–20 s | Muestra Wi-Fi al reconectar; detén la grabación |

Espera a la reconexión real: algunos teléfonos tardan más. No simules estados ni edites
el video para fingir una actualización. Si tarda, repite la toma cuando la red esté estable.
Si tienes datos móviles, comprueba adicionalmente que al apagar solo Wi-Fi pase a Datos móviles.
Restaura al terminar los ajustes de conectividad que utilizas normalmente.

## Pruebas breves del contador

- setState: suma tres veces y usa Volver. Cierra por completo y abre: el valor persiste.
  Vuelve a Control, suma y sal con atrás del sistema: el visor conserva su valor anterior;
  reabrir la app recupera lo que sí se guardó. Ese resultado es intencional en el deber.
- Riverpod y Cubit: repetir atrás del sistema debe mostrar el valor nuevo.
- Cubit: con `flutter run`, mira en la terminal `ContadorCubit: 3 -> 4` al cambiar el valor.

Revisa `RESPUESTAS.md` después de estas pruebas. Las respuestas están preparadas a partir
del código y de pruebas automáticas, pero no afirman que ya hayas realizado la prueba física.
Guarda el video en la raíz del repositorio como `demo.mp4` y súbelo según el README.
