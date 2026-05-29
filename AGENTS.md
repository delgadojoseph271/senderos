# Senderos — Project Context

> Versión: 0.1 · Fase 1 MVP · Mayo 2026

---

## ¿Qué es el proyecto?

**Senderos** es una aplicación móvil (iOS + Android) que centraliza las rutas turísticas de la provincia de Chiriquí, Panamá. Permite a un turista encontrar rutas, revisar información básica y contactar guías locales — sin registro, sin pagos, sin GPS activo en esta primera fase.

El nombre comercial de la versión completa será **Chiriquí Explora**.

---

## Stack tecnológico

| Capa | Tecnología |
|---|---|
| App móvil | Flutter (iOS + Android) — *pendiente* |
| Backend / API | Laravel 13 (PHP) — `backend/` |
| Frontend admin | React + TypeScript + Vite + Tailwind — `frontend/` |
| Base de datos | MySQL |
| Almacenamiento de imágenes | S3 o compatible |

## Arquitectura general

```
Flutter App (futuro)
    └── HTTP (REST JSON)
            └── Laravel API (backend/)
                    ├── MySQL (datos)
                    └── S3 (imágenes)
```

Admin panel (frontend/) consume la misma API.

---

## Modelo de datos

### Tablas

| Tabla | Descripción |
|---|---|
| `zones` | Zonas geográficas de Chiriquí (Boquete, Volcán, Gualaca, etc.) |
| `categories` | Tipos de ruta (senderismo, café, cascadas, playas, termales, etc.) |
| `routes` | Rutas turísticas. Tabla principal. |
| `route_images` | Galería de fotos por ruta (N imágenes, orden controlable) |
| `guides` | Guías locales con contacto WhatsApp |
| `route_guides` | Pivote N:M entre rutas y guías |

### Columnas destacadas de `routes`

```
id, zone_id (FK), category_id (FK)
name, slug (unique)
description (text)
difficulty (enum: fácil | moderado | difícil | experto)
duration_minutes, distance_km, elevation_gain_m
start_lat, start_lng          ← decimal(10,7), punto de inicio para el mapa
cover_image                   ← URL en S3
tips                          ← JSON array de strings
is_active (bool)
timestamps
```

---

## Scope Fase 1

- Catálogo de rutas con filtros por zona, categoría y dificultad
- Ficha de ruta (fotos, descripción, duración, distancia, desnivel, tips)
- Mapa con pin de inicio (sin trazado ni navegación GPS)
- Directorio de guías con botón de WhatsApp
- Favoritos locales (sin cuenta de usuario)

---

## Convenciones importantes

### Para AI coding agents

1. **Laravel: usar rutas con `Route::apiResource()` para endpoints REST.**
2. **Modelos: usar `php artisan make:model -m` para crear migraciones.**
3. **Frontend: React + TS con Tailwind. Componentes en `frontend/src/`.**
4. **No usar autenticación en Fase 1.**
5. **Todas las respuestas de la API en JSON.**
6. **Imágenes: URL absoluta apuntando a S3 (o placeholder local).**
7. **Git: commits convencionales (`feat:`, `fix:`, `chore:`, etc.).**

### Endpoints por crear (Fase 1)

| Método | URI | Descripción |
|---|---|---|
| GET | /api/routes | Listar rutas (con filtros) |
| GET | /api/routes/{slug} | Ficha de ruta |
| GET | /api/zones | Listar zonas |
| GET | /api/categories | Listar categorías |
| GET | /api/guides | Listar guías |
| GET | /api/routes/{slug}/guides | Guías de una ruta |

---

## Comandos útiles

```bash
# Backend
cd backend && php artisan serve
php artisan migrate
php artisan db:seed
php artisan make:model Route -m

# Frontend
cd frontend && npm run dev
npm run build

# Full dev (desde backend/)
composer run dev
```
