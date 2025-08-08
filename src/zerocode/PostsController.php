<?php

namespace App\Http\Controllers;

use App\Models$modelName;
use Illuminate\Http\Request;

class PostsController extends Controller
{
    public function index()
    {
        return Posts::paginate();
    }

    public function store(Request )
    {
        return Posts::create(());
    }

    public function show()
    {
        return Posts::findOrFail();
    }

    public function update(Request , )
    {
         = Posts::findOrFail();
        (());
        return ;
    }

    public function destroy()
    {
        return Posts::destroy();
    }
}