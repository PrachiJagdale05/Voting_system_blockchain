const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Voting Contracts with Voter IDs", function () {
  let votingOptimized, votingUnoptimized;
  const candidates = ["Alice", "Bob", "Charlie", "David", "Eve"];
  const numVoters = 100;

  beforeEach(async function () {
    const VotingOptimized = await ethers.getContractFactory("VotingOptimized");
    votingOptimized = await VotingOptimized.deploy(candidates);
    await votingOptimized.deployed();

    const VotingUnoptimized = await ethers.getContractFactory("VotingUnoptimized");
    votingUnoptimized = await VotingUnoptimized.deploy(candidates);
    await votingUnoptimized.deployed();
  });

  it(`Should allow ${numVoters} voters and display results with voter IDs`, async function () {
    console.log("\n🔹 Optimized & Unoptimized Voting Results");

    let votes = [];
    for (let i = 1; i <= numVoters; i++) {
      votes.push(Math.floor(Math.random() * candidates.length));
    }

    for (let i = 1; i <= numVoters; i++) {
      await votingOptimized.vote(votes[i - 1], i);
      await votingUnoptimized.vote(votes[i - 1], i);
    }

    const optResults = await votingOptimized.getResults();
    const unoptResults = await votingUnoptimized.getResults();

    function printResults(title, results) {
      console.log("\n" + "─".repeat(50));
      console.log(`🏆 ${title} Winner: ${results[0]} with ${results[1]} votes`);
      console.log("─".repeat(50));
      for (let i = 0; i < results[2].length; i++) {
        console.log(`🔹 ${results[2][i].padEnd(10)}: ${results[3][i].toString().padStart(2)} votes`);
        console.log(`   Voters: ${results[4][i].map(id => `Voter ${id}`).join(', ') || "No voters"}`);
      }
      console.log("─".repeat(50) + "\n");
    }

    printResults("Optimized", optResults);
    printResults("Unoptimized", unoptResults);

    expect(optResults[0]).to.equal(unoptResults[0]);
    expect(optResults[1].eq(unoptResults[1])).to.be.true;
  });
});
