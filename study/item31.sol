// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item31{
    
}

/*
    
*/
contract A{

    function FA() pure public virtual returns(string memory){
        return "A";
    }
}

contract B is A{
    event printLog(string indexed msg);
    constructor(){
        emit printLog("this is B");
    }
    function FA() pure override public virtual returns(string memory){
        return "B";
    }
}

/*
    C 如果继承A,B 这里的A,B 有顺序要求 C执行super.FA打印的是B的结果
*/
contract C is A{

    event printLogB(string indexed msg);
    constructor(){
        emit printLogB("this is C");
    }
    function FA() override virtual  pure public returns(string memory){
       return  "c";
    }
}

/*
    D继承B,C 如果执行super的话，谁在右边先打印谁
    
*/
contract D is B,C{
    function FA() override(B,C) pure public returns(string memory){
        return super.FA();
    }
}