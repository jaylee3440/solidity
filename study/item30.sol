// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


/**
    virtual 修饰function: 表示该方法可以被重写
    override 修饰function： 表示该方法时重写的方法
    多级继承中A(foo)->B(foo)->C(foo)
    C合约执行foo执行的时B合约foo函数逻辑 就近执行



*/
contract A {

    function foo() virtual  pure public returns(string memory){
        return "A";
    }

    function bar() virtual  pure public returns(string memory){
        return "B";
    }

    function car() pure  public returns(string memory){
        return "C";
    }

}

contract B is A{
    function foo() override virtual  pure public returns(string memory){
        return "A1";
    }

    function bar() override pure public returns(string memory){
        return "B1";
    }
}

contract C is B{
    function foo() override pure public returns (string memory){
        return "A2";
    }
}