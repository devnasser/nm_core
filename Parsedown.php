<?php
# Parsedown 1.7.4 (simplified single file)
# https://github.com/erusev/parsedown (MIT License)
class Parsedown
{
    public static function instance() {
        static $instance; if (!$instance) { $instance = new Parsedown(); } return $instance; }
    public function text($text) { $elements = $this->lines(explode("\n", $text)); return $this->elements($elements); }
    protected function lines($lines) {
        $elements = [];
        foreach ($lines as $line) {
            if (preg_match('/^(#{1,6})\s*(.+)$/', $line, $m)) {
                $level = strlen($m[1]); $elements[] = ['h',$level,$m[2]]; continue; }
            if (preg_match('/^\s*\-\s+(.+)$/', $line, $m)) {
                if (empty($elements) || end($elements)[0]!=='ul') { $elements[] = ['ul',[]]; }
                $elements[count($elements)-1][1][] = $m[1]; continue; }
            if (preg_match('/^\s*$/',$line)) { $elements[] = ['br']; continue; }
            $elements[] = ['p',$line];
        }
        return $elements;
    }
    protected function elements($elements) {
        $html = '';
        foreach ($elements as $el) {
            switch($el[0]) {
                case 'h': $html .= '<h'.$el[1].'>'.htmlspecialchars($el[2]).'</h'.$el[1].'>'; break;
                case 'p': $html .= '<p>'.htmlspecialchars($el[1]).'</p>'; break;
                case 'br': $html .= '<br>'; break;
                case 'ul': $html .= '<ul>'; foreach($el[1] as $li) { $html .= '<li>'.htmlspecialchars($li).'</li>'; } $html .= '</ul>'; break;
            }
        }
        return $html;
    }
}
?>