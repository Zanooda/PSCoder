# Skill: AppForge — Build an Android APK from Vanilla HTML/JS/CSS

## Description
Create Android applications (APK) from vanilla web code (HTML/JS/CSS) using Capacitor 6 and GitHub Actions. No frameworks, no build step, no complex npm dependencies.

## Tools to use
- `write_file` — Create HTML, JS, CSS, JSON files
- `execute_powershell` — Run git commands to push to the repo
- `read_file` — Read the app.config.json template for configuration
- `web_search` — Search Capacitor documentation if needed
- `list_directory` — Verify the project structure

## Workflow

### Step 1: Create the project structure
```
my-app/
├── www/
│   ├── index.html       ← Vanilla web app
│   ├── css/style.css
│   └── js/app.js
├── assets/
│   ├── icon.png         ← 1024x1024 (generate with script)
│   └── splash.png       ← 2732x2732 (generate with script)
├── app.config.json      ← Main configuration
├── capacitor.config.json
├── package.json
└── .github/workflows/build.yml
```

### Step 2: Configure app.config.json
Replace these placeholders:
- `APP_NAME` → real app name (e.g. "My Calculator")
- `io.github.josevdr95.APP_NAME` → appId in reverse-domain (e.g. io.github.josevdr95.mycalculator)
- `APP_DESCRIPTION` → short description
- `version` → semantic version (e.g. "1.0.0")
- `versionCode` → incremental integer (1, 2, 3...)
- Android permissions as needed:
  - `"android.permission.INTERNET"` — Always (network)
  - `"android.permission.ACCESS_FINE_LOCATION"` — GPS
  - `"android.permission.READ_PHONE_STATE"` — Antenna info
  - `"android.permission.SYSTEM_ALERT_WINDOW"` — Overlay over apps
  - `"android.permission.FOREGROUND_SERVICE"` — Background services
  - `"android.permission.CAMERA"` — Camera
  - `"android.permission.VIBRATE"` — Vibration
  - `"android.permission.WAKE_LOCK"` — Keep CPU awake

### Step 3: Develop the web app (www/)
- **index.html**: vanilla HTML5 with Tailwind CSS (included in js/tailwind.js)
- **css/style.css**: custom styles
- **js/app.js**: vanilla JavaScript logic
- **js/lucide.js**: icons (included in the template)
- Do NOT use npm, webpack, vite, or frameworks
- Do NOT use React, Vue, or Angular
- Tailwind is loaded via a local script (no CDN)
- For Capacitor plugins use: `window.Capacitor.Plugins.PluginName`

### Step 4: Generate icon and splash
Run the script:
```powershell
node scripts/generate-icons.js "App Name" "#0a0f1d"
```
This automatically generates:
- `assets/icon.png` (1024x1024)
- `assets/splash.png` (2732x2732)
- Color variants

### Step 5: Native Java plugin (optional)
If the app needs native functionality (sensors, system APIs):
1. Create `android-plugin/src/main/java/io/appname/PluginName.java`
2. Use `@CapacitorPlugin(name = "PluginName")`
3. Methods with `@PluginMethod`
4. Register in MainActivity inside the workflow

### Step 6: Configure the GitHub Actions workflow
The `.github/workflows/build.yml` file is already ready. It:
1. Sets up Node 20 + Java 17 + Android SDK 34
2. Reads app.config.json automatically
3. Installs Capacitor 6
4. Adds the Android platform
5. Copies native plugins (if any)
6. Creates MainActivity.java with plugin registration
7. Adds permissions to AndroidManifest.xml
8. Patches build.gradle (appId, version, SDK)
9. Generates icons/splash with @capacitor/assets
10. Compiles `./gradlew assembleDebug`
11. Uploads the APK as a downloadable artifact

### Step 7: Push to the repo and build
```bash
git init
git add .
git commit -m "App Name v1.0.0 [compile]"
git remote add origin https://github.com/josevdr95new/my-app.git
git push -u origin main
```
The workflow runs automatically. Download the APK from Actions → Artifacts.

### Build control
| Keyword in commit | Action |
|---|---|
| `[compile]` `[compilar]` `[build]` | Builds |
| `[skip]` `[noc]` | Does not build |
| No keyword | Builds if build.compile=true |

## Important rules

1. **ALL code must be vanilla** — no npm install of frameworks
2. **Tailwind is included locally** in www/js/tailwind.js (no CDN)
3. **Lucide icons are included locally** in www/js/lucide.js
4. **The author is ALWAYS josevdr95** with email josevdr95@gmail.com
5. **The license is ALWAYS MIT** with the current year (2026)
6. **The appId ALWAYS starts with** io.github.josevdr95.
7. **versionCode must increase** with each version
8. **The app.config.json file is the source of truth** — the workflow reads it automatically
9. **Java plugins go in android-plugin/** — the workflow copies them automatically
10. **Permissions are declared in app.config.json** — the workflow adds them to the Manifest

## File templates

### app.config.json
```json
{
  "appId": "io.github.josevdr95.myapp",
  "appName": "App Name",
  "version": "1.0.0",
  "versionCode": 1,
  "description": "App description",
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
  <title>App Name</title>
  <script src="js/tailwind.js"></script>
  <link rel="stylesheet" href="css/style.css" />
  <script src="js/lucide.js"></script>
</head>
<body class="bg-ink-900 text-ink-200">
  <!-- Content -->
  <script src="js/app.js"></script>
</body>
</html>
```

### Native Java plugin (template)
```java
package io.appname.plugin;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "MyPlugin")
public class MyPlugin extends Plugin {
    @PluginMethod
    public void doSomething(PluginCall call) {
        JSObject r = new JSObject();
        r.put("result", "ok");
        call.resolve(r);
    }
}
```

### MainActivity.java (generated by the workflow)
```java
package io.github.josevdr95.myapp;
import android.os.Bundle;
import com.getcapacitor.BridgeActivity;
import io.appname.plugin.MyPlugin;
public class MainActivity extends BridgeActivity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    registerPlugin(MyPlugin.class);
    super.onCreate(savedInstanceState);
  }
}
```

## Examples of apps built with this template
- **Antena ETECSA** — Cellular antenna map with GPS
- **NetVigia** — Network monitor with traffic, speed test, Cuba map
- **SlideLock** — Screen lock with proximity sensor
- **RadioForge** — FM/AM/DTT radio antenna map

## Final verification
Before committing, verify:
- [ ] app.config.json has the correct appId (io.github.josevdr95.xxx)
- [ ] app.config.json has the correct appName
- [ ] app.config.json has version and versionCode
- [ ] author is josevdr95 with email josevdr95@gmail.com
- [ ] licenseYear is 2026
- [ ] www/index.html has the correct title
- [ ] No external CDNs (everything local)
- [ ] assets/icon.png exists (or use the generator script)
- [ ] .github/workflows/build.yml exists
- [ ] The commit includes [compile]
