# Skill: AppForge — Crear APK Android desde HTML/JS/CSS Vanilla

## Description
Crear aplicaciones Android (APK) a partir de código web vanilla (HTML/JS/CSS) usando Capacitor 6 y GitHub Actions. Sin frameworks, sin build step, sin dependencias npm complejas.

## Tools to use
- `write_file` — Crear archivos HTML, JS, CSS, JSON
- `execute_powershell` — Ejecutar git commands para subir al repo
- `read_file` — Leer la plantilla app.config.json para configurar
- `web_search` — Buscar documentación de Capacitor si es necesario
- `list_directory` — Verificar estructura del proyecto

## Workflow

### Paso 1: Crear estructura del proyecto
```
mi-app/
├── www/
│   ├── index.html       ← App web vanilla
│   ├── css/style.css
│   └── js/app.js
├── assets/
│   ├── icon.png         ← 1024x1024 (generar con script)
│   └── splash.png       ← 2732x2732 (generar con script)
├── app.config.json      ← Configuración principal
├── capacitor.config.json
├── package.json
└── .github/workflows/build.yml
```

### Paso 2: Configurar app.config.json
Reemplazar estos placeholders:
- `NOMBRE_APP` → Nombre real de la app (ej: "Mi Calculadora")
- `io.github.josevdr95.NOMBRE_APP` → appId en reverse-domain (ej: io.github.josevdr95.micalculadora)
- `DESCRIPCION_DE_LA_APP` → Descripción corta
- `version` → Versión semántica (ej: "1.0.0")
- `versionCode` → Número entero incremental (1, 2, 3...)
- Permisos Android según necesidad:
  - `"android.permission.INTERNET"` — Siempre (red)
  - `"android.permission.ACCESS_FINE_LOCATION"` — GPS
  - `"android.permission.READ_PHONE_STATE"` — Info de antena
  - `"android.permission.SYSTEM_ALERT_WINDOW"` — Overlay sobre apps
  - `"android.permission.FOREGROUND_SERVICE"` — Servicios en background
  - `"android.permission.CAMERA"` — Cámara
  - `"android.permission.VIBRATE"` — Vibración
  - `"android.permission.WAKE_LOCK"` — Mantener CPU activa

### Paso 3: Desarrollar la app web (www/)
- **index.html**: HTML5 vanilla con Tailwind CSS (incluido en js/tailwind.js)
- **css/style.css**: Estilos personalizados
- **js/app.js**: Lógica JavaScript vanilla
- **js/lucide.js**: Iconos (incluido en la plantilla)
- NO usar npm, webpack, vite ni frameworks
- NO usar React, Vue, Angular
- Tailwind se carga via script local (no CDN)
- Para Capacitor plugins usar: `window.Capacitor.Plugins.NombrePlugin`

### Paso 4: Generar icono y splash
Ejecutar el script:
```powershell
node scripts/generate-icons.js "Nombre de la App" "#0a0f1d"
```
Esto genera automáticamente:
- `assets/icon.png` (1024x1024)
- `assets/splash.png` (2732x2732)
- Variantes de color

### Paso 5: Plugin Java nativo (opcional)
Si la app necesita funcionalidad nativa (sensores, system APIs):
1. Crear `android-plugin/src/main/java/io/appname/PluginName.java`
2. Usar `@CapacitorPlugin(name = "PluginName")`
3. Métodos con `@PluginMethod`
4. Registrar en MainActivity dentro del workflow

### Paso 6: Configurar workflow GitHub Actions
El archivo `.github/workflows/build.yml` ya está listo. Hace:
1. Setup Node 20 + Java 17 + Android SDK 34
2. Lee app.config.json automáticamente
3. Instala Capacitor 6
4. Añade plataforma Android
5. Copia plugins nativos (si existen)
6. Crea MainActivity.java con registro de plugins
7. Añade permisos al AndroidManifest.xml
8. Parchea build.gradle (appId, version, SDK)
9. Genera iconos/splash con @capacitor/assets
10. Compila `./gradlew assembleDebug`
11. Sube el APK como artifact descargable

### Paso 7: Subir al repo y compilar
```bash
git init
git add .
git commit -m "Nombre App v1.0.0 [compile]"
git remote add origin https://github.com/josevdr95new/nombre-app.git
git push -u origin main
```
El workflow se ejecuta automáticamente. Descargar el APK desde Actions → Artifacts.

### Control de compilación
| Keyword en commit | Acción |
|---|---|
| `[compile]` `[compilar]` `[build]` | Compila |
| `[skip]` `[noc]` | No compila |
| Sin keyword | Compila si build.compile=true |

## Reglas importantes

1. **TODO el código debe ser vanilla** — sin npm install de frameworks
2. **Tailwind se incluye local** en www/js/tailwind.js (no CDN)
3. **Lucide icons se incluye local** en www/js/lucide.js
4. **El autor SIEMPRE es josevdr95** con email josevdr95@gmail.com
5. **La licencia SIEMPRE es MIT** con el año actual (2026)
6. **El appId SIEMPRE empieza con** io.github.josevdr95.
7. **El versionCode debe incrementar** en cada versión
8. **El archivo app.config.json es la fuente de verdad** — el workflow lo lee automáticamente
9. **Los plugins Java van en android-plugin/** — el workflow los copia automáticamente
10. **Los permisos se declaran en app.config.json** — el workflow los añade al Manifest

## Plantilla de archivos

### app.config.json
```json
{
  "appId": "io.github.josevdr95.nombreapp",
  "appName": "Nombre App",
  "version": "1.0.0",
  "versionCode": 1,
  "description": "Descripción de la app",
  "author": {
    "name": "josevdr95",
    "email": "josevdr95@gmail.com",
    "url": "https://github.com/josevdr95new"
  },
  "license": "MIT",
  "licenseYear": "2026",
  "android": {
    "minSdkVersion": 24,
    "targetSdkVersion": 34,
    "compileSdkVersion": 34,
    "permissions": ["android.permission.INTERNET", "android.permission.ACCESS_NETWORK_STATE"]
  },
  "build": { "compile": true, "emulator": false }
}
```

### www/index.html (base)
```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" />
  <meta http-equiv="Content-Security-Policy" content="default-src *; script-src * 'unsafe-inline' 'unsafe-eval'; style-src * 'unsafe-inline'; img-src * data: blob:; connect-src *" />
  <meta name="theme-color" content="#0a0f1d" />
  <title>Nombre App</title>
  <script src="js/tailwind.js"></script>
  <link rel="stylesheet" href="css/style.css" />
  <script src="js/lucide.js"></script>
</head>
<body class="bg-ink-900 text-ink-200">
  <!-- Contenido -->
  <script src="js/app.js"></script>
</body>
</html>
```

### Plugin Java nativo (template)
```java
package io.appname.plugin;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "MiPlugin")
public class MiPlugin extends Plugin {
    @PluginMethod
    public void hacerAlgo(PluginCall call) {
        JSObject r = new JSObject();
        r.put("resultado", "ok");
        call.resolve(r);
    }
}
```

### MainActivity.java (generado por el workflow)
```java
package io.github.josevdr95.nombreapp;
import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import io.appname.plugin.MiPlugin;
public class MainActivity extends BridgeActivity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    registerPlugin(MiPlugin.class);
    super.onCreate(savedInstanceState);
  }
}
```

## Ejemplos de apps creadas con esta plantilla
- **Antena ETECSA** — Mapa de antenas celulares con GPS
- **NetVigia** — Vigilante de red con tráfico, test velocidad, mapa Cuba
- **SlideLock** — Bloqueo de pantalla con sensor de proximidad
- **RadioForge** — Mapa de antenas de radio FM/AM/TDT

## Verificación final
Antes de hacer commit, verificar:
- [ ] app.config.json tiene appId correcto (io.github.josevdr95.xxx)
- [ ] app.config.json tiene appName correcto
- [ ] app.config.json tiene version y versionCode
- [ ] author es josevdr95 con email josevdr95@gmail.com
- [ ] licenseYear es 2026
- [ ] www/index.html tiene el título correcto
- [ ] No hay CDNs externos (todo local)
- [ ] assets/icon.png existe (o usar script generador)
- [ ] .github/workflows/build.yml existe
- [ ] El commit incluye [compile]
