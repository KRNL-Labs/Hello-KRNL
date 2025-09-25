// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import "../src/Sample.sol"; // RealEstateInvestment

contract DeployRealEstateInvestmentScript is Script {
    function run() external {
        // Get deployer key and address
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        // Load constructor parameters from env with sane defaults
        // If not provided, default auth/recovery/owner to deployer
        address authKey = vm.envOr("AUTH_KEY", deployer);
        address recoveryKey = vm.envOr("RECOVERY_KEY", deployer);
        address owner = vm.envOr("OWNER", deployer);

        // Address of the Delegated7702Account implementation (from previous deployment)
        address delegatedAccountImpl = vm.envAddress("DELEGATED_ACCOUNT_ADDRESS");

        // USDC token address on the target network
        address usdcToken = vm.envAddress("USDC_TOKEN_ADDRESS");

        // Property address string (e.g., "123 Main St, Springfield, USA")
        string memory propertyAddress = vm.envString("PROPERTY_ADDRESS");

        console.log("=== Deploying RealEstateInvestment ===");
        console.log("Deployer:", deployer);
        console.log("Auth Key:", authKey);
        console.log("Recovery Key:", recoveryKey);
        console.log("Owner:", owner);
        console.log("Delegated Account Impl:", delegatedAccountImpl);
        console.log("USDC Token:", usdcToken);
        console.log("Property Address:", propertyAddress);

        vm.startBroadcast(deployerPrivateKey);

        RealEstateInvestment rei = new RealEstateInvestment(
            authKey,
            recoveryKey,
            owner,
            delegatedAccountImpl,
            usdcToken,
            propertyAddress
        );

        vm.stopBroadcast();

        console.log("RealEstateInvestment deployed at:", address(rei));
        console.log("\n=== Deployment Summary ===");
        console.log("Deployer:", deployer);
        console.log("Owner:", owner);
        console.log("USDC:", usdcToken);
        console.log("Delegated Impl:", delegatedAccountImpl);
        console.log("Contract:", address(rei));
        console.log("====================================\n");

        // Suggest .env updates
        console.log("Add to .env:");
        console.log(string.concat("REAL_ESTATE_INVESTMENT_ADDRESS=", vm.toString(address(rei))));
    }
}
