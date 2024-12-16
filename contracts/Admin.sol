// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract AdminContract is Initializable {
    address public admin;


    function initialize() public initializer {
        admin = msg.sender;
    }

   /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

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
