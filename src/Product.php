<?php
class Product {
    public $id;
    public $name;
    public $basePrice;
    public $description;
    public $category;
    public $imageUrl;

    public function __construct($id, $name, $basePrice, $description = '', $category = '', $imageUrl = '') {
        $this->id = $id;
        $this->name = $name;
        $this->basePrice = $basePrice;
        $this->description = $description;
        $this->category = $category;
        $this->imageUrl = $imageUrl;
    }

    public function getBasePrice() {
        return $this->basePrice;
    }
}
?>
