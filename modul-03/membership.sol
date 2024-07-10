// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MembershipSystem {
    // Mapping to store members by their address
    mapping(address => bool) private members;
    address public owner;

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to add a new member
    function addMember(address _member) external onlyOwner {
        require(!members[_member], "Already a member");
        members[_member] = true;
    }

    // Function to remove an existing member
    function removeMember(address _member) external onlyOwner {
        require(members[_member], "Not a member");
        members[_member] = false;
    }

    // Function to check if an address is a member
    function isMember(address _member) external view returns (bool) {
        return members[_member];
    }
}
