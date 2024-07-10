// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedVotingSystem {
    // Struct to define a candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    // State variables
    address public owner;
    uint256 private candidateCounter;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint256[] public candidateIds;

    // Events
    event CandidateAdded(uint256 id, string name);
    event VoteCast(address voter, uint256 candidateId);
    event WinnerDeclared(uint256 winnerId, string winnerName, uint256 winnerVoteCount);

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
        candidateCounter = 0;
    }

    // Function to add a new candidate
    function addCandidate(string memory _name) external onlyOwner {
        candidateCounter++;
        candidates[candidateCounter] = Candidate(candidateCounter, _name, 0);
        candidateIds.push(candidateCounter);
        emit CandidateAdded(candidateCounter, _name);
    }

    // Function to cast a vote
    function vote(uint256 _candidateId) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(candidates[_candidateId].id != 0, "Invalid candidate ID");
        
        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        
        emit VoteCast(msg.sender, _candidateId);
    }

    // Function to get the total number of votes for each candidate
    function getTotalVotes(uint256 _candidateId) external view returns (uint256) {
        require(candidates[_candidateId].id != 0, "Invalid candidate ID");
        return candidates[_candidateId].voteCount;
    }

    // Function to declare the winner
    function declareWinner() external onlyOwner returns (uint256 winnerId, string memory winnerName, uint256 winnerVoteCount) {
        uint256 highestVoteCount = 0;
        for (uint256 i = 0; i < candidateIds.length; i++) {
            if (candidates[candidateIds[i]].voteCount > highestVoteCount) {
                highestVoteCount = candidates[candidateIds[i]].voteCount;
                winnerId = candidateIds[i];
                winnerName = candidates[candidateIds[i]].name;
                winnerVoteCount = candidates[candidateIds[i]].voteCount;
            }
        }
        emit WinnerDeclared(winnerId, winnerName, winnerVoteCount);
    }
}
