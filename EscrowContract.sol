pragma solidity ^0.5.0;

contract Escrow {
    
    // Escrow agent
    address payable owner;
    
    // Pause status
    bool public isPaused = false;
    
    // List of recipients
    address payable[] public recipients;
    
    // Store money in escrow for each recipient
    mapping(address => uint256) public deposits;
    
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier isRunning {
        require(!isPaused);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    // Deposit ether into escrow
    function deposit() public onlyOwner isRunning payable {
        uint256 amount = msg.value/recipients.length;
        for (uint256 i = 0; i < recipients.length; i++) {
            deposits[recipients[i]] += amount;
        }
    }
    
    // Transfer ether from escrow to recipient
    function send() public onlyOwner isRunning payable {
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 payment = deposits[recipients[i]];
            deposits[recipients[i]] = 0;
            recipients[i].transfer(payment);
        }
    }
    
    // Add new wallet address to recipients array
    function addRecipient(address payable recipient) public onlyOwner {
        recipients.push(recipient);
    }
    
    // Pause contract
    function pauseContract() public onlyOwner {
        isPaused = true;
    }
    
    // Play contract
    function playContract() public onlyOwner {
        isPaused = false;
    }
    
    // Send stored ether to owner and remove code from blockchain
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
}
