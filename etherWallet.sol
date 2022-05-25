pragma solidity ^0.8.0;

contract EtherWallet{

    address payable public owner;

    constructor(){
        owner=payable(msg.sender);
    }

    receive() external payable{}
    function withdraw(uint amount)public{
        require(amount<=address(this).balance);
        require(msg.sender==owner);
        payable(msg.sender).transfer(amount);
    }

    
}
