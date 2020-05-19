pragma solidity ^0.5.16;

import "./DloopGovernance.sol";
import "./DloopUtil.sol";

contract DloopArtwork is DloopGovernance, DloopUtil {
    struct Artwork {
        uint16 editionSize;
        uint16 editionCounter;
        uint8 artistProofSize;
        uint8 artistProofCounter;
        bool hasEntry;
        Data[] dataArray;
    }

    mapping(uint64 => Artwork) private _artworkMap; //uint64 represents the artworkId

    event ArtworkCreated(uint64 indexed artworkId);
    event ArtworkDataAdded(uint64 indexed artworkId, bytes32 indexed dataType);

    function createArtwork(
        uint64 artworkId,
        uint16 editionSize,
        uint8 artistProofSize,
        bytes32 dataType,
        bytes memory data
    ) public onlyMinter returns (bool) {
        require(!_artworkMap[artworkId].hasEntry, "artworkId already exists");
        require(editionSize <= 10000, "editionSize must not exceed 10000");
        require(artistProofSize <= 10, "artistProofSize must not exceed 10");
        require(editionSize > 0, "editionSize must be positive");
        require(artistProofSize > 0, "artistProofSize must be positive");

        _artworkMap[artworkId].hasEntry = true;
        _artworkMap[artworkId].editionSize = editionSize;
        _artworkMap[artworkId].artistProofSize = artistProofSize;

        emit ArtworkCreated(artworkId);
        addArtworkData(artworkId, dataType, data);

        return true;
    }

    function _addTokenToArtwork(
        uint64 artworkId,
        uint16 editionNumber,
        uint8 artistProofNumber
    ) internal {
        Artwork storage aw = _artworkMap[artworkId];

        require(aw.hasEntry, "artworkId does not exist");

        if (editionNumber > 0) {
            require(
                editionNumber <= aw.editionSize,
                "editionNumber must not exceed editionSize"
            );
            aw.editionCounter++;
        }

        if (artistProofNumber > 0) {
            require(
                artistProofNumber <= aw.artistProofSize,
                "artistProofNumber must not exceed artistProofSize"
            );
            aw.artistProofCounter++;
        }
    }

    function addArtworkData(
        uint64 artworkId,
        bytes32 dataType,
        bytes memory data
    ) public onlyMinter returns (bool) {
        require(_artworkMap[artworkId].hasEntry, "artworkId does not exist");

        _artworkMap[artworkId].dataArray.push(Data(dataType, data));

        emit ArtworkDataAdded(artworkId, dataType);
        return true;
    }

    function getArtworkDataLength(uint64 artworkId)
        public
        view
        returns (uint256)
    {
        require(_artworkMap[artworkId].hasEntry, "artworkId does not exist");
        return _artworkMap[artworkId].dataArray.length;
    }

    function getArtworkData(uint64 artworkId, uint256 index)
        public
        view
        returns (bytes32 dataType, bytes memory data)
    {
        Artwork memory aw = _artworkMap[artworkId];

        require(aw.hasEntry, "artworkId does not exist");
        require(
            index < aw.dataArray.length,
            "artwork data index is out of bounds"
        );

        dataType = aw.dataArray[index].dataType;
        data = aw.dataArray[index].data;
    }

    function getArtworkInfo(uint64 artworkId)
        public
        view
        returns (
            uint16 editionSize,
            uint16 editionCounter,
            uint8 artistProofSize,
            uint8 artistProofCounter
        )
    {
        Artwork memory aw = _artworkMap[artworkId];
        require(aw.hasEntry, "artworkId does not exist");

        editionSize = aw.editionSize;
        editionCounter = aw.editionCounter;
        artistProofSize = aw.artistProofSize;
        artistProofCounter = aw.artistProofCounter;
    }
}
