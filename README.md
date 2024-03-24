# Foundry Scratch Pad

This repo contains various code snippets, concepts and course exercises. It's purpose is to try them out and get a better understanding.

# Contents

### Gas usage for labels
Location `src/SolidityLabels.sol`.

Compares how labels affect gas usage.

### UniswapV3 Clone

Location `src/uniswapv3-clone`.

Simplified version of Uniswap V3, follows this [guide](https://uniswapv3book.com/milestone_1/introduction.html).

### Assembly & Formal Verification
Location `src/AssemblyFVCourse`; `lib/2-math-master-audit`.

Cyfrin Updraft course for learning Huff/Yul, EVM opcodes and formal verification.

# Tests

To run only a subset of the tests you can use the following commands:
- `forge test --mp test/uniswapv3-clone/*` run only tests in a folder
- `forge test --mc SolidityLabelsTest` run a specific test contract
- `forge test --mc HorseStore` runs HorseStore v1/v2 tests, check base contracts for more info. Yul/Huff course [section](https://updraft.cyfrin.io/courses/formal-verification/horse-store/huff-yul-opcode).
