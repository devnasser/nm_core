<?php

namespace App\Http\Controllers;

use App\Models$modelName;
use Illuminate\Http\Request;

class CommentsController extends Controller
{
    public function index()
    {
        return Comments::paginate();
    }

    public function store(Request )
    {
        return Comments::create(());
    }

    public function show()
    {
        return Comments::findOrFail();
    }

    public function update(Request , )
    {
         = Comments::findOrFail();
        (());
        return ;
    }

    public function destroy()
    {
        return Comments::destroy();
    }
}