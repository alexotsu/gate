pragma solidity ^0.8.17;

interface IGuardian {
    function f00000000_bvvvdlt() external view returns (address);

    function f00000001_grffjzz() external view returns (address);
}

contract DummyGuardian is IGuardian {
    // address: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
    function f00000000_bvvvdlt() external view returns (address) {
        return msg.sender;
    }

    function f00000001_grffjzz() external view returns (address) {
        return tx.origin;
    }
}

contract Gate {
    bool public opened;

    function open(address guardian) external {
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(guardian)
        }
        require(codeSize < 33, "bad code size");

        require(
            IGuardian(guardian).f00000000_bvvvdlt() == address(this),
            "invalid pass"
        );
        require(
            IGuardian(guardian).f00000001_grffjzz() == tx.origin,
            "invalid pass"
        );

        (bool success, ) = guardian.call(abi.encodeWithSignature("fail()"));
        require(!success);

        opened = true;
    }
}