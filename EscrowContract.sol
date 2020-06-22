pragma solidity >=0.4.22 <0.7.0;

contract Escrow {
    address agent;
    mapping(address => uint256) public deposits;
    
    modifier onlyAgent() {
        require(msg.sender == agent);
        _;
    }
    
    constructor() public {
        agent = msg.sender;
    }
    
    // Deposit ether into escrow
    function deposit(address recipient) public onlyAgent payable {
        uint256 amount = msg.value;
        deposits[recipient] = deposits[recipient] + amount;
    }
    
    // Withdraw ether from escrow and send to recipient
    function withdraw(address payable recipient) public onlyAgent {
        uint256 payment = deposits[recipient];
        deposits[recipient] = 0;
        recipient.transfer(payment);
    }
}
