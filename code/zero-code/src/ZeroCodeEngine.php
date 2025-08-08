<?php

namespace ZeroCode;

class ZeroCodeEngine
{
    private SchemaBuilder $schemaBuilder;
    private ComponentFactory $componentFactory;
    private BusinessLogicEngine $businessLogicEngine;
    private UIGenerator $uiGenerator;

    public function __construct()
    {
        $this->schemaBuilder = new SchemaBuilder();
        $this->componentFactory = new ComponentFactory();
        $this->businessLogicEngine = new BusinessLogicEngine();
        $this->uiGenerator = new UIGenerator();
    }

    public function generateSystem(array $systemSchema): array
    {
        // 1. DB schema SQL
        $sql = $this->schemaBuilder->buildDatabaseSchema($systemSchema);

        // 2. Models list (assume names equal table names in StudlyCase)
        $models = array_map(function ($table) {
            return str_replace(' ', '', ucwords(str_replace('_', ' ', $table['name'])));
        }, $systemSchema['tables']);

        // 3. Business logic stubs
        $logic = $this->businessLogicEngine->generateLogic($systemSchema['rules'] ?? []);

        // 4. UI stubs
        $views = $this->uiGenerator->generateInterfaces($models);

        // 5. Controller stubs
        $controllers = [];
        foreach ($models as $model) {
            $controllers[$model] = $this->componentFactory->createCRUDManager($model);
        }

        return [
            'sql' => $sql,
            'models' => $models,
            'controllers' => $controllers,
            'views' => $views,
            'logic' => $logic,
        ];
    }
}