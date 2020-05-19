pragma solidity ^0.5.16;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./DloopGovernance.sol";

contract DloopManagedToken is ERC721, DloopGovernance {
    mapping(uint256 => bool) private _managedMap;

    function isManaged(uint256 tokenId) public view returns (bool) {
        require(super._exists(tokenId), "tokenId does not exist");
        return _managedMap[tokenId];
    }

    function _setManaged(uint256 tokenId, bool managed) internal {
        _managedMap[tokenId] = managed;
    }
}
