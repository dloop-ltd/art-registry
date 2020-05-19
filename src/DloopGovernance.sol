pragma solidity ^0.5.16;

import "./DloopAdmin.sol";

contract DloopGovernance is DloopAdmin {
    bool private _minterRoleEnabled = true;
    mapping(address => bool) private _minterMap;

    event AllMintersDisabled(address indexed sender);
    event AllMintersEnabled(address indexed sender);
    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    constructor() public {
        addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(_minterRoleEnabled, "all minters are disabled");
        require(isMinter(msg.sender), "caller does not have the minter role");
        _;
    }

    function disableAllMinters() public onlyMinter {
        _minterRoleEnabled = false;
        emit AllMintersDisabled(msg.sender);
    }

    function enableAllMinters() public onlyAdmin {
        require(!_minterRoleEnabled, "minters already enabled");
        _minterRoleEnabled = true;
        emit AllMintersEnabled(msg.sender);
    }

    function isMinter(address account) public view returns (bool) {
        require(_minterRoleEnabled, "all minters are disabled");
        return _minterMap[account];
    }

    function isMinterRoleActive() public view returns (bool) {
        return _minterRoleEnabled;
    }

    function addMinter(address account) public onlyAdmin {
        require(!_minterMap[account], "account already has minter role");
        _minterMap[account] = true;
        emit MinterAdded(account);
    }

    function removeMinter(address account) public onlyAdmin {
        require(_minterMap[account], "account does not have minter role");
        _minterMap[account] = false;
        emit MinterRemoved(account);
    }
}
