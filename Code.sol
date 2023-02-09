// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import { ISuperfluid, ISuperToken } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {IConstantFlowAgreementV1} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";
import {CFAv1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/CFAv1Library.sol";
import {
    SuperTokenV1Library
} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

contract SuperFluidStream{
    using SuperTokenV1Library for ISuperToken;
    ISuperToken public token;
    using CFAv1Library for CFAv1Library.InitData;
    CFAv1Library.InitData public cfaV1;               
    address owner;
    constructor(ISuperfluid host , ISuperToken _token){
        
        cfaV1 = CFAv1Library.InitData(
    host,
  
    IConstantFlowAgreementV1(
        address(host.getAgreementClass(
                keccak256("org.superfluid-finance.agreements.ConstantFlowAgreement.v1")
            ))
    )
);
owner = msg.sender;
token = _token;
    }


//0x13a9211986B491F398A14ca23a2FDefF3EE64244
//0x287c8fd88EBFD8DD6E6476E83CBC10F8302D57F9
    function sendTokenToContract(uint amount ) external{
        token.transferFrom(msg.sender ,address(this) , amount);
    }

    function createFlowToAddress(address reciever ,  int96 flowRate) external {
        cfaV1.createFlow(reciever , token , flowRate);
    }

    function updateFlowFromContract(address reciver ,  int96 flowRate) external {
        cfaV1.updateFlow(reciver , token , flowRate);
    }

    function deleteFlowFromContract(address reciever ) external{
        cfaV1.deleteFlow(address(this) , reciever , token);
    }

    function createFlowIntoContract( int96 flowRate) external{
        cfaV1.createFlowByOperator(msg.sender , address(this) , token , flowRate);
    }

    function updateFlowIntoContract(int96 flowRate) external {
         cfaV1.updateFlowByOperator(msg.sender , address(this) , token , flowRate);
    }

    function deleteFlowIntoContract( ) external{
        cfaV1.deleteFlow(msg.sender , address(this)  , token);
    }

    function withdrawFunds( uint amount ) external {
        token.transfer(msg.sender ,amount );
    }
     
     function givePermission() public {
         token.setFlowPermissions( address(this) , true ,true , true ,10000 );
     }



}
// host  : 0x22ff293e14F1EC3A09B137e9e06084AFd63adDF9
//token : 0x8aE68021f6170E5a766bE613cEA0d75236ECCa9a
