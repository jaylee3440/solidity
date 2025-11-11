// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
contract item39{

    address public immutable owner;

    modifier onlyOwner(address _to){
        require(owner == _to, "no auth");
        _;
    }

    constructor() payable {
        owner = msg.sender;
    }

    receive() external payable { }  

    fallback() external payable { } 

    function withdraw(uint _amount) external payable onlyOwner(msg.sender) {
        payable (owner).transfer(_amount);
    }

    function getBalance() external view onlyOwner(msg.sender) returns(uint){
        return address(this).balance;
    }

}

contract sendEth{

    constructor()payable {

    }

    function sende(address payable _addr, uint _amount) payable  external {
        _addr.transfer(_amount);
    }
}


