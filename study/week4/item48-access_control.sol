// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
contract AccessControl {

    mapping(string => mapping(address => bool)) private roleMapping;

    string public ADMIN = "admin";
    string public MANAGER = "manager";
    address public owner;

    constructor(){
        roleMapping[ADMIN][msg.sender] = true;
        owner = msg.sender;
    }

    modifier onlyOwner(string memory role){
        require(roleMapping[role][msg.sender],"not auth");
        _;
    }

    function setRole(address _addr) external onlyOwner(ADMIN) returns(bool){
        roleMapping[ADMIN][_addr] = true;
        return true;
    }

    function updateRole(address _addr) external onlyOwner(ADMIN) returns(bool){
        roleMapping[ADMIN][_addr] = false;
        return true;
    }


}
