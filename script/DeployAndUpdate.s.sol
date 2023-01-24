// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/Implementation.sol";
import "../src/Proxy.sol";

contract Deploy is Script {
    UUPSProxy public proxy;

    Implementation public impl;
    ImplementationV2 public impl2;

    function run() public {
        // private key for deployment
        uint256 pk = vm.envUint("PRIVATE_KEY");
        console.log("Deploying contracts with address", vm.addr(pk));

        _deployInitialVersion();
        //_upradeImplementation();

        console.log("Contracts deployed");
    }

    // Deploy logic and proxy contract
    function _deployInitialVersion() internal {
        // deploy logic contract
        impl = new Implementation();
        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(impl), "");

        // initialize implementation contract
        address(proxy).call(abi.encodeWithSignature("initialize()"));
    }

    // Upgrade logic contract
    function _upradeImplementation() internal {
        // deploy new logic contract
        impl2 = new ImplementationV2();
        // update proxy to new implementation contract
        (, bytes memory data) = address(proxy).call(abi.encodeWithSignature("upgradeTo(address)", address(impl2)));
    }
}
