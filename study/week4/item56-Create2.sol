// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// 0x0c6F47CE49884c5670Bfab79e3bBf81775792c1e
// 0x0c6F47CE49884c5670Bfab79e3bBf81775792c1e
contract Create2Factory{
    event Deploy(address indexed _addr);

    function deploy(uint256 salt) external  {
        // address _addr = getAddress(salt);
        TestContract t = new TestContract{salt: bytes32(salt)}(msg.sender);
        emit Deploy(address(t));
    }

    function getAddress(uint256 _salt) public view returns(address addr){
        bytes32 hash = keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            _salt,
            keccak256(abi.encodePacked(
                type(TestContract).creationCode,
                abi.encode(msg.sender)))
        ));
        return address(uint160(uint256(hash)));
    }

    function getSalt() external pure returns(bytes32){
        return bytes32(uint256(777));
    }
}

contract TestContract{
    address public owner;
    constructor(address _owner){
        owner = _owner;
    }
}