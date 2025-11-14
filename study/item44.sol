// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Account{
    address public addr;
    address public bank;
    constructor(address _addr)payable {
        addr = _addr;
        bank = msg.sender;
    }
}

contract AccountFactory{
    Account[] public  accouts;

    constructor() payable {}
    function createAccount(address  _addr) external {
        Account account = new Account{value:111}(_addr);
        accouts.push(account);
    }
} 