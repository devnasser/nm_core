<?php

namespace ZeroCode;

class SchemaBuilder
{
    /**
     * Build database migration SQL from system requirements
     *
     * @param array $schema Raw schema definition
     * @return string SQL statements
     */
    public function buildDatabaseSchema(array $schema): string
    {
        // Very naïve example: only supports simple tables definition
        $statements = [];

        foreach ($schema['tables'] ?? [] as $table) {
            $columnsSql = [];
            foreach ($table['columns'] as $name => $type) {
                $columnsSql[] = sprintf("`%s` %s", $name, $this->mapType($type));
            }
            $statement = sprintf(
                "CREATE TABLE IF NOT EXISTS `%s` (%s);",
                $table['name'],
                implode(', ', $columnsSql)
            );
            $statements[] = $statement;
        }

        return implode("\n", $statements);
    }

    private function mapType(string $type): string
    {
        return match($type) {
            'string' => 'VARCHAR(255)',
            'text'   => 'TEXT',
            'int', 'integer' => 'INT',
            'bigint' => 'BIGINT',
            'bool', 'boolean' => 'TINYINT(1)',
            'datetime' => 'DATETIME',
            default => 'VARCHAR(255)'
        };
    }
}