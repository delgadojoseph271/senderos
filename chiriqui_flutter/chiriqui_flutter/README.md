# Rutas de Chiriquí — Flutter App

App móvil (iOS + Android) para rutas turísticas de la provincia de Chiriquí, Panamá.

---

## Requisitos del repositorio

Antes de clonar o correr el proyecto, asegurate de tener instalado:

| Requisito | Versión mínima | Verificar con |
|---|---|---|
| Flutter SDK | 3.19.0 | `flutter --version` |
| Dart SDK | 3.3.0 | `dart --version` |
| Android Studio | Hedgehog (2023.1.1) | — |
| Xcode (solo macOS) | 15.0 | `xcode-select --version` |
| CocoaPods (solo iOS) | 1.13.0 | `pod --version` |
| Java JDK | 17 | `java -version` |

---

## Setup inicial

### 1. Clonar e instalar dependencias

```bash
git clone <repo-url>
cd rutas_chiriqui
flutter pub get
```

### 2. Configurar variables de entorno

```bash
cp .env.example .env
```

Editá `.env` con tus valores reales:

```
MAPBOX_PUBLIC_TOKEN=pk.tu_token_aqui
API_BASE_URL=https://tu-api.com/api/v1
```

> ⚠️ Nunca commitear el archivo `.env`. Ya está en `.gitignore`.

### 3. Configurar Mapbox en Android

En `android/app/src/main/AndroidManifest.xml`, dentro de `<application>`:

```xml
<meta-data
  android:name="MAPBOX_ACCESS_TOKEN"
  android:value="pk.tu_token_aqui" />
```

### 4. Configurar Mapbox en iOS

En `ios/Runner/Info.plist`:

```xml
<key>MBXAccessToken</key>
<string>pk.tu_token_aqui</string>
```

### 5. Correr la app

```bash
# Ver dispositivos disponibles
flutter devices

# Correr en modo debug
flutter run

# Correr en dispositivo específico
flutter run -d <device-id>

# Build release Android
flutter build apk --release

# Build release iOS
flutter build ipa --release
```

---

## Estructura del proyecto

```
lib/
├── main.dart                         # Entry point
├── core/
│   ├── api/api_client.dart           # Cliente Dio con interceptor de auth
│   ├── auth/auth_service.dart        # Login, register, logout, me
│   ├── constants/app_constants.dart  # URLs, Mapbox token, constantes
│   ├── models/                       # RouteModel, BookingModel, BadgeModel, WeatherModel
│   ├── router/app_router.dart        # go_router — todas las rutas
│   ├── theme/app_theme.dart          # Colores, tema Material 3
│   └── widgets/main_shell.dart       # Bottom navigation shell
│
└── features/
    ├── home/                         # Catálogo de rutas + filtros
    ├── route_detail/                 # Ficha completa + mapa Mapbox
    ├── search/                       # Búsqueda con debounce
    ├── booking/                      # Reservas: crear, listar, cancelar
    ├── favorites/                    # Favoritos locales (SharedPreferences)
    ├── profile/                      # Perfil de usuario + badges
    ├── guides/                       # Perfil de guía + WhatsApp
    ├── auth/                         # Login + Register screens
    └── weather/                      # Widget de clima por zona
```

---

## Stack

| Capa | Paquete |
|---|---|
| Navegación | `go_router` |
| State management | `flutter_riverpod` |
| HTTP | `dio` |
| Auth storage | `flutter_secure_storage` |
| Favoritos | `shared_preferences` |
| Mapas | `mapbox_maps_flutter` |
| Imágenes | `cached_network_image` |
| Links externos | `url_launcher` |
| Env vars | `flutter_dotenv` |

---

## API Backend

La app consume la API Laravel en `API_BASE_URL`. Todos los endpoints están documentados en `FLUTTER_APP_SPEC.md`.

El token de autenticación se obtiene en login y se guarda en `flutter_secure_storage`. El `ApiClient` lo inyecta automáticamente en cada request como `Authorization: Bearer <token>`.

---

## Notas para el agente

- El estilo de mapa Mapbox para rutas outdoor es `mapbox://styles/mapbox/outdoors-v12`
- Los pagos son simulados (`fake_paid`). El backend siempre confirma la reserva.
- Los favoritos son locales — no se sincronizan con el backend en esta fase.
- Las pantallas que requieren auth redirigen a `/auth/login?redirect=<ruta_origen>` usando el mecanismo de redirect de `go_router`.
