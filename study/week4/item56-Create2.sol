// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


contract contractFactory{

}

contract TestContract{
    address public owner;
    constructor(address _owner){
        owner = _owner;
    }
}