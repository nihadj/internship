pragma solidity ^0.8.0;
contract TestContract{
    uint x;
    address owner;
    constructor(uint _x,address _owner){
        x=_x;
        owner=_owner;
    }
}
contract NewWay{
    function deploy(address _owner,uint _x,bytes32 _salt) public payable returns(address){
        return address(new TestContract{salt:_salt}(_x,_owner)); 
    }
}









//old way

contract FactoryOld{
    //get bytecode first
    function getByteCode(uint _x,address _owner)public pure returns(bytes memory){
       bytes memory bytecode=type(TestContract).creationCode;
       return abi.encodePacked(bytecode,abi.encode(_x,_owner));

    }

    // compute address of the contract to be deployed.

    function getAddress(bytes memory bytecode,uint _salt)public view returns(address){
        bytes32 hash=keccak256(abi.encodePacked(bytes1(0xff),address(this),_salt,keccak256(bytecode)));
        return address(uint160(uint(hash)));
    }

    


}
