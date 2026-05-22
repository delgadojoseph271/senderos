<?php

use Illuminate\Foundation\Application;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));
// Start output buffering to avoid "headers already sent" errors
@ob_start();

// Register shutdown function to log header/output state for debugging
register_shutdown_function(function () {
    $file = null;
    $line = null;
    $hs = headers_sent($file, $line);
    $level = ob_get_level();
    $length = ob_get_length();
    $contents = @ob_get_contents();
    $included = get_included_files();
    $msg = sprintf("[%s] Shutdown: headers_sent=%s at %s:%s — ob_level=%d ob_length=%s\n", date('Y-m-d H:i:s'), $hs ? 'true' : 'false', $file ?? 'unknown', $line ?? 'unknown', $level, $length === false ? 'false' : $length);
    if ($hs) {
        $bt = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS);
        $bt = array_slice($bt, 0, 15);
        $msg .= "Backtrace:\n" . print_r($bt, true) . "\n";
    }

    // write to Laravel log and try to persist to files for easier inspection
    error_log($msg);
    @file_put_contents(__DIR__ . '/../storage/logs/debug_headers.txt', $msg . "\nContents:\n" . ($contents === false ? 'false' : $contents) . "\nIncluded:\n" . print_r($included, true) . "\n", FILE_APPEND | LOCK_EX);
    @file_put_contents(__DIR__ . '/../storage/logs/laravel.log', "\n[debug_headers] " . $msg, FILE_APPEND | LOCK_EX);
    // fallback to /tmp so we can inspect from the container even if storage isn't writable
    @file_put_contents('/tmp/debug_headers_full.txt', $msg . "\nContents:\n" . ($contents === false ? 'false' : $contents) . "\nIncluded:\n" . print_r($included, true) . "\n", FILE_APPEND | LOCK_EX);
});

// Determine if the application is in maintenance mode...
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

// Register the Composer autoloader...
require __DIR__.'/../vendor/autoload.php';

// Bootstrap Laravel and handle the request...
/** @var Application $app */
$app = require_once __DIR__.'/../bootstrap/app.php';

$app->handleRequest(Request::capture());
