// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20{

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}
    fallback() external payable { }
    receive() external payable { }  
    event Deposit();
    event WithDraw();

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit();
    }

    function withDraw(uint256 amount) public payable {
        _burn(msg.sender, amount);
        payable (msg.sender).transfer(amount);
        emit WithDraw();
    }


}