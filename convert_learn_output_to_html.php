<?php
require_once __DIR__.'/Parsedown.php';
$base = __DIR__.'/learn_output';
if (!is_dir($base)) { fwrite(STDERR, "learn_output directory not found\n"); exit(1);} 
$rii = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($base));
$parsedown = Parsedown::instance();
foreach ($rii as $file) {
    if ($file->isDir()) continue;
    if (strtolower($file->getExtension()) !== 'md') continue;
    $markdown = file_get_contents($file->getPathname());
    $body = $parsedown->text($markdown);
    $title = htmlspecialchars(basename($file->getFilename(), '.md'));
    $html = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><title>{$title}</title><link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\"></head><body class=\"container py-4\">{$body}</body></html>";
    $newPath = substr($file->getPathname(), 0, -3).'.html';
    file_put_contents($newPath, $html);
    echo "Converted: {$newPath}\n";
}
?>