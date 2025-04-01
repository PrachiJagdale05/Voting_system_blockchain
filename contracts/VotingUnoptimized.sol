// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingUnoptimized {
    struct Candidate {
        string name;
        uint256 voteCount;
        mapping(uint256 => bool) voterIds;  // Use mapping, less efficient
        uint256[] voterList;  // To store IDs for displaying
    }

    Candidate[] public candidates;

    constructor(string[] memory _candidateNames) {
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates.push();
            candidates[i].name = _candidateNames[i];
        }
    }

    function vote(uint256 candidateIndex, uint256 voterId) public {
        require(candidateIndex < candidates.length, "Invalid candidate index");

        Candidate storage candidate = candidates[candidateIndex];

        require(!candidate.voterIds[voterId], "Voter has already voted");

        candidate.voterIds[voterId] = true;
        candidate.voteCount += 1;
        candidate.voterList.push(voterId);  // Store voter ID for displaying
    }

    function getResults() public view returns (
        string memory winnerName, 
        uint256 winnerVotes, 
        string[] memory candidateNames, 
        uint256[] memory voteCounts, 
        uint256[][] memory allVoters
    ) {
        uint256 maxVotes = 0;

        candidateNames = new string[](candidates.length);
        voteCounts = new uint256[](candidates.length);
        allVoters = new uint256[][](candidates.length);

        for (uint256 i = 0; i < candidates.length; i++) {
            candidateNames[i] = candidates[i].name;
            voteCounts[i] = candidates[i].voteCount;
            allVoters[i] = candidates[i].voterList;

            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerName = candidates[i].name;
                winnerVotes = maxVotes;
            }
        }
    }
}
