<?php

namespace App\Http\Controllers;

use App\Address;
use Illuminate\Http\Request;


class AddressController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function index()
    {
        
     $addresses = Address::all();

     return response()->json($addresses);

    }

     public function create(Request $request)
     {
         try {
            $address = new Address;

            $address->party_id       = $request->party_id;
            $address->type           = $request->type;
            $address->street         = $request->street;
            $address->district       = $request->district;
            $address->city           = $request->city;
            $address->state          = $request->state;
            $address->postal_code    = $request->postal_code;
            $address->region         = $request->region;
            $address->country_id     = $request->country_id;
            
            $address->save();
     
            return response()->json($address);
         } catch (\Throwable $th) {
            return response()->json($th->getMessage());
         }
       
     }

     public function show($id)
     {
        $address = Address::find($id);

        return response()->json($address);
     }

     public function update(Request $request, $id)
     { 
        $address= Address::find($id);
        
        $address->name = $request->input('name');
        $address->price = $request->input('price');
        $address->description = $request->input('description');
        $address->save();
        return response()->json($address);
     }

     public function destroy($id)
     {
        $address = Address::find($id);
        $address->delete();

         return response()->json('Address removed successfully');
     }


    }

    
