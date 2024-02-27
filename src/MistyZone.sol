pragma solidity ^0.8.18;

import "seaport/contracts/interfaces/ZoneInterface.sol";

interface IPrivacyPool{

    function belongsToPrivacyPool(address _user) external returns (bool);
}

contract MistyZone {

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

    }
}

