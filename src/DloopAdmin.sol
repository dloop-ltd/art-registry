pragma solidity ^0.5.16;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract DloopAdmin {
    mapping(address => bool) private _adminMap;
    uint256 private _adminCount = 0;

    event AdminAdded(address indexed account);
    event AdminRenounced(address indexed account);

    constructor() public {
        _adminMap[msg.sender] = true;
        _adminCount = 1;
    }

    modifier onlyAdmin() {
        require(_adminMap[msg.sender], "caller does not have the admin role");
        _;
    }

    function numberOfAdmins() public view returns (uint256) {
        return _adminCount;
    }

    function isAdmin(address account) public view returns (bool) {
        return _adminMap[account];
    }

    function addAdmin(address account) public onlyAdmin {
        require(!_adminMap[account], "account already has admin role");
        _adminMap[account] = true;
        _adminCount = _adminCount + 1;
        emit AdminAdded(account);
    }

    function renounceAdmin() public onlyAdmin {
        _adminMap[msg.sender] = false;
        _adminCount = _adminCount - 1;
        require(_adminCount > 0, "minimum one admin required");
        emit AdminRenounced(msg.sender);
    }
}
