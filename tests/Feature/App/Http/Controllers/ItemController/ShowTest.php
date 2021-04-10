<?php

namespace Tests\Feature\App\Http\Controllers\ItemController;

use App\Models\User;
use App\Models\Item;
use Tests\TestCase;

class ShowTest extends TestCase
{
    /**
     * Setup before tests
     */
    protected function setUp(): void
    {
        parent::setUp();

        $this->user = create(User::class);
        $this->actingAs($this->user, 'api');
    }

    /**
     * test value will be returned when valid key is provided
     *
     * @return void
     */
    public function test_value_will_be_returned_when_valid_key_is_provided()
    {
        $validItem = create(Item::class, ['key' => 'valid_key', 'value' => 'valid_value']);

        $this->json('GET', '/api/object/valid_key')
          ->assertOk()
          ->assertJson([
              'data' => 'valid_value'
          ]);
    }

    /**
     * test error response will be returned when invalid key is provided
     *
     * @return void
     */
    public function test_error_response_will_be_returned_when_invalid_key_is_provided()
    {
        $this->json('GET', '/api/object/invalid_key')
          ->assertNotFound()
          ->assertJson([
              'error' => 'Item with provided key not found'
          ]);
    }
}
