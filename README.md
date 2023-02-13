calldata for `f00000000_bvvvdlt()`: 0x00000000
calldata for `f00000001_grffjzz()`: 0x00000001

1. Load calldata
1. Logic for jumping to the right place based on function signature:
    - 0x00000000
    - 0x00000001
    - `fail()`: 0xa9cc4718
2. Logic for doing the right thing based on function signature:
    - 0x00000000: return 33 CALLER
    - 0x00000001: return 32 ORIGIN
    - `fail()`: 0xa9cc4718: return true(?)
        - what is the minimal thing to return in order to get a `success` code from a calling contract? Turns out literally anything that doesn't revert



3d // returndatasize, effectively pushes 0 onto stack
35 // load calldata, which puts the function signature on the top of the stack. Will either be 00000000...00, 000000010...00, or a9cc4718...00.

80 // duplicate val

// start condition for if 00
15 // isZero
60 11 // destination to jump to
57 // jumpi to destination

60 e0 // 224
1c // SHR by 224 bits to get the last byte of the function signature into the last byte of the first value on the stack

// start condition for if 01
60 01
14 // if equal
60 16 // destination to jump to
57 // jump to destination

// if both previous conditions are exhausted, stack will now be empty and can continue with other logic
// just needs to revert
fd // revert

// start logic for == 0
5b
33 // push msg.sender to top of stack
60 18 // destination to jump to
56 // jump to destination

// start logic for == 1
5b
32 // push tx.origin to top of stack

// at this point, should either have the correct address at the top of the stack
5b
60 00 // location in memory to store address
52 // mstore

60 20
3d // returndatasize, effectively pushes 0 onto stack
f3 

Contract bytecode: 3d35801560115760e01c600114601657fd5b336018565b325b60005260203df3 // 32 bytes
6020600c60003960206000f33d35801560115760e01c600114601657fd5b336018565b325b60005260203df3