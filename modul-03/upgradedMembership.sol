// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UpgradedMembershipSystem {
    // Enum for membership types
    enum MembershipType { Regular, Silver, Gold, Platinum }

    // Struct to define a member
    struct Member {
        uint256 id;
        string name;
        uint256 balance;
        MembershipType membershipType;
    }

    // Mapping to store members by their address
    mapping(address => Member) private members;
    address public owner;
    uint256 private memberCounter;

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
        memberCounter = 1; // Member ID starts at 1
    }

    // Function to add a new member
    function addMember(address _member, string memory _name, uint256 _balance, MembershipType _membershipType) external onlyOwner {
        require(members[_member].id == 0, "Already a member");
        members[_member] = Member({
            id: memberCounter,
            name: _name,
            balance: _balance,
            membershipType: _membershipType
        });
        memberCounter++;
    }

    // Function to remove an existing member
    function removeMember(address _member) external onlyOwner {
        require(members[_member].id != 0, "Not a member");
        delete members[_member];
    }

    // Function to check if an address is a member
    function isMember(address _member) external view returns (bool) {
        return members[_member].id != 0;
    }

    // Function to modify a member's name
    function modifyMemberName(address _member, string memory _newName) external onlyOwner {
        require(members[_member].id != 0, "Not a member");
        members[_member].name = _newName;
    }

    // Function to modify a member's membership type
    function modifyMemberType(address _member, MembershipType _newType) external onlyOwner {
        require(members[_member].id != 0, "Not a member");
        members[_member].membershipType = _newType;
    }

    // Function to modify a member's balance
    function modifyMemberBalance(address _member, uint256 _newBalance) external onlyOwner {
        require(members[_member].id != 0, "Not a member");
        members[_member].balance = _newBalance;
    }
}
