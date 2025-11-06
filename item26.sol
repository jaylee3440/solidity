// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
contract item26{

        string  text;

        function setText(string memory _text) public {

            text = _text;
        }

        function getText() view public returns(string memory){
            return  text;
        }
}