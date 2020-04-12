<?php

namespace App\Http\Controllers;

use App\Contact;
use Illuminate\Http\Request;


class ContactController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function index()
    {
        
     $contacts = Contact::all();

     return response()->json($contacts);

    }

     public function create(Request $request)
     {
         try {
            $contact = new Contact;

            $contact->party_id            = $request->party_id;
            $contact->contact_type_id     = $request->contact_type_id;
            $contact->name                = $request->name;
            $contact->details             = $request->details;
            
            $contact->save();
     
            return response()->json($contact);
         } catch (\Throwable $th) {
            return response()->json($th->getMessage());
         }
       
     }

     public function show($id)
     {
        $contact = Contact::find($id);

        return response()->json($contact);
     }

     public function update(Request $request, $id)
     { 
        $contact= Contact::find($id);
        
        $contact->party_id = $request->input('party_id');
        $contact->contact_type_id = $request->input('contact_type_id');
        $contact->name = $request->input('name');
        $contact->details = $request->input('details');

        $contact->save();

        return response()->json($contact);
     }

     public function destroy($id)
     {
        $contact = Contact::find($id);
        $contact->delete();

         return response()->json('Contact removed successfully');
     }


    }

    
