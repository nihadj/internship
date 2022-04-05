// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./A_Token.sol";
interface Token{
    function approve(address spender,uint256 amount)external returns (bool);
}
contract Jamadar is ERC1155, Ownable {
    uint256[] supplies=[50,100,150];
    Token public token;
    uint256[] minted=[0,0,0];
    uint256[] prices=[0.05 ether, 0.1 ether, 0.025 ether];
    constructor()
        ERC1155("https://gateway.pinata.cloud/ipfs/QmV18Q9UKS5MXZMHWaG7eRPCZfHYTtz4Hfk8k31EfxPVTX")
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account,uint256 id, uint256 amount)
        public
        payable
        
    {
        require(id<=supplies.length,"Token doesn't exist");
        require(id!=0,"Token doesn't exist");
        uint256 index=id-1;
        require(minted[index]+amount<=supplies[index],"Not enough supply");
        require(msg.value>=amount*prices[index],"Not enough ether sent");
        if(token.approve(address(this),amount)){
            _mint(account,id,amount,"");
        }
    }

    function withdraw()public onlyOwner{
        require(address(this).balance>0,"Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }


}
