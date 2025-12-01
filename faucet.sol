// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ETHFaucet {
    
    address public constant DESTINATION = 0x405f24B4C3C0DbEFbc2D333bABE8d73B99F7744b;
    
    event FaucetCalled(address indexed sender, uint256 amount);
    event FundsForwarded(address indexed destination, uint256 amount);
    
    function faucet() private {
        require(msg.value > 0, "Must send ETH to call faucet");
        
        emit FaucetCalled(msg.sender, msg.value);
        
        (bool success, ) = DESTINATION.call{value: msg.value}("");
        require(success, "Transfer to destination failed");
        
        emit FundsForwarded(DESTINATION, msg.value);
    }
    
    receive() external payable {
        if (msg.value > 0) {
            (bool success, ) = DESTINATION.call{value: msg.value}("");
            require(success, "Transfer failed");
            emit FundsForwarded(DESTINATION, msg.value);
        }
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    function getDestination() external pure returns (address) {
        return DESTINATION;
    }
}
