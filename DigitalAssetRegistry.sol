// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Digital Asset Registry
 * @dev A smart contract for registering and verifying digital assets on the blockchain
 */
contract DigitalAssetRegistry {
    // Events for tracking activities
    event AssetRegistered(bytes32 indexed assetHash, address indexed owner, uint256 timestamp);
    event OwnershipTransferred(bytes32 indexed assetHash, address indexed previousOwner, address indexed newOwner);
    event AssetMetadataUpdated(bytes32 indexed assetHash, string newMetadata);

    // Structure to store asset information
    struct Asset {
        bytes32 assetHash;      // Unique identifier/hash of the asset
        address owner;          // Current owner of the asset
        uint256 registrationTime; // When the asset was registered
        string metadata;        // Additional metadata about the asset (could be IPFS hash or JSON)
        bool exists;            // Flag to check if asset exists
    }

    // Mapping from asset hash to Asset struct
    mapping(bytes32 => Asset) private assets;
    
    // Mapping from owner address to their assets (for easier access)
    mapping(address => bytes32[]) private ownerAssets;

    // Counter for total registered assets
    uint256 public totalAssets;

    /**
     * @dev Register a new digital asset
     * @param _assetHash Hash of the digital asset
     * @param _metadata Additional information about the asset
     * @return success Boolean indicating successful registration
     */
    function registerAsset(bytes32 _assetHash, string memory _metadata) public returns (bool success) {
        // Check if asset already exists
        require(!assets[_assetHash].exists, "Asset already registered");
        
        // Create new asset
        assets[_assetHash] = Asset({
            assetHash: _assetHash,
            owner: msg.sender,
            registrationTime: block.timestamp,
            metadata: _metadata,
            exists: true
        });
        
        // Add to owner's assets list
        ownerAssets[msg.sender].push(_assetHash);
        
        // Increment total assets counter
        totalAssets++;
        
        // Emit event
        emit AssetRegistered(_assetHash, msg.sender, block.timestamp);
        
        return true;
    }

    /**
     * @dev Verify an asset and return its details
     * @param _assetHash Hash of the digital asset to verify
     * @return owner The address of the asset owner
     * @return registrationTime When the asset was registered
     * @return metadata Additional information about the asset
     * @return exists Boolean confirming the asset exists
     */
    function verifyAsset(bytes32 _assetHash) public view returns (
        address owner,
        uint256 registrationTime,
        string memory metadata,
        bool exists
    ) {
        Asset memory asset = assets[_assetHash];
        
        return (
            asset.owner,
            asset.registrationTime,
            asset.metadata,
            asset.exists
        );
    }

    /**
     * @dev Transfer ownership of an asset to another address
     * @param _assetHash Hash of the digital asset
     * @param _newOwner Address of the new owner
     * @return success Boolean indicating successful transfer
     */
    function transferOwnership(bytes32 _assetHash, address _newOwner) public returns (bool success) {
        // Check if asset exists
        require(assets[_assetHash].exists, "Asset does not exist");
        
        // Check if sender is the current owner
        require(assets[_assetHash].owner == msg.sender, "Only the owner can transfer ownership");
        
        // Check that new owner is not the zero address
        require(_newOwner != address(0), "New owner cannot be the zero address");
        
        // Store previous owner for the event
        address previousOwner = assets[_assetHash].owner;
        
        // Update owner in asset struct
        assets[_assetHash].owner = _newOwner;
        
        // Remove asset from previous owner's list (more complex, would be gas intensive)
        // Instead, we maintain the historical record but primary lookup is through the asset mapping
        
        // Add to new owner's assets list
        ownerAssets[_newOwner].push(_assetHash);
        
        // Emit ownership transfer event
        emit OwnershipTransferred(_assetHash, previousOwner, _newOwner);
        
        return true;
    }

    /**
     * @dev Update metadata for an existing asset
     * @param _assetHash Hash of the digital asset
     * @param _newMetadata New metadata to associate with the asset
     * @return success Boolean indicating successful update
     */
    function updateMetadata(bytes32 _assetHash, string memory _newMetadata) public returns (bool success) {
        // Check if asset exists
        require(assets[_assetHash].exists, "Asset does not exist");
        
        // Check if sender is the current owner
        require(assets[_assetHash].owner == msg.sender, "Only the owner can update metadata");
        
        // Update metadata
        assets[_assetHash].metadata = _newMetadata;
        
        // Emit metadata update event
        emit AssetMetadataUpdated(_assetHash, _newMetadata);
        
        return true;
    }

    /**
     * @dev Get all assets owned by an address
     * @param _owner Address to check assets for
     * @return assetHashes Array of asset hashes owned by the address
     */
    function getAssetsByOwner(address _owner) public view returns (bytes32[] memory) {
        return ownerAssets[_owner];
    }

    /**
     * @dev Get total number of registered assets
     * @return count Total number of assets in the registry
     */
    function getAssetCount() public view returns (uint256) {
        return totalAssets;
    }
}