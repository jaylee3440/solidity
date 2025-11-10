// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item35{

    address public immutable owner;

    constructor(){
        owner = msg.sender;
    }

    function getOwner() view  external  returns(address ){
        return  owner;
    }

    function setOwner(address  _addr) external {
       //  owner = _addr; 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    }

}