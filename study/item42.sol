// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
contract item42{

}

contract TestCall{
    string public message;
    uint public x;

    event Log(address indexed caller, uint indexed amount, string msg);

    receive() external payable { }

    fallback() external payable { 
        emit Log(msg.sender, msg.value, "fallback was call");
    }

    function foo(string memory _message, uint256 _x) public payable returns(bool, uint){
        message = _message;
        x = _x;
        return (true,999);
    }
}
/**
encodeWithSignature() 必须使用规范的类型:以下名称是无效的:
    uint,int,byte

*/

contract Caller{
    bytes public data;

    constructor() payable {

    }

    function testFoo(address _test) external payable {
      (bool b,bytes memory datxx) =  _test.call{value:111}(abi.encodeWithSignature("foo(string,uint256)", "call test",123));
      require(b,"call fail");
      data = datxx;
    }
   function callNotExist(address _test) external payable {
      (bool b,bytes memory datxx) =  _test.call{value:111}(abi.encodeWithSignature("foo2(string,uint)", "call test",123));
      require(b,"call fail");
      data = datxx;
    }

    function getBalance() view external returns(uint){
        return address(this).balance;
    }
    
}