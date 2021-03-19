//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;


contract Insurance {
    

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
   address private contractOwner;
    uint M = 2;
    address [] public authenticators ;
    address [] public vAuth;
    // Mapping from token ID to owner address
    mapping (uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping (address => uint256) private _balances;
    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;
    mapping (uint256 => uint256) public _verifyAuth;
    mapping (address => bool) public isAuther;
    mapping (uint => mapping (address => bool)) public confirmations;
    
    
        constructor() public {
        contractOwner = msg.sender;
        // authenticators.push(msg.sender);
        isAuther[msg.sender] = false;
    }
 

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
    
        function ownerOf(uint256 tokenId) public view virtual  returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
    
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }
    
        function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }
    
        function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }
    
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
    uint public verifyCount = 0;
    
     //address payable insOwner;
    // constructor(address payable _insOwner) public{
    //     insOwner = _insOwner;
    // }
 
    function addProduct(uint _productId, string memory _productName, uint _price) public  {
        // make the contract owner who add products
       productCounter++;
       
       productIndex[productCounter]= Product(_productId, _productName, _price, false);
       _verifyAuth[productCounter]= 0; // newwww

       // this step need to be verified by MultiSig ->> accept or reject
       //_mint(prodOwner, productCounter);
    }
    
    
    function doNotOffer(uint _productIndex) public OnlyinsOwner(_productIndex) {

        productIndex[_productIndex].offered = false;
    }
    
    function forOffer(uint _productIndex) public OnlyinsOwner(_productIndex) {
        
        productIndex[_productIndex].offered = true;
    }
    
    function changePrice(uint _productIndex, uint _price) public OnlyinsOwner(_productIndex) {

        productIndex[_productIndex].price = _price;
        
    }
    

      function fetch(uint _productIndex)public view returns(uint productId,string memory productName,uint price, bool offere ,address owner){
        productId =productIndex[_productIndex].productId;
        productName =productIndex[_productIndex].productName;
        price = productIndex[_productIndex].price;
        offere = productIndex[_productIndex].offered;
        owner = ownerOf(_productIndex);
        
    }


    function getBalance(address _address) public view returns(uint256 balance){
     balance = address(_address).balance;
        
    }
    
    function buyInsurance(uint _productIndex) public payable TimeCheck {
        require(productIndex[_productIndex].offered == true, "This item is sold out!");
        require(msg.value <= productIndex[_productIndex].price, "You don't have enough tokens!");       
        Client(true, block.timestamp);
        //buyer =  msg.sender;
        _transfer(ownerOf(_productIndex), msg.sender,_productIndex);   
        doNotOffer(_productIndex);   
    }
    
    modifier onlyContractOwner() {
      require(msg.sender == contractOwner, "Not contract owner");
        _;
    }
    
    modifier notNull() {
    require(msg.sender != address(0));
        _;
    }
    
     modifier AuthenticatorExist(address _address){
        require(isAuther[_address] == false, "already added!");
        _;
  }
    
     function getAuths() public view returns (address[] memory)
    {
        return authenticators;
    }
    
    function addAuths(address _address) public onlyContractOwner() 
    AuthenticatorExist(_address) notNull() {
        isAuther[_address] = true;
        Authrize(_address);
    }

    function Authrize(address _add) private returns (uint _x) {
        require(isAuther [msg.sender] == true, "no you can't");
        authenticators.push(_add);
        return (authenticators.length);
    }


    function verify(uint _id) public{
        require(isAuther [msg.sender] == true, "You are not authrize");
        
      //  _verifyAuth[_id]++;
      //     mapping (uint => mapping (address => bool) ) public confirmations;
      confirmations[_id][msg.sender]=true;
      //verifyCount++;
        if (verifyCount == M) {
            confirm(_id);
        }
    }
    
    function confirm(uint _id) private {
        _mint(contractOwner, _id);
        forOffer(_id);
        verifyCount =0;
    }
    
    function sigAddress(uint _id) public view returns(bool adds, uint n){
        
        adds = confirmations[_id][msg.sender];
        n = verifyCount;
    }
    
    // contractOwner

}    