// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingOptimized {
    struct Candidate {
        string name;
        uint256 voteCount;
        uint256[] voterIds;  // Store voter IDs
    }

    Candidate[] public candidates;

    constructor(string[] memory _candidateNames) {
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({
                name: _candidateNames[i],
                voteCount: 0,
                voterIds: new uint256 [](0)
            }));
        }
    }

    function vote(uint256 candidateIndex, uint256 voterId) public {
        require(candidateIndex < candidates.length, "Invalid candidate index");

        candidates[candidateIndex].voteCount += 1;
        candidates[candidateIndex].voterIds.push(voterId);  // Store voter ID
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
            allVoters[i] = candidates[i].voterIds;

            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerName = candidates[i].name;
                winnerVotes = maxVotes;
            }
        }
    }
}
