// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Abstract contract that provides a foundation for managing admin permissions.
abstract contract DeGramCenter {
    // Private state variable to store the address of the owner of the contract.
    address private _owner;

    // Private state mapping from addresses to booleans, indicating whether an address is an admin.
    mapping(address => bool) private _admins;

    // Event emitted when an admin's status is updated.
    event AdminStatusUpdated(address indexed adminAddress, bool status);

    /**
     * @dev Modifier that restricts function execution to the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the owner can perform this action!");
        _; // Continue with the original function call
    }

    /**
     * @dev Modifier that restricts function execution to authorized admins.
     */
    modifier onlyAdmin() {
        require(_admins[msg.sender], "Only an admin can perform this action!");
        _; // Continue with the original function call
    }

    /**
     * @dev Updates an address's admin status. Only the owner can invoke this function.
     * @param _address The address whose admin status is to be updated.
     * @param _status The new admin status (true for admin, false for non-admin).
     */
    function updateAdmin(address _address, bool _status) public onlyOwner {
        // Ensure the admin status being set does not conflict with the current status
        require(_admins[_address] != _status, "Admin status already updated!");
        _admins[_address] = _status;
        emit AdminStatusUpdated(_address, _status);
    }

    /**
     * @dev Retrieves the address of the contract owner.
     * @return The owner's address.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Checks if an address is an admin.
     * @param _address The address to check.
     * @return The admin status of the address.
     */
    function admin(address _address) public view returns (bool) {
        return _admins[_address];
    }

    /**
     * @dev Constructor that initializes the contract with the deployer as the owner.
     */
    constructor() {
        _owner = msg.sender; // Set the deployer's address as the owner of the contract
    }
}
