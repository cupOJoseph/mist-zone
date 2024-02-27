pragma solidity ^0.8.18;

import "seaport/contracts/interfaces/ZoneInterface.sol";
import { ERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

interface IPrivacyPool{

    function belongsToPrivacyPool(address _user) external returns (bool);
}

contract MistyZone is ERC165, ZoneInterface{

    IPrivacyPool public privacyPool;

    constructor(address _privacyPoolAddress){
        privacyPool = IPrivacyPool(_privacyPoolAddress);
    }

    function validateOrder(
        ZoneParameters calldata zoneParameters
    ) external returns (bytes4 validOrderMagicValue){
        //    address fulfiller;
        //    address offerer;
        require(privacyPool.belongsToPrivacyPool(zoneParameters.fulfiller));
        require(privacyPool.belongsToPrivacyPool(zoneParameters.offerer));

        // Return the selector of isValidOrder as the magic value.
        validOrderMagicValue = ZoneInterface.validateOrder.selector; 
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC165, ZoneInterface) returns (bool) {
        return
            interfaceId == type(ZoneInterface).interfaceId ||
            super.supportsInterface(interfaceId);
    }

        /**
     * @dev Returns the metadata for this zone.
     */
    function getSeaportMetadata()
        external
        pure
        override
        returns (
            string memory name,
            Schema[] memory schemas // map to Seaport Improvement Proposal IDs
        )
    {
        schemas = new Schema[](1);
        schemas[0].id = 3003;
        schemas[0].metadata = new bytes(0);

        return ("MistyZone", schemas);
    }
}

