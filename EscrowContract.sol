pragma solidity >=0.4.22 <0.7.0;

contract Escrow {
    
    // Escrow agent
    address agent;
    
    // List of recipients
    address payable[] public recipients;
    
    // Store money in escrow for each recipient
    mapping(address => uint256) public deposits;
    
    
    modifier onlyAgent() {
        require(msg.sender == agent);
        _;
    }
    
    constructor() public {
        agent = msg.sender;
    }
    
    // Deposit ether into escrow
    function deposit() public onlyAgent payable {
        uint256 amount = msg.value;
        for (uint256 i = 0; i < recipients.length; i++) {
            deposits[recipients[i]] += amount;
        }
    }
    
    // Transfer ether from escrow to recipient
    function send() public onlyAgent {
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 payment = deposits[recipients[i]];
            deposits[recipients[i]] = 0;
            recipients[i].transfer(payment);
        }
    }
    
    function addRecipient(address payable recipient) public {
        recipients.push(recipient);
    }
}
