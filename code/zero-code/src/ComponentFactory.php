<?php

namespace ZeroCode;

class ComponentFactory
{
    public function createCRUDManager(string $modelName): string
    {
        // returns PHP class stub for controller
        $className = $modelName . 'Controller';
        return <<<PHP
<?php

namespace App\Http\Controllers;

use App\Models\$modelName;
use Illuminate\Http\Request;

class $className extends Controller
{
    public function index()
    {
        return $modelName::paginate();
    }

    public function store(Request $request)
    {
        return $modelName::create($request->all());
    }

    public function show($id)
    {
        return $modelName::findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $model = $modelName::findOrFail($id);
        $model->update($request->all());
        return $model;
    }

    public function destroy($id)
    {
        return $modelName::destroy($id);
    }
}
PHP;
    }
}