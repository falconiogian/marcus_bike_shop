<?php
class Cart {
    private $items = [];

    /**
     * Adds an item to the cart.
     *
     * @param Product $product The product being added.
     * @param array $options Array of OptionValue objects.
     * @param int $quantity The quantity of the product.
     */
    public function addItem($product, $options, $quantity = 1) {
        $this->items[] = ['product' => $product, 'options' => $options, 'quantity' => $quantity];
    }

    /**
     * Calculates the total price of items in the cart.
     *
     * @return float Total price.
     */
    public function calculateTotal() {
        $total = 0;
        foreach ($this->items as $item) {
            $productPrice = $item['product']->getBasePrice();
            $optionsPrice = array_reduce($item['options'], function($carry, $option) {
                return $carry + $option->getPriceModifier();
            }, 0);
            $total += ($productPrice + $optionsPrice) * $item['quantity'];
        }
        return $total;
    }

    /**
     * Returns all items in the cart.
     *
     * @return array
     */
    public function getItems() {
        return $this->items;
    }
}
?>
