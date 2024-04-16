# DeGramProfiles

![degramxskale](/assets/degramxskale.png)

## Overview

DeGramProfiles is a smart contract system built on the Skale Calypso blockchain that enables users to register and manage unique profiles on the decentralized platform, DeGram. Each profile is represented as a non-fungible token (NFT) with associated metadata, including a profile name and optional additional information. The contract utilizes whitelisting and access control mechanisms to ensure secure and authorized interactions. DeGram Profiles are non-transferrable and Self-sovereign identity

## Introduction

DeGramProfiles introduces a novel approach to profile management in the decentralized landscape. By leveraging blockchain technology, specifically smart contracts, DeGramProfiles offers a secure and transparent way for users to establish their digital identities. Each profile is represented as an NFT, ensuring uniqueness and ownership verification.

The contract system consists of multiple components, including access control mechanisms, whitelisting functionality, and utilities for encoding and string manipulation. This README will provide an in-depth overview of the technical details, contract interactions, and potential future enhancements.

## Technical Details

### DeGramCenter

DeGramCenter is an abstract contract that serves as the foundation for managing admin permissions within the DeGramProfiles ecosystem. It maintains a private state variable to store the contract owner's address and a mapping of addresses to indicate admin status. The contract includes modifiers such as `onlyOwner` and `onlyAdmin` to restrict function execution to authorized users. Additionally, it provides functions for updating admin status and retrieving the contract owner's address.

### DeGramCenter Contract Functions:

### 1. updateAdmin(address _address, bool _status)
   - **Purpose**: This function allows the contract owner to update the admin status of an address.
   - **Functionality**:
     - Only the contract owner can call this function due to the `onlyOwner` modifier.
     - Updates the `_admins` mapping to set the admin status of the provided address to the specified `_status`.
     - Emits the `AdminStatusUpdated` event to log the change in admin status.
     - Includes a requirement to ensure that the admin status being set does not conflict with the current status (`_admins[_address] != _status`).

### 2. owner()
   - **Purpose**: This function retrieves the address of the contract owner.
   - **Functionality**:
     - Returns the address of the contract owner, which is stored in the private state variable `_owner`.

### 3. admin(address _address)
   - **Purpose**: This function checks if a given address is an admin.
   - **Functionality**:
     - Returns `true` if `_address` is an admin (i.e., `_admins[_address]` is `true`), otherwise returns `false`.

### 4. constructor()
   - **Purpose**: The constructor function initializes the DeGramCenter contract and sets the contract deployer as the owner.
   - **Functionality**:
     - Sets the `_owner` state variable to the address of the contract deployer (`msg.sender`).

## Modifiers:

### 1. onlyOwner
   - **Purpose**: This modifier restricts function execution to the contract owner.
   - **Functionality**:
     - Requires that `msg.sender` matches the address stored in `_owner`.
     - If the requirement is met, the function execution continues with `_;`. Otherwise, it reverts with an error message: "Only the owner can perform this action!".

### 2. onlyAdmin
   - **Purpose**: This modifier restricts function execution to authorized admins.
   - **Functionality**:
     - Requires that `_admins[msg.sender]` is `true`, indicating that the sender is an admin.
     - If the requirement is met, the function execution continues with `_;`. Otherwise, it reverts with an error message: "Only an admin can perform this action!".

The `DeGramCenter` contract provides a foundation for managing admin permissions within the DeGramProfiles ecosystem. It ensures that only authorized admins and the contract owner can perform specific actions, maintaining control over critical functions and reducing the risk of unauthorized modifications.

### DeGramWhitelist

Building upon DeGramCenter, DeGramWhitelist is an abstract contract that introduces whitelisting functionality. It defines a struct `_WhitelistData` to store the whitelist status and referrer information for each address. The contract includes functions for directly adding or removing users from the whitelist, as well as a referral mechanism for existing whitelisted users to refer new users. It also provides modifiers and functions to restrict certain actions to whitelisted users only.

## DeGramWhitelist Contract Functions:

### 1. directWhitelist(address _address, bool _status)
   - **Purpose**: This function allows admins to directly add or remove a user from the whitelist.
   - **Functionality**:
     - Only admins can call this function due to the `onlyAdmin` modifier.
     - Updates the `_WhitelistData` struct in the `_whitelistStatus` mapping for the provided address, setting the `_status` field to the specified value.
     - Emits the `DirectlyWhitelisted` event to log the direct update of the whitelist status.
     - Includes a requirement to ensure that the whitelist status being set is different from the current status (`_whitelistStatus[_address]._status != _status`).

### 2. referWhitelist(address _address)
   - **Purpose**: This function allows existing whitelisted users to refer new users for whitelisting.
   - **Functionality**:
     - Only whitelisted users can call this function due to the `onlyWhitelisted` modifier.
     - Checks if the provided address is not already whitelisted (`_whitelistStatus[_address]._status != true`).
     - Ensures that the referrer's cooldown period has passed (`block.timestamp >= _referrerTimeStamp[msg.sender] + _referralCooldown`).
     - Updates the `_WhitelistData` struct in the `_whitelistStatus` mapping for the referred address, setting the `_status` field to `true` and the `_referrer` field to the sender's address.
     - Updates the `_referrerTimeStamp` mapping to store the current timestamp for the referrer's address.
     - Emits the `ReferredWhitelisted` event to log the whitelisting through referral.

### 3. updateCoolDown(uint _cooldownTime)
   - **Purpose**: This function allows admins to update the referral cooldown period.
   - **Functionality**:
     - Only admins can call this function due to the `onlyAdmin` modifier.
     - Updates the `_referralCooldown` variable to the specified `_cooldownTime`.

### 4. whitelistStatus(address _address)
   - **Purpose**: This function retrieves the whitelist status of a given address.
   - **Functionality**:
     - Returns the `_status` field of the `_WhitelistData` struct for the provided address from the `_whitelistStatus` mapping.

### 5. whitelistReferrer(address _address)
   - **Purpose**: This function retrieves the referrer address associated with a whitelisted user.
   - **Functionality**:
     - Returns the `_referrer` field of the `_WhitelistData` struct for the provided address from the `_whitelistStatus` mapping.

### 6. coolDownTime()
   - **Purpose**: This function retrieves the current referral cooldown period.
   - **Functionality**:
     - Returns the value of the `_referralCooldown` variable, representing the cooldown period in seconds.

## Modifiers:

### 1. onlyWhitelisted
   - **Purpose**: This modifier restricts function execution to only whitelisted users.
   - **Functionality**:
     - Requires that `_whitelistStatus[msg.sender]._status` is `true`, indicating that the sender is whitelisted.
     - If the requirement is met, the function execution continues with `_;`. Otherwise, it reverts with an error message: "Only Whitelisted user can perform this action!".

The `DeGramWhitelist` contract enhances the `DeGramCenter` contract by adding whitelisting functionality. It allows admins to directly manage the whitelist and provides a referral mechanism for whitelisted users to refer new users. The contract maintains the `_whitelistStatus` mapping to store the whitelist status and referrer information for each address. The referral cooldown period ensures that referrers cannot refer new users too frequently, preventing potential abuse.

### Base64 Encoding

The Base64 library provides a function to encode bytes data to its base64 representation. This is used to encode the SVG image and JSON metadata of a profile, ensuring compatibility with the ERC721 token standard.

### StringUtils

StringUtils is a library that offers utility functions for string manipulation. It includes a function to calculate the length of a given string, taking into account UTF-8 encoding, and a function to check if a string contains only alphanumeric characters.

## DeGramProfiles Contract

### DeGramProfiles Contract Functions:

### 1. constructor()
   - **Purpose**: The constructor function initializes the DeGramProfiles contract and sets the contract's name and symbol for the ERC721 tokens that represent profiles.
   - **Functionality**:
     - Inherits from `ERC721("deGram Profiles", "DGP")` to set the name and symbol of the ERC721 tokens.
     - Initializes the `_counter` variable to keep track of the number of registered profiles.
     - Sets the `svgPrefix` and `svgSuffix` variables used for generating SVG images of profile names.

### 2. register(string calldata name)
   - **Purpose**: This function allows whitelisted users to register a unique profile name and mint an associated NFT.
   - **Functionality**:
     - Checks if the user is whitelisted using the `onlyWhitelisted` modifier.
     - Validates the length of the profile name to be between 3 and 20 characters.
     - Ensures that the profile name has not already been claimed (`_profiles[name] == address(0)`).
     - Checks if the user has already claimed a profile (`!_addressClaimed[msg.sender]`).
     - Verifies that the profile name contains only alphanumeric characters.
     - Generates an SVG image and JSON metadata for the profile.
     - Mints a new NFT using `_safeMint(msg.sender, _counter)`.
     - Sets the token URI using `_setTokenURI(_counter, finalTokenUri)`.
     - Updates the `_profiles`, `_addressClaimed`, and `_getNameWithAddress` mappings to associate the profile name with the user's address.
     - Increments the `_counter` variable.

### 3. setRecord(string calldata name, string calldata record)
   - **Purpose**: This function allows users to set additional information or records associated with their profiles.
   - **Functionality**:
     - Checks if the user is the owner of the profile by verifying `_profiles[name] == msg.sender`.
     - Updates the `_records` mapping to store the provided record for the specified profile name.

### 4. transferFrom(address from, address to, uint256 tokenId)
   - **Purpose**: This function overrides the standard ERC721 `transferFrom` function to disallow transfers of profile NFTs.
   - **Functionality**:
     - Always reverts with "Transfers are not allowed", preventing transfers of profile ownership.

### 5. approve(address to, uint256 tokenId)
   - **Purpose**: This function overrides the standard ERC721 `approve` function to disallow approvals for profile NFTs.
   - **Functionality**:
     - Always reverts with "Approvals are not allowed", preventing approvals for profile NFTs.

### 6. setApprovalForAll(address operator, bool approved)
   - **Purpose**: This function overrides the standard ERC721 `setApprovalForAll` function to disallow setting approvals for all for profile NFTs.
   - **Functionality**:
     - Always reverts with "Approvals are not allowed", preventing setting approvals for all.

### 7. profiles(string calldata _name)
   - **Purpose**: This function retrieves the address that owns a particular profile.
   - **Functionality**:
     - Returns the address associated with the specified profile name from the `_profiles` mapping.

### 8. records(string calldata _name)
   - **Purpose**: This function retrieves the record or additional information associated with a particular profile.
   - **Functionality**:
     - Returns the record associated with the specified profile name from the `_records` mapping.

### 9. addressClaimed(address _address)
   - **Purpose**: This function checks if a given address has already claimed a profile.
   - **Functionality**:
     - Returns `true` if `_addressClaimed[_address]` is `true`, indicating that the address has claimed a profile.

### 10. getNameWithAddress(address _address)
   - **Purpose**: This function retrieves the profile name associated with a particular address.
   - **Functionality**:
     - Returns the profile name associated with the specified address from the `_getNameWithAddress` mapping.

### 11. counter()
   - **Purpose**: This function returns the current value of the `_counter` variable, representing the count of registered deGram Profiles.
   - **Functionality**:
     - Returns the value of `_counter`, which is incremented each time a new profile is registered.

### 12. addBadge(string calldata profileName, _BadgeType badgeType, string calldata badgeData)
   - **Purpose**: This function allows administrators to grant a badge to a user's profile.
   - **Functionality**:
     - Checks if the caller is an administrator using the `onlyAdmin` modifier.
     - Ensures that the specified profile exists and is not the zero address.
     - Updates the `_badges` mapping to associate the provided badge type and data with the profile name.
     - Emits the `BadgeAdded` event to log the addition of the badge.

### 13. badges(string calldata name)
   - **Purpose**: This function retrieves the badge information associated with a user's profile.
   - **Functionality**:
     - Returns the `_Badge` struct containing the badge type and data for the specified profile name, if it exists.

## Note:

The functions marked with `onlyWhitelisted` and `onlyAdmin` modifiers ensure that only whitelisted users or administrators, respectively, can execute those functions. The access control mechanisms provided by the `DeGramCenter` and `DeGramWhitelist` contracts help maintain the integrity and security of the profile registration and management process.

The core of the system is the DeGramProfiles contract, which inherits from ERC721URIStorage and DeGramWhitelist. It utilizes the OpenZeppelin ERC721 implementation to manage the NFT functionality. The contract includes a counter to keep track of the number of registered profiles and mappings to store profile names, associated records, and ownership information.

The `register` function allows whitelisted users to register a profile by minting an NFT with a unique SVG image as the token URI. The SVG image is generated dynamically based on the provided profile name. The contract also includes functions for setting profile records, retrieving profile information, and checking if an address has claimed a profile.

## Contract Interactions

### Profile Registration

To register a profile, a user must first be whitelisted. The `register` function takes a profile name as input and generates an SVG image and JSON metadata. The profile name is checked for uniqueness, length constraints, and alphanumeric characters. The NFT is then minted, and the profile name is associated with the user's address.

### Setting Profile Records

Users can set additional information about their profiles using the `setRecord` function. This allows them to include a description, contact information, or any other relevant data they wish to associate with their profile.

### Badge System

DeGramProfiles introduces a badge system that allows administrators to grant badges to user profiles. The `_Badge` struct stores the badge type and associated data. The `addBadge` function is restricted to administrators and allows them to add a badge to a specific profile. The `badges` function retrieves the badge information associated with a profile.

### Transfer and Approval Restrictions

The DeGramProfiles contract overrides the `transferFrom`, `approve`, and `setApprovalForAll` functions from the ERC721 standard to disallow transfers, approvals, and setting approvals for all. This ensures that profile ownership is non-transferable and that approvals are not required for interactions with the contract.

## Security Considerations

The DeGramProfiles contract system incorporates several security measures to protect user data and ensure the integrity of the system. The use of access control mechanisms and whitelisting helps prevent unauthorized access and ensures that only authorized users can perform specific actions. The contract also includes checks to prevent double-spending and enforce uniqueness of profile names.

Manual testing is successfully done. Hardhat testcases to be added.

## Testnet Deployement

Contract Address : [0x6b7c211CBc74CCc0BD19e942C4410dD800321558](https://giant-half-dual-testnet.explorer.testnet.skalenodes.com/address/0x6b7c211CBc74CCc0BD19e942C4410dD800321558)

First Token Mint : [0x6a0a0d48de057f524076c304fa441e3ac5de8442c7363d1a6b985aff180150be](https://giant-half-dual-testnet.explorer.testnet.skalenodes.com/tx/0x6a0a0d48de057f524076c304fa441e3ac5de8442c7363d1a6b985aff180150be)

![OwnerNFT](/assets//ownerprofile.png)

Note: This contract is deployed on Skale Calypso Hub **testnet**. 

## Built By
```
      @@@@@@@@@@@                                                                                   
    @@@@@@@@@@@@@@@@                                                                                
 @@@@@@@@@@@@@@@@@@@@@@           @@                  @@@@                                          
 @@@@@@@@@@@@@@@@@@@@@@@         @@@@              @@@@@@@@@@                                       
@@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@   @@@@@@    @@@@@   @@   @@@@@@@   @@@@@@@@  @@@@@@@@@ @@@@@  
@@@@@@@    @@    @@@@@@@@ @@@@@@@@@@@ @@@@  @@@@ @@@@          @@@@@@@ @@@@@@@@@@@ @@@@@@@@@@@@@@@@ 
@@@@@@@    @@    @@@@@@@@@@@@    @@@@ @@@@  @@@@ @@@@  @@@@@@@ @@@    @@@@    @@@@ @@@   @@@@   @@@ 
@@@@@@@@@@@@@@@@@@@@@@@@ @@@@    @@@@ @@@@@@@@@@ @@@@     @@@@ @@%    @@@@    @@@@ @@@   @@@@   @@@ 
@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@ @@@@@       @@@@@@@@@@@@ @@%     @@@@@@@@@@@ @@@   @@@@   @@@ 
@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@   @@@@@@@@     @@@@@@@@@  @@@      @@@@@@@@@@ @@@   @@@@   @@@ 
@@@@@@@@@@@@@@@@@@@@                                                                                
@@@@@@@@@@@@@@@@@                                                                                   
```