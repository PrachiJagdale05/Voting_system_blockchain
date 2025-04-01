const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);

    const candidateNames = ["Alice", "Bob", "Charlie"].map(name =>
        hre.ethers.encodeBytes32String(name)
    );

    // Deploy Unoptimized contract
    const VotingUnoptimized = await hre.ethers.getContractFactory("VotingUnoptimized");
    const votingUnoptimized = await VotingUnoptimized.deploy(candidateNames);
    await votingUnoptimized.waitForDeployment();
    console.log("Unoptimized deployed at:", await votingUnoptimized.getAddress());

    // Deploy Optimized contract
    const VotingOptimized = await hre.ethers.getContractFactory("VotingOptimized");
    const votingOptimized = await VotingOptimized.deploy(candidateNames);
    await votingOptimized.waitForDeployment();
    console.log("Optimized deployed at:", await votingOptimized.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
