// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item40{


}


contract callTestContract{

    function testGetx(address _addr) view public returns(uint){
        return testContract(_addr).getX();
    }

    function testSetx(address _addr, uint _x) public {
        testContract(_addr).setX(_x);
    }

    function testGetAll(address _addr) public view returns(uint,uint){
        return  testContract(_addr).getAll();
    }



}

contract testContract{

    uint public x;
    uint public y;

    function getX() view public returns(uint){
        return x;
    }

    function setX(uint _x) public {
        x = _x;
    }

    function getAll()view public returns(uint, uint){

        return (x,y);
    }


}