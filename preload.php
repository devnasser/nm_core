<?php foreach (glob(__DIR__.'/code/zero-code/src/*.php') as $f) opcache_compile_file($f);
