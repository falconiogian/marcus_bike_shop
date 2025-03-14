<?php
class OptionValue {
    public $id;
    public $optionId;
    public $name;
    public $priceModifier;
    public $inStock;

    public function __construct($id, $optionId, $name, $priceModifier, $inStock = true) {
        $this->id = $id;
        $this->optionId = $optionId;
        $this->name = $name;
        $this->priceModifier = $priceModifier;
        $this->inStock = $inStock;
    }

    public function getPriceModifier() {
        return $this->priceModifier;
    }
}
?>
