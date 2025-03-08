# Digital Asset Registry Smart Contract

A blockchain-based solution for registering and verifying ownership of digital assets.

## Overview

This smart contract provides a secure way to register digital assets on the Ethereum blockchain. Users can register assets, verify ownership, transfer ownership to others, and update asset metadata.

## Features

- **Asset Registration**: Register any digital asset using its unique hash and metadata
- **Ownership Verification**: Quickly verify who owns a specific digital asset
- **Ownership Transfer**: Securely transfer asset ownership to other users
- **Metadata Management**: Store and update information about your digital assets

## How It Works

1. **Register Assets**: Submit a unique hash representing your digital asset along with metadata
2. **Verify Ownership**: Look up any registered asset to confirm its current owner
3. **Transfer Assets**: Transfer ownership rights to another Ethereum address
4. **Update Information**: Modify metadata associated with your assets as needed

## Getting Started

### Prerequisites

- [MetaMask](https://metamask.io/) or another Ethereum wallet
- [Remix IDE](https://remix.ethereum.org/) (for deployment and testing)

### Deployment

1. Open Remix IDE in your browser
2. Create a new Solidity file named `DigitalAssetRegistry.sol`
3. Copy the contract code into the file
4. Compile the contract (Solidity compiler 0.8.0 or higher recommended)
5. Deploy using either:
   - MetaMask (for live networks)
   - JavaScript VM (for testing)

### Interacting with the Contract

#### Registering an Asset

Call the `registerAsset` function with:

- Asset hash (in bytes32 format with 0x prefix)
- Metadata (string with information about your asset)

Example:

```
registerAsset("0xeb43530d6b5747a2bb91642498b6f6338ac4dca8df41e303e6308ed2300d0a8a", "{'title': 'My Digital Art', 'creator': 'Artist Name', 'created': '2025-02-15'}")
```

#### Verifying an Asset

Call the `verifyAsset` function with the asset hash to retrieve:

- Current owner address
- Registration timestamp
- Associated metadata
- Existence status

#### Transferring Ownership

Call the `transferOwnership` function with:

- Asset hash
- New owner's Ethereum address

Note: Only the current owner can transfer ownership.

## Technical Details

- **Solidity Version**: 0.8.0+
- **License**: MIT
- **Main Data Structure**: Mapping of bytes32 hashes to Asset structs

## Common Issues

- When providing asset hashes through Remix IDE, always include the "0x" prefix
- For ownership transfers, ensure you're connected with the correct account

## Future Enhancements

- IPFS integration for extended metadata storage
- ERC-721 compatibility for NFT marketplaces
- Batch registration and transfer operations
- Royalty management for content creators
