# senderos

> **Rutas turísticas de la provincia de Chiriquí, Panamá.**
>
> Aplicación que centraliza rutas turísticas de Chiriquí, permitiendo a turistas explorar rutas, contactar guías locales y gestionar reservas. Nombre comercial: **Chiriquí Explora**.

---

## Stack

| Capa | Tecnología |
|---|---|
| API | Laravel 13 + PHP 8.3 (`backend/`) |
| Frontend admin | React 19 + TypeScript + Vite + Tailwind 4 (`frontend/`) |
| App móvil | Flutter (`chiriqui_flutter/`) |
| Base de datos | PostgreSQL 18 |
| Almacenamiento | S3 (imágenes) |
| Auth | Sanctum (token-based) |

---

## Arquitectura

```
chiriqui_flutter/       ← App móvil (Flutter + Riverpod + Mapbox)
frontend/               ← Panel admin (React + TS + Tailwind)
    └── HTTP ──┐
backend/               ← API REST (Laravel + Sail)
    ├── PostgreSQL
    ├── Redis
    └── S3
```

---

## Estructura del proyecto

```
senderos/
├── backend/              ← API Laravel 13
│   ├── app/
│   │   ├── Http/Controllers/Api/  ← Controladores REST
│   │   ├── Models/                 ← Eloquent models
│   │   ├── Services/               ← Lógica de negocio
│   │   └── Providers/
│   ├── database/
│   │   ├── migrations/             ← 16 migraciones
│   │   ├── factories/              ← Model factories
│   │   └── seeders/                ← Database seeders
│   ├── routes/api.php              ← Endpoints (prefix: /api/v1)
│   └── tests/
├── frontend/             ← Panel admin React
│   └── src/
├── chiriqui_flutter/     ← App Flutter (iOS + Android)
│   └── chiriqui_flutter/
├── AGENTS.md             ← Contexto para AI coding agents
├── FLUTTER_APP_SPEC.md   ← Spec detallada de la app móvil
└── README.md
```

---

## Modelo de datos

| Tabla | Descripción |
|---|---|
| `zones` | Zonas geográficas (Boquete, Volcán, Gualaca, David, Golfo) |
| `categories` | Tipos de ruta (senderismo, café, cascadas, playas, termales) |
| `routes` | Rutas turísticas (tabla principal) |
| `route_images` | Galería de fotos por ruta (N imágenes, orden controlable) |
| `guides` | Guías locales con contacto WhatsApp |
| `route_guides` | Pivote N:M entre rutas y guías |
| `bookings` | Reservas de usuarios (requiere auth) |
| `badges` | Catálogo de insignias |
| `user_badges` | Insignias desbloqueadas por usuario |
| `weather_caches` | Clima cacheados por zona |
| `users` | Usuarios registrados |

---

## API Endpoints

Todas bajo el prefijo `/api/v1`.

### Públicos

| Método | URI | Descripción |
|---|---|---|
| GET | `/zones` | Listar zonas |
| GET | `/zones/{slug}/weather` | Clima de una zona |
| GET | `/categories` | Listar categorías |
| GET | `/routes` | Listar rutas (filtros: zone, category, difficulty, search) |
| GET | `/routes/{slug}` | Ficha de ruta |
| GET | `/routes/{slug}/guides` | Guías de una ruta |
| GET | `/guides` | Listar guías |

### Auth

| Método | URI | Descripción |
|---|---|---|
| POST | `/auth/register` | Registrar usuario |
| POST | `/auth/login` | Iniciar sesión |
| POST | `/auth/logout` | Cerrar sesión |
| GET | `/auth/me` | Perfil del usuario autenticado |

### Requieren auth (Sanctum)

| Método | URI | Descripción |
|---|---|---|
| GET | `/bookings` | Reservas del usuario |
| POST | `/bookings` | Crear reserva |
| GET | `/bookings/{id}` | Detalle de reserva |
| DELETE | `/bookings/{id}` | Cancelar reserva |
| GET | `/badges` | Catálogo de insignias |
| GET | `/me/badges` | Insignias del usuario |

---

## Instalación y desarrollo con Docker

### Requisitos

- Docker + Docker Compose
- Flutter SDK 3.19+ (solo para correr la app móvil fuera de Docker)

### Backend (Laravel Sail)

```bash
cd backend

# Copiar entorno y configurar DB (user: sail, password: secret, db: senderos)
cp .env.example .env

# Iniciar contenedores (PHP, PostgreSQL 18, Redis)
docker compose up -d

# Instalar dependencias y generar key
docker compose exec laravel.test composer install
docker compose exec laravel.test php artisan key:generate

# Migrar y seedear la base de datos
docker compose exec laravel.test php artisan migrate --seed
```

La API queda en `http://localhost`.

### Frontend admin

```bash
cd frontend
docker compose up -d
```

El frontend queda en `http://localhost:5174`.

### Full dev (backend + frontend + queue + logs)

```bash
cd backend
docker compose exec laravel.test composer run dev
```

### App Flutter

```bash
cd chiriqui_flutter/chiriqui_flutter
cp .env.example .env   # Configurar MAPBOX_PUBLIC_TOKEN y API_URL
flutter pub get
flutter run
```

---

## Convenciones de desarrollo

Ver `AGENTS.md` para convenciones detalladas. Resumen:

- Laravel: `Route::apiResource()` para endpoints REST
- Modelos: `php artisan make:model -m`
- Frontend: React + TS + Tailwind, componentes en `frontend/src/`
- Sin autenticación en endpoints públicos (Fase 1)
- Respuestas API en JSON
- Git: commits convencionales (`feat:`, `fix:`, `chore:`)

---

## Licencia

MIT
