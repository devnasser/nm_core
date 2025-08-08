<?php

namespace ZeroCode;

class UIGenerator
{
    public function generateInterfaces(array $models): array
    {
        $views = [];
        foreach ($models as $model) {
            $views[$model] = "<!-- Placeholder view for {$model} -->";
        }
        return $views;
    }
}