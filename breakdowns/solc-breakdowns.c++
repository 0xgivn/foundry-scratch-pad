// 0x6080604052348015600e575f80fd5b5060a58061001b5f395ff3fe6080604052348015600e575f80fd5b50600436106030575f3560e01c8063cdfead2e146034578063e026c017146045575b5f80fd5b6043603f3660046059565b5f55565b005b5f5460405190815260200160405180910390f35b5f602082840312156068575f80fd5b503591905056fea2646970667358221220bfe8151fd1a36b9b6a9236f002a0f7749999e86606f67b51e8eb40ea7e38641564736f6c63430008180033

// Copy bytecode in playground here: https://www.evm.codes/playground
// Switch to mnemonic mode and see all opcodes

// Full code breakdown here - https://github.com/Cyfrin/1-horse-store-s23/blob/main/breakdowns/solidity-breakdown.c%2B%2B

// 3 sections:
// Contract creation
// Runtime
// Metadata


// 1. Contract Creation Code
// Free memory pointer - sets at what offset the free memory starts
PUSH1 0x80 // [0x80]
PUSH1 0x40 // [0x40, 0x80]
MSTORE

// If someone sends ether to the contract, revert the transaction, otherwise continue to 0x0e
CALLVALUE  // [msg.value]
DUP1       // [msg.value, msg.value]
ISZERO     // [msg.value == zero, msg.value]
PUSH1 0x0e // [0x0e, msg.value == zero, msg.value]
JUMPI      // [msg.value] - jumps to 0x0e program counter if msg.value == 0
PUSH0      // [0x00, msg.value]
DUP1       // [0x00, 0x00, msg.value]
REVERT     // [msg.value]

// Jump dest if msg.value == 0; copies runtime code to memory
JUMPDEST   // [msg.value]
POP        // []
PUSH1 0xa5 // [0xa5]
DUP1         // [0xa5, 0xa5]
PUSH2 0x001b // [0x001b, 0xa5, 0xa5]
PUSH0        // [0x00, 0x001b, 0xa5, 0xa5]
CODECOPY     // [0xa5]     Memory: [runtime code]
PUSH0        // [0x00, 0xa5]     Memory: [runtime code]
RETURN       // []
INVALID      // []
// !!! - Contract is created without CREATE opcode - https://ethereum.stackexchange.com/questions/141154/why-do-i-not-see-create-or-create2-opcodes-in-traces-of-contract-creating-transa

// 2. Runtime code

// Entrypoint of all calls
PUSH1 0x80  // free memory pointer
PUSH1 0x40
MSTORE

CALLVALUE   // [msg.value]
DUP1        // [msg.value, msg.value]
ISZERO      // [msg.value == 0, msg.value]
PUSH1 0x0e  // [0x0e, msg.value == 0, msg.value]
JUMPI       // [msg.value] - jumps to 0x0e program counter if msg.value == 0
PUSH0       // [0x00, msg.value]
DUP1        // [0x00, 0x00, msg.value]
REVERT      // [msg.value]

// If msg.value == 0, continue to 0x0e, here
JUMPDEST
POP
PUSH1 0x04
CALLDATASIZE
LT
PUSH1 0x30
JUMPI
PUSH0
CALLDATALOAD
PUSH1 0xe0
SHR
DUP1
PUSH4 0xcdfead2e
EQ
PUSH1 0x34
JUMPI
DUP1
PUSH4 0xe026c017
EQ
PUSH1 0x45
JUMPI
JUMPDEST
PUSH0
DUP1
REVERT
JUMPDEST
PUSH1 0x43
PUSH1 0x3f
CALLDATASIZE
PUSH1 0x04
PUSH1 0x59
JUMP
JUMPDEST
PUSH0
SSTORE
JUMP
JUMPDEST
STOP
JUMPDEST
PUSH0
SLOAD
PUSH1 0x40
MLOAD
SWAP1
DUP2
MSTORE
PUSH1 0x20
ADD
PUSH1 0x40
MLOAD
DUP1
SWAP2
SUB
SWAP1
RETURN
JUMPDEST
PUSH0
PUSH1 0x20
DUP3
DUP5
SUB
SLT
ISZERO
PUSH1 0x68
JUMPI
PUSH0
DUP1
REVERT
JUMPDEST
POP
CALLDATALOAD
SWAP2
SWAP1
POP
JUMP


// 3. Metadata
INVALID
LOG2
PUSH5 0x6970667358
INVALID
SLT
KECCAK256
INVALID
INVALID
ISZERO
INVALID
INVALID
LOG3
PUSH12 0x9b6a9236f002a0f7749999e8
PUSH7 0x06f67b51e8eb40
INVALID
PUSH31 0x38641564736f6c63430008180033