<?php

namespace App\Http\Controllers;

use App\Product;
use Illuminate\Http\Request;


class ProductController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function index()
    {
        
     $products = Product::all();

     return response()->json($products);

    }

     public function create(Request $request)
     {
         try {
            $product = new Product;

            $product->party_id         = $request->party_id;
            $product->name             = $request->name;
            $product->inventory_level  = $request->inventory_level;
            $product->save();
     
            return response()->json($product);
         } catch (\Throwable $th) {
            return response()->json($th->getMessage());
         }
       
     }

     public function show($id)
     {
        $product = Product::find($id);

        return response()->json($product);
     }

     public function update(Request $request, $id)
     { 
        $product= Product::find($id);

        $product->party_id       = $request->input('party_id');
        $product->name           = $request->input('name');
        $product->inventory_level = $request->input('inventory_level');

        $product->save();

        return response()->json($product);
     }

     public function destroy($id)
     {
        $product = Product::find($id);
        $product->delete();

         return response()->json('product removed successfully');
     }


    }

    
