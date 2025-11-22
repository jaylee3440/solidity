
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;



/**

    执行目标合约的逻辑来存储自己的变量，变量声明顺序必须一致
    如何避免因为变量顺序引起的错误
    1.使用继承，变量定义到父合约中，子合约都继承父合约
    2.EIP-1967 通过哈希计算存储槽位进行存储（如 bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)），位置固定且远离常规变量（常规变量从存储槽 0 开始）。
    3.工具校验
*/
contract Caller{
    uint256 public num;
    address public addr;
    event Log(string msg);
    function update(uint256 _num) public {
        num = _num;
        addr = msg.sender;
        emit Log("xxxxxxxxxxxxxxxxxxxxx");
    }


}

contract Callee{
    uint256 public num;
    address public addr;

    function updateData(address _addr, uint256 _num) public  returns (bool,bytes memory){
        (bool b,bytes memory data) = _addr.delegatecall(
            abi.encodeWithSelector(Caller.update.selector, _num)
        );
        return (b,data);
    }
}