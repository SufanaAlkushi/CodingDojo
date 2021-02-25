//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.1;

/**
 * @title Tech Insurance tor
 * @dev 
 * Step1: Complete the functions in the insurance smart contract
 * Step2:Add any required methods that are needed to check if the function are called correctly, 
 * and also add a modifier function that allows only the owner can run the changePrice function.
 * Step3: Add any error handling that may occur in any function
 * Step 4: add ERC 721 Token
 * 
 */
contract TechInsurance {
    /** 
     * Defined two structs
     * 
     * 
     */
    struct Product {
        uint productId;
        string productName;
        uint price;
        bool offered;
    }
     
    struct Client {
        bool isValid;
        uint time;

    }
    


    
    
    mapping(uint => Product) public productIndex;
    mapping(address => mapping(uint => Client)) public client;
    
    uint productCounter;
    
    address payable insOwner;
    constructor(address payable _insOwner) public{
        insOwner = _insOwner;
    }
 
    function addProduct(uint _productId, string memory _productName, uint _price ) public {
        Product memory newProduct =Product(_productId, _productName, _price, true);
        insOwner = msg.sender;
        productIndex[productCounter++] = newProduct;
       
        
 
    }
    
    
    function changeFalse(uint _productIndex) public returns(bool) {
        require(msg.sender == insOwner, "I'm not offer it");
        return productIndex[_productIndex].offered == false;

    }
    
    function changeTrue(uint _productIndex) public returns(bool) {
        require(msg.sender == insOwner, "I'm offer it");
        return productIndex[_productIndex].offered ==true;

    }

    function changePrice(uint _productIndex, uint _price) public view {
        require(productIndex[_productIndex].price >= 1, "not valid index" );
        productIndex[_productIndex].price== _price;
    }
    
    // handling the error
    function setPrice (uint _price) public {
        uint price = _price;
        require(insOwner == msg.sender, "you are not the owner");
    }
    
    function clientSelect(uint _productIndex) public payable returns(bool) {
        require(productIndex[_productIndex].price == msg.value, "Not appropriate" );
        require( productIndex[_productIndex].price == 0, "Not valid index");
        
        Client memory newClient;
        newClient.isValid = true;
        newClient.time = block.number;
        client[msg.sender][_productIndex] = newClient;
        insOwner.transfer(msg.value);
        
        }
        
    } 