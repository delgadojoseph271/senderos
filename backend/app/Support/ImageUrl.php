<?php

namespace App\Support;

class ImageUrl
{
    /**
     * placehold.co returns SVG by default; mobile clients need a raster format.
     */
    public static function rasterize(?string $url): ?string
    {
        if ($url === null || $url === '') {
            return $url;
        }

        if (! str_contains($url, 'placehold.co/')) {
            return $url;
        }

        if (preg_match('/\.(png|jpe?g|gif|webp|avif)(\?|$)/i', $url)) {
            return $url;
        }

        [$base, $query] = array_pad(explode('?', $url, 2), 2, null);

        return $base.'.png'.($query !== null ? '?'.$query : '');
    }
}
