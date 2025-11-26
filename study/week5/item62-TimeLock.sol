// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract TimeLock{

    uint256 public MIN_DELAY;
    uint256 public MAX_DELAY;

    mapping(bytes32=> bool) public queued;

    address public owner;

    event Exceute();
    event Cancel();
    event Queued();
    error TxAlreadyQueued();
    error TimeNotInRange();
    error NotQueued();
    error NotStart();
    error OutOfTimes();

    modifier onlyOnwer(){
        require(msg.sender == owner, "not owner");
        _;
    }


    constructor(uint256 _minDelay, uint256 _maxDelay){
        owner = msg.sender;
        MIN_DELAY = _minDelay;
        MAX_DELAY = _maxDelay;
    }

    function doQueued(
        address target,
        string calldata func,
        uint256 value,
        bytes calldata data,
        uint256 times
    ) external onlyOnwer {
        // check is exist
        bytes32 txId = _getTxId(target,func,value,data);
        if(queued[txId]){
            revert TxAlreadyQueued();
        }
        // check time in range
        if(block.timestamp + MIN_DELAY > times || block.timestamp + MAX_DELAY < times){
            revert TimeNotInRange();
        }

        queued[txId] = true;

        emit Queued();

    }

    function exceute(
        address target,
        string calldata func,
        uint256 value,
        bytes calldata _data,
        uint256 times
    ) public {
        bytes32 txId =_getTxId(target, func, value, _data);
        // check 
        if(!queued[txId]){
            revert NotQueued();
        }

        //  if(block.timestamp + MIN_DELAY > times || block.timestamp + MAX_DELAY < times){
        if(block.timestamp + MIN_DELAY > times){
            revert NotStart();
        }
        if(block.timestamp + MAX_DELAY < times){
            revert OutOfTimes();
        }

        queued[txId] = false;
        bytes memory data;
        if(bytes(func).length > 0){
            data = abi.encodePacked(
                bytes4(keccak256(bytes(func))), _data
            );
        }else{
            data = _data;
        }

        (bool success, ) = target.call{value: value}(data);
        require(success, "call fail");
        emit Exceute();

    }

    function _getTxId(
        address target,
        string calldata func,
        uint256 value,
        bytes calldata data
    ) private pure returns(bytes32){
        return keccak256(abi.encode(target, func, value, data));
    }


}