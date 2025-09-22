
// Normal Arithmetic(without SafeMath)
pragma solidity ^0.7.6;

contract NormalMath {
    // Overflow example
    function testOverflow() external pure returns (uint8) {
        uint8 x = 255; // uint8 max value
        return x + 1;  // overflow -> wraps to 0
    }

    // Underflow example
    function testUnderflow() external pure returns (uint8) {
        uint8 y = 0;
        return y - 1;  // underflow -> wraps to 255
    }
}


//Step 2: SafeMath (Reverting Functions)
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract UsingSafeMath {
    using SafeMath for uint256;

    // Safe addition
    function safeAdd(uint256 a, uint256 b) external pure returns (uint256) {
        return a.add(b); 
 // revert if overflow isme zero store nhi hoga aur state change krke uski value zero store nhi hogi blki revert kr dega transaction
   
    }

    // Safe subtraction
    function safeSub(uint256 a, uint256 b) external pure returns (uint256) {
        return a.sub(b); // revert if underflow
    }
}


// Step 3: SafeMath (Non-Reverting tryAdd)
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract TrySafeMath {
    event Result(bool success, uint256 value);

    function safeTryAdd(uint256 a, uint256 b) external returns (bool, uint256) {
        (bool success, uint256 result) = SafeMath.tryAdd(a, b);

        // log output
        emit Result(success, result);

        return (success, result);
    }
}

