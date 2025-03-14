<?php
class Option {
    public $id;
    public $name;
    public $productId;

    public function __construct($id, $name, $productId) {
        $this->id = $id;
        $this->name = $name;
        $this->productId = $productId;
    }
}
?>
