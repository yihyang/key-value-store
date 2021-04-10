<?php

namespace App\Http\Controllers;

use App\Helpers\ItemHelper;
use Illuminate\Http\Request;

class ItemController extends Controller
{
    /**
     * Get a specific Item
     *
     * @param  Request $request Request Item
     *
     * @return Response
     */
    public function show(Request $request, string $key)
    {
        $timestamp = $request->input('timestamp');
        $objectValue = ItemHelper::getValue($key, $timestamp);

        if (!$objectValue) {
            return response()->json(
              [
                'error' => 'Object not found'
              ],
              404
            );
        }

        return response()->json([
          'data' => $objectValue
        ]);
    }
}
