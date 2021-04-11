<?php

namespace App\Helpers;

use App\Models\Item;
use App\Models\ItemHistory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class ItemRequestHelper
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
        $cacheKey = self::getCacheKey($key, $timestamp);

        return Cache::remember($cacheKey, self::CACHE_DURATION, function() use ($key, $timestamp) {
            if ($timestamp) {
                $object = Item::join('item_histories', 'items.id', 'item_histories.item_id')
                ->firstWhere([
                    'items.key' => $key,
                    'item_histories.timestamp' => $timestamp,
                ]);
            } else {
                $object = Item::firstWhere(['key' => $key]);
            }

            return data_get($object, 'value');
        });
    }

    /**
     * Store objects
     *
     * @param  array  $objects Objects
     * @param  int    $userId  User ID
     *
     * @return collection
     */
    public static function store(array $objects, int $userId) : array
    {
        $timestamp = now()->timestamp;

        $result = [];
        foreach ($objects as $key => $value) {
            $result[] = Item::updateOrCreate(
            [
                'key' => $key,
            ],
            [
                'value' => $value,
                'timestamp' => $timestamp,
                'user_id' => $userId,
            ]
        );
        }

        return $result;
    }

    /**
     * Clear cache
     *
     * @param  string $key       Key
     * @param  string $timestamp Timestamp
     *
     */
    public static function clearCache(string $key, string $timestamp = null)
    {
        $cacheKey = self::getCacheKey($key, $timestamp);

        Cache::forget($cacheKey);
    }

    /**
     * Get key used for caching
     *
     * @param  string      $key       Key
     * @param  string|null $timestamp Timestamp
     *
     * @return sting
     */
    private static function getCacheKey(string $key, string $timestamp = null) : string
    {
        $cacheKey = "ItemHelper::getValue-$key";

        if (!$timestamp) {
            return $cacheKey;
        }

        return $cacheKey . "-$timestamp";
    }
}
