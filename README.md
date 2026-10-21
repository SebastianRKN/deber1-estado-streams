# Deber 1 · Estado y streams en Flutter

Dos proyectos Android con arquitectura limpia: `presentation → domain ← data`.
El código fue preparado con asistencia de Codex; las pruebas automáticas no sustituyen
las observaciones del estudiante ni la grabación en un teléfono real.

## Ejecutar en tu celular

Activa depuración USB, conecta el teléfono y acepta la autorización en su pantalla.
Desde la raíz del repositorio, para la app que debes grabar:

```powershell
git switch main
cd parte_b_conexion
flutter pub get
flutter run
```

Si aparecen varios dispositivos, usa `flutter devices` y `flutter run -d ID_DEL_CELULAR`.
No necesitas servidor, cuentas, claves ni configurar servicios externos.

## Probar los tres contadores

Desde la raíz, elige UNA rama y ejecuta su app:

```powershell
git switch version/setstate
# Alternativas: git switch version/riverpod o git switch version/bloc
cd parte_a_contador
flutter pub get
flutter run
```

Detén la ejecución antes de cambiar de rama y vuelve a la raíz con `cd ..`.
Las tres versiones usan la misma identidad Android y la clave `contador`:
instalar una encima de otra conserva normalmente el valor guardado.
Desinstalar o borrar los datos de la app lo reinicia.
`main` incluye la versión Cubit para que ambas carpetas se puedan ejecutar de inmediato.
Las ramas de comparación nacieron independientemente del commit base, no una de otra.

## Arquitectura

| Capa | Parte A | Parte B |
|---|---|---|
| domain | Contrato y casos Obtener/Incrementar/Decrementar | Enum, contrato y casos Consultar/Observar |
| data | Repositorio con SharedPreferences | Adaptador del paquete de conexión |
| presentation | setState / Riverpod / Cubit y pantallas | Pantalla Future y pantalla Stream con Cubit |
| main.dart | Construcción e inyección de dependencias | Construcción e inyección de dependencias |

`domain` solo importa código del dominio y bibliotecas estándar de Dart.
Las implementaciones concretas se construyen en `main.dart`; presentación conoce contratos.
La Parte B usa la prioridad pedida: Wi-Fi, después móvil y, si no hay ninguno,
sin conexión. No es un comprobador de acceso a Internet: Wi-Fi puede existir sin Internet.
Ethernet/VPN no se clasifican por separado en este ejercicio.

En Stream, el contador registra cambios de estado distintos recibidos del flujo;
no cuenta la consulta inicial ni avisos duplicados. Al regresar desde ajustes se consulta
otra vez porque Android puede pausar los avisos en segundo plano. Salir de la pestaña
libera su suscripción; al volver se inicia una nueva y el contador comienza en cero.

## Verificación y entrega

- `RESPUESTAS.md`: ocho respuestas, comparación y salida real de Git.
- `VERIFICACION.md`: resultados y límites de las verificaciones.
- `GRABAR_DEMO.md`: pasos y guion de 15–20 segundos.
- `tools/verificar_arquitectura.ps1`: comprobación reproducible de imports y ramas.
- `demo.mp4`: pendiente de la grabación real del estudiante.

Para verificar cada proyecto: `flutter analyze` y `flutter test` desde su carpeta.
Para generar un instalador: `flutter build apk --release`.
El APK se genera en `build/app/outputs/flutter-apk/app-release.apk` de cada proyecto.
Se firma con la clave local de desarrollo para instalación académica; no es una publicación en tienda.

## Después de grabar

En la raíz y en `main`, guarda el video como `demo.mp4`, revisa las respuestas contra
lo observado y actualiza las casillas de `RESPUESTAS.md`:

```powershell
git add demo.mp4 RESPUESTAS.md
git commit -m "docs: demo real y observaciones en celular"
git push origin main
```

La fecha de entrega es la del aula virtual.
