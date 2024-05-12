pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;
    mapping(uint => Product) public products;


    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Dapp Uni";
    }

    function createProduct(string memory _name, uint _price) public {
        // REquire a valid name
        require(bytes(_name).length > 0);
        // Require a valid price
        require(_price > 0);
        // Increment product count
        productCount ++;
        // Make sure parameters are corret
        // Create the product
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        // Trigger event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        // Fetch product
        Product memory _product = products[_id];
        // Fetch owner
        address payable _seller = _product.owner;
        // Make sure product has valid id
        require(_product.id > 0 && _product.id <= productCount);
        // Require that there is engouth ETH in transaction
        require(msg.value >= _product.price);
        // Require that product has not already been purchased
        require(!_product.purchased);
        // Require that the buyer is not the seller
        require(_seller != msg.sender);
        // Transfer ownership / Purchase it
        _product.owner = msg.sender;
        // Mark as purchased
        _product.purchased = true;
        // Update the product
        products[_id]= _product;
        // Pay the seller with ETH
        address(_seller).transfer(msg.value);
        // Trigger event
        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);
    }

}