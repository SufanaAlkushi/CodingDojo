//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.1;



import "github/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
contract TechInsurance is ERC721("Elite","e"){
    
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
    
    

    
     modifier OnlyinsOwner(uint _prodID) {
         require(msg.sender == ownerOf(_prodID));
         _;
    }
         modifier TimeCheck {
         require(block.timestamp <= timeLocked + 15 minutes );
         _;
     }
    
    mapping(uint => Product) public productIndex;
    mapping(address => mapping(uint => Client)) public client;
    uint256 timeLocked = block.timestamp;
    uint productCounter;
    
     address payable insOwner;
    // constructor(address payable _insOwner) public{
    //     insOwner = _insOwner;
    // }
 
    function addProduct(uint _productId, string memory _productName, uint _price ) public  {
        
       productCounter++;
       address  prodOwner = msg.sender;
       productIndex[productCounter]= Product(_productId, _productName, _price, true);
       _mint(prodOwner, productCounter);
    }
    
    
    function doNotOffer(uint _productIndex) public  {

        productIndex[_productIndex].offered = false;
    }
    
    function forOffer(uint _productIndex) public OnlyinsOwner(_productIndex) {
        
        productIndex[_productIndex].offered = true;
    }
    
    function changePrice(uint _productIndex, uint _price) public OnlyinsOwner(_productIndex) {

        productIndex[_productIndex].price = _price;
        
    }
    
    
    function buyInsurance(uint _productIndex) public payable  {
        require(productIndex[_productIndex].offered == true, "This item is sold out!");
        require(msg.value <= productIndex[_productIndex].price, "You don't have enough tokens!");
        doNotOffer(_productIndex);        
        Client(true, block.timestamp);
        _transfer(ownerOf(_productIndex), msg.sender,_productIndex);   
        doNotOffer(_productIndex);    
    } 
}