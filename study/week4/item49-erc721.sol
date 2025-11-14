// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface MY_IERC721 {
    // from -> to 转移tokenId
    event Transfer(address indexed from, address indexed to, uint256 tokenId);
    // 允许 approved 使用 owner 的tokenId
    event Approval(address indexed owner, address indexed approved, uint256 tokenId);
    //  当 `owner` 开启/关闭 `operator` 对其所有 NFT 的管理权限时触发
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    // 查看tokenId所有owner
    function ownerOf(uint256 tokenId) external view returns(address);
    /**
    * @dev 带数据的安全转账（数据会传递给接收方合约的 `onERC721Received` 函数）
    */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    /**
    * @dev 安全转账（额外检查接收方是否为合约，若为合约需实现 `onERC721Received` 接口）
    * 防止 NFT 被误转入不支持 ERC721 的合约导致永久锁定
    */ 
    function safeTransferFrom(address from, address to, uint256) external;
     /**
     * @dev 将 `tokenId` 从调用者（`msg.sender`）转移到 `to`
     * 要求：
     * - 调用者必须是 `tokenId` 的所有者或被授权者
     * - `to` 不能是零地址或合约自身
     * - `tokenId` 必须存在
     */
    function transferFrom(address from, address to, uint256 tokenId) external ;
    /**
    * @dev 授权 `approved` 地址操作 `tokenId`
    * 调用者必须是 `tokenId` 的所有者或拥有管理权限（`ApprovalForAll`）
    */
    function approve(address to, uint256 tokenId) external ;
    /**
    * @dev 开启/关闭 `operator` 对调用者所有 NFT 的管理权限
    * 授权后，`operator` 可操作调用者的所有 NFT（无需逐个授权）
    */
    function setApprovalForAll(address operator, bool _approved)external ;
    /**
    * @dev 查询 `tokenId` 的授权地址（若有）
    */
    function getApproved(uint256 tokenId) external view returns(address);
     /**
     * @dev 查询 `operator` 是否拥有 `owner` 所有 NFT 的管理权限
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    // 返回owner持有nft数量
    function balanceOf(address owner) external view returns(uint256);
}

contract MY_ERC721 is MY_IERC721{

    mapping(address => uint) private balanceNumMapping;
    mapping(address => mapping(address => bool)) isApprovedForAllMapping;
    mapping(uint256 => address) nftOwnerMapping;
    mapping(uint256 => address) nftApprovedMapping;

    function ownerOf(uint256 tokenId) external view returns(address){
       return nftOwnerMapping[tokenId];
    }

    function getApproved(uint256 tokenId) external view returns(address){
        return nftOwnerMapping[tokenId];
    }

    function balanceOf(address owner) external view returns(uint256){
        return balanceNumMapping[owner];
    }

    function isApprovedForAll(address owner, address operator) external view returns(bool){
        return isApprovedForAllMapping[owner][operator];
    }

     /**
    * @dev 开启/关闭 `operator` 对调用者所有 NFT 的管理权限
    * 授权后，`operator` 可操作调用者的所有 NFT（无需逐个授权）
    */
    function setApprovalForAll(address operator, bool _approved) external {
        require(address(0)!=operator,"operator is address zero");
        isApprovedForAllMapping[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }
      /**
    * @dev 授权 `approved` 地址操作 `tokenId`
    * 调用者必须是 `tokenId` 的所有者或拥有管理权限（`ApprovalForAll`）
    */
    function approve(address approved, uint256 tokenId) external{
        require(approved != address(0), "to is address zero");
        require(nftOwnerMapping[tokenId] == msg.sender, "not owner");
        
        nftApprovedMapping[tokenId] = approved;

        emit Approval(msg.sender, approved, tokenId);
        
    }

    /**
    * @dev 将 `tokenId` 从调用者（`from`）转移到 `to`
    * 要求：
    * -  调用者必须是 `tokenId` 的所有者或被授权者
    * - `to` 不能是零地址或合约自身
    * - `tokenId` 必须存在
    */
    function transferFrom(address from, address _to, uint256 tokenId) external {
        require(nftOwnerMapping[tokenId] != address(0), "tokenId not exist");
        require(_to != address(0), "to address is zero");
        require(nftOwnerMapping[tokenId] == from 
            ||nftApprovedMapping[tokenId] == from
            ||isApprovedForAllMapping[msg.sender][from] == true
             ,"no auth" );
        nftOwnerMapping[tokenId] = _to;
        delete nftApprovedMapping[tokenId];
        balanceNumMapping[from] -= 1;
        balanceNumMapping[_to] += 1;
        emit Transfer(from, _to, tokenId);

        
    }

     /**
    * @dev 带数据的安全转账（数据会传递给接收方合约的 `onERC721Received` 函数）
    */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external{

    }
    /**
    * @dev 安全转账（额外检查接收方是否为合约，若为合约需实现 `onERC721Received` 接口）
    * 防止 NFT 被误转入不支持 ERC721 的合约导致永久锁定
    */ 
    function safeTransferFrom(address from, address to, uint256) external{

    }
}