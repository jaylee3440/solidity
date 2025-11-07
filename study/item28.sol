// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item28 {
    /*
        最多只能为三个参数创建索引indexed
     */
    event sendMsg(address indexed _address, string indexed msg);

    function send(string calldata _text) external {
        
        emit sendMsg(msg.sender, _text);
    }

    function getHash(string memory _text) external pure returns(bytes32){

        return keccak256(abi.encodePacked(_text));
    }

      function getStringHash(string memory _input) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_input));
    }
}
