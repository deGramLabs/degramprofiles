// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "contracts/deGramProfiles/accesscontrol/DeGramCenter.sol";

// Define an abstract contract that builds upon DeGramCenter, adding whitelisting functionality.
abstract contract DeGramWhitelist is DeGramCenter {
    // Define a struct to hold the whitelist status and referrer information for each address.
    struct _WhitelistData {
        bool _status;          // Indicates if the address is whitelisted.
        address _referrer;    // The address that referred this user, if applicable.
    }

    // Mapping to store the whitelist status and referrer for each address.
    mapping(address => _WhitelistData) private _whitelistStatus;

    // Store the cooldown period.
    uint private _referralCooldown = 30 minutes;

    // Mapping to keep track of the last time an address was referred, used for cooldown enforcement.
    mapping(address => uint) private _referrerTimeStamp;

    // Event emitted when a user's whitelist status is directly updated by an admin.
    event DirectlyWhitelisted(address indexed user, bool newStatus);

    // Event emitted when a user's whitelist status is updated as a result of being referred by another user.
    event ReferredWhitelisted(address indexed user, address indexed referrer);

    // Modifier to restrict function access to only users who are whitelisted.
    modifier onlyWhitelisted() {
        require(_whitelistStatus[msg.sender]._status == true, "Only Whitelisted user can perform this action!");
        _;
    }

    // Function to directly add or remove a user from the whitelist by an admin.
    function directWhitelist(address _address, bool _status) public onlyAdmin {
        require(_whitelistStatus[_address]._status != _status, "Whitelist Status is already updated");
        _whitelistStatus[_address]._status = _status;
        emit DirectlyWhitelisted(_address, _status);
    }

    // Function to refer a user for whitelisting by an existing whitelisted user.
    function referWhitelist(address _address) public onlyWhitelisted {
        require(_whitelistStatus[_address]._status != true, "This address is already whitelisted");
        require(block.timestamp >= _referrerTimeStamp[msg.sender] + _referralCooldown, "Referrer is still on cooldown");
        _whitelistStatus[_address]._status = true;
        _whitelistStatus[_address]._referrer = msg.sender;
        _referrerTimeStamp[msg.sender] = block.timestamp;
        emit ReferredWhitelisted(_address, msg.sender);
    }


    // Function to update the referral cooldown period for new referrals.
    function updateCoolDown(uint _cooldownTime) public onlyAdmin {
        _referralCooldown = _cooldownTime;
    }

    // Function to check the whitelist status of an address.
    function whitelistStatus(address _address) public view virtual returns(bool) {
        return _whitelistStatus[_address]._status;
    }

    // Function to retrieve the referrer of a whitelisted address.
    function whitelistReferrer(address _address) public view virtual returns(address) {
        return _whitelistStatus[_address]._referrer;
    }

    // Function to get the current referral cooldown period.
    function coolDownTime() public view virtual returns(uint){
        return _referralCooldown;
    }
}
