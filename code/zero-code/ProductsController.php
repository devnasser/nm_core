<?php

namespace App\Http\Controllers;

use App\Models$modelName;
use Illuminate\Http\Request;

class ProductsController extends Controller
{
    public function index()
    {
        return Products::paginate();
    }

    public function store(Request )
    {
        return Products::create(());
    }

    public function show()
    {
        return Products::findOrFail();
    }

    public function update(Request , )
    {
         = Products::findOrFail();
        (());
        return ;
    }

    public function destroy()
    {
        return Products::destroy();
    }
}