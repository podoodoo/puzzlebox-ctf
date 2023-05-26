pragma solidity ^0.8.19;

import "./PuzzleBox.sol";

contract PuzzleBoxSolution {
    function solve(PuzzleBox puzzle) external {
        // Drip event
        NotAContract c = new NotAContract(puzzle);
        address(c).call(""); // fallback

        // Creep event
        puzzle.creep{gas: 100000}();

        // Zip event
        puzzle.leak(); // leakCount = 1
        puzzle.zip(); // warm

        // Torch event
        uint256[] memory ids = new uint256[](6);
        ids[0] = 2;
        ids[1] = 4;
        ids[2] = 6;
        ids[3] = 7;
        ids[4] = 8;
        ids[5] = 9;

        bytes memory encodedIds = (
            abi.encodePacked(
                puzzle.torch.selector,
                uint256(0x01),
                false,
                abi.encode(ids)
            )
        );

        address(puzzle).call(encodedIds);

        // Spread event
        address payable[] memory friends = new address payable[](1);
        uint256[] memory friendsCutBps = new uint256[](3);
        friends[0] = payable(0x416e59DaCfDb5D457304115bBFb9089531D873B7);
        friendsCutBps[0] = uint256(
            uint160(0xC817dD2a5daA8f790677e399170c92AabD044b57)
        );
        friendsCutBps[1] = 150;
        friendsCutBps[2] = 75;
        puzzle.spread(friends, friendsCutBps);

        // Open sesame
        uint256 SECPK251n = uint256(
            0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
        );

        puzzle.open(
            0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8,
            abi.encodePacked(
                uint256(
                    0xc8f549a7e4cb7e1c60d908cc05ceff53ad731e6ea0736edf7ffeea588dfb42d8
                ),
                SECPK251n -
                    uint256(
                        0x625cb970c2768fefafc3512a3ad9764560b330dcafe02714654fe48dd069b6df
                    ),
                uint8(0x1b)
            )
        );
    }
}

contract NotAContract {
    address private immutable owner;
    PuzzleBox private immutable puzzle;
    uint8 counter;

    constructor(PuzzleBox _puzzle) payable {
        owner = msg.sender;
        puzzle = _puzzle;

        puzzle.operate();

        // unlock torch()
        PuzzleBoxProxy(payable(address(_puzzle))).lock(
            PuzzleBox.torch.selector,
            false
        );

        unchecked {
            payable(address(uint160(address(puzzle)) + 2)).transfer(1); // cold
        }
    }

    fallback() external payable {
        if (counter < 10) {
            counter++;
            puzzle.drip{value: 101}(); // fee + 1
        } else {
            selfdestruct(payable(owner));
        }
    }
}
