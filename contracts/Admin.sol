// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract AdminContract {
    address public admin;

    constructor() {
        admin = msg.sender; // The contract deployer is the admin
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    function adminaddress () public view returns (address){
        return admin;
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "New admin cannot be the zero address");
        admin = newAdmin;
    }
}
