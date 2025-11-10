// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item32{


}


contract s{
    event sLog(string indexed msg);
    string public name;
    constructor(string memory _name){
        name = _name;
        emit sLog("sssssssss");
    }
}

contract s1{
    string public text;

    event s1Log(string indexed msg);
    constructor(string memory _text){
        text = _text;
        emit s1Log("s1111111");
    }
}
/*
构造函数执行顺序按照继承顺序执行,即先执行s1,后执行s
*/
contract s2 is s1,s{
    event s2Log(string indexed msg);
    constructor(string memory _name, string memory _text) s(_name) s1(_text){
        emit s2Log("sss222222222222");
    }
}

