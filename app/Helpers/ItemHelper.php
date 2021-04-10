<?php

namespace App\Helpers;

use App\Models\Item;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class ItemHelper
{
    const CACHE_DURATION = 600; // 10 minutes

    /**
     * Get an object
     *
     * @param  string      $key       Item Key
     * @param  string|null $timestamp Item Timestamp
     *
     * @return json|null
     */
    public static function getValue(string $key, string $timestamp = null)
    {
        $cacheKey = "ItemHelper::getValue-$key-$timestamp";

        return Cache::remember($cacheKey, self::CACHE_DURATION, function() use ($key, $timestamp) {
            if ($timestamp) {
                $object = Item::firstWhere([
                  'key' => $key,
                  'created_at' => $timestamp,
                ]);
            } else {
                $object = Item::firstWhere(['key' => $key]);
            }

            return data_get($object, 'value');
        });
    }
}
