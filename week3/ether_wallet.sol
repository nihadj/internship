// SPDX-License-Identifier: MIT
contract Ether_wallet{
    address payable public owner;
    constructor(){
        owner=payable(msg.sender);

    }



    receive() external payable{}
    function withdraw(uint amount) external{
        require(owner==msg.sender);
        payable(msg.sender).transfer(amount);


    }

    
    function see_balance() public view returns(uint){
        return address(this).balance;
    }

    
}