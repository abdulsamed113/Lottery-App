<<<<<<< HEAD
# -*- makefile -*-
# Makefile for Foundry Project - Professional Edition

# --------------------------
# Environment Configuration
# --------------------------
=======
fix:  
>>>>>>> 58fccf3 (Remove invalid submodules)
ifneq (,$(wildcard .env))
include .env
export
endif

<<<<<<< HEAD
# --------------------------
# Phony Targets Declaration
# --------------------------
.PHONY: help \
        init clean install update build \
        test test-fork coverage snapshot \
        anvil anvil-fork node \
        deploy verify \
        send call create2 multisig \
        storage logs events \
        balance nonce gas block \
        erc20 erc721 erc1155 \
        proof debug trace \
        calldata abi sig tx receipt \
        fork-cheatcodes gas-report

# --------------------------
# Project Constants
# --------------------------
DEFAULT_ANVIL_MNEMONIC = "test test test test test test test test test test test junk"
DEFAULT_FORK_URL = {SEPOLIA_RPC_URL}
CONTRACT ?= $(if $(CONTRACT_NAME),src/${CONTRACT_NAME}.sol:${CONTRACT_NAME},)
=======
.PHONY: all test clean deploy fund help install snapshot format anvil call send storage logs balance debug trace create-wallet estimate-gas flatten inspect verify publish create-snapshot revert-snapshot gas-report build-info fork fork-test coverage fuzz-test

help:
	@echo "Usage:"
	@echo " make deploy [ARGS=...]\n example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo " make call FUNCTION=\"getEntranceFee()\""
	@echo " make send FUNCTION=\"enterRaffle()\" VALUE=10000000000000000"
	@echo " make storage SLOT=0"
	@echo " make logs"
	@echo " make balance"
>>>>>>> 58fccf3 (Remove invalid submodules)

# --------------------------
# Main Targets
# --------------------------
help:  ## Display comprehensive help menu
	@printf "\033[1;36m%s\033[0m\n" "Foundry Project Management System"
	@printf "\033[1;34m%-25s\033[0m%s\n" "Target" "Description"
	@printf "───────────────────────────────────────────────\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[1;32m%-25s\033[0m%s\n", $$1, $$2}' $(MAKEFILE_LIST)

<<<<<<< HEAD
init: clean install update  ## Initialize project (clean, install, update)

# --------------------------
# Project Setup
# --------------------------
clean:  ## Clean build artifacts and dependencies
	@forge clean
	@rm -rf .gitmodules .git/modules/* lib

install:  ## Install project dependencies
	@forge install \
		cyfrin/foundry-devops@0.2.2 \
		smartcontractkit/chainlink-brownie-contracts@0.6.1 \
		foundry-rs/forge-std@v1.8.2 \
		transmissions11/solmate@v6 \
		--no-commit

update:  ## Update all dependencies
	@forge update

build:  ## Compile contracts
	@forge build --optimize --force

# --------------------------
# Testing & Verification
# --------------------------
test: check-network  ## Run basic tests
	@forge test -vvv --ffi

test-fork: check-network  ## Run tests on forked network
	@forge test -vvv --fork-url ${SEPOLIA_RPC_URL} --ffi

coverage:  ## Generate coverage report
	@forge coverage --report lcov

snapshot:  ## Create test snapshots
	@forge snapshot

gas-report:  ## Generate gas optimization report
	@forge test --gas-report

# --------------------------
# Local Development
# --------------------------
anvil:  ## Start local Anvil chain
	@anvil -m ${DEFAULT_ANVIL_MNEMONIC} \
		--steps-tracing \
		--block-time 1

anvil-fork: check-network  ## Fork mainnet to local Anvil
	@anvil --fork-url ${MAINNET_RPC_URL} \
		--fork-block-number ${BLOCK_NUMBER} \
		--block-time 1

node: anvil  ## Alias for starting local node

# --------------------------
# Deployment & Interaction
# --------------------------
deploy: check-network check-private-key  ## Deploy contract
	@forge script ${CONTRACT} \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--private-key ${KEYSTORE_PASSWORD} \
		--broadcast \
		--verify \
		--etherscan-api-key ${ETHERSCAN_API_KEY} \
		-vvvv

verify: check-network check-contract  ## Verify deployed contract
	@forge verify-contract ${CONTRACT_ADDRESS} ${CONTRACT} \
		--chain-id ${CHAIN_ID} \
		--etherscan-api-key ${ETHERSCAN_API_KEY}

# --------------------------
# Contract Interactions
# --------------------------
send: check-network check-private-key check-contract  ## Send transaction
	@cast send ${CONTRACT_ADDRESS} "${FUNCTION}" \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--private-key ${KEYSTORE_PASSWORD} \
		--value ${VALUE} \
		--legacy

call: check-network check-contract  ## Call view function
	@cast call ${CONTRACT_ADDRESS} "${FUNCTION}" \
		--rpc-url ${SEPOLIA_RPC_URL}

create2: check-network check-private-key  ## Deploy with CREATE2
	@forge create2 ${CONTRACT} \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--private-key ${KEYSTORE_PASSWORD} \
		--init-code-hash ${SALT}

multisig: check-network  ## Generate multisig transaction
	@cast mksig "${FUNCTION}" ${ARGS}

# --------------------------
# Chain Inspection
# --------------------------
storage: check-network check-contract  ## Inspect contract storage
	@cast storage ${CONTRACT_ADDRESS} ${SLOT} \
		--rpc-url ${SEPOLIA_RPC_URL}

logs: check-network check-contract  ## View contract logs
	@cast logs --from-block ${BLOCK} \
		--address ${CONTRACT_ADDRESS} \
		--rpc-url ${SEPOLIA_RPC_URL}

events: check-network check-contract  ## Decode contract events
	@cast events ${CONTRACT_ADDRESS} \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--from-block ${FROM_BLOCK} \
		--to-block ${TO_BLOCK}

# --------------------------
# Account Management
# --------------------------
balance: check-network check-address  ## Check ETH balance
	@cast balance ${WALLET_ADDRESS} --rpc-url ${SEPOLIA_RPC_URL}

nonce: check-network check-address  ## Check account nonce
	@cast nonce ${WALLET_ADDRESS} --rpc-url ${SEPOLIA_RPC_URL}

gas: check-network  ## Get current gas price
	@cast gas-price --rpc-url ${SEPOLIA_RPC_URL}

block: check-network  ## Get block information
	@cast block ${BLOCK_NUMBER} --rpc-url ${SEPOLIA_RPC_URL} --json

# --------------------------
# Advanced Cast Utilities
# --------------------------
calldata:  ## Generate calldata
	@cast calldata "${SIG}" ${ARGS}

abi: check-contract  ## Generate contract ABI
	@cast abi ${CONTRACT}

sig:  ## Get function selector
	@cast sig "${FUNCTION}"

tx: check-network  ## Get transaction details
	@cast tx ${TX_HASH} --rpc-url ${SEPOLIA_RPC_URL} --json

receipt: check-network  ## Get transaction receipt
	@cast receipt ${TX_HASH} --rpc-url ${SEPOLIA_RPC_URL} --json

# --------------------------
# Token Standards
# --------------------------
erc20: check-network check-address  ## ERC20 interactions
	@cast call ${TOKEN_ADDRESS} \
		"balanceOf(address)" ${WALLET_ADDRESS} \
		--rpc-url ${SEPOLIA_RPC_URL}

erc721: check-network check-address  ## ERC721 interactions
	@cast call ${NFT_ADDRESS} \
		"ownerOf(uint256)" ${TOKEN_ID} \
		--rpc-url ${SEPOLIA_RPC_URL}

erc1155: check-network check-address  ## ERC1155 interactions
	@cast call ${MULTI_TOKEN_ADDRESS} \
		"balanceOf(address,uint256)" ${WALLET_ADDRESS} ${TOKEN_ID} \
		--rpc-url ${SEPOLIA_RPC_URL}

# --------------------------
# Development Utilities
# --------------------------
proof: check-network check-contract  ## Generate storage proof
	@cast proof ${CONTRACT_ADDRESS} ${KEYSTORE_PASSWORD} \
		--rpc-url ${SEPOLIA_RPC_URL}

debug: check-network  ## Debug transaction
	@cast debug ${TX_HASH} --rpc-url ${SEPOLIA_RPC_URL}

trace: check-network  ## Trace transaction
	@cast trace ${TX_HASH} --rpc-url ${SEPOLIA_RPC_URL} \
		--steps \
		--verbose

fork-cheatcodes: check-network  ## Access mainnet state
	@forge script --fork-url ${SEPOLIA_RPC_URL} \
		--sig "run(address)" ${CHEAT_ADDRESS}

# --------------------------
# Validation Helpers
# --------------------------
check-network:
	@if [ -z "${SEPOLIA_RPC_URL}" ]; then \
		echo "Error: RPC_URL not set!"; \
		exit 1; \
	fi

check-private-key:
	@if [ -z "${KEYSTORE_PASSWORD}" ]; then \
		echo "Error: KEYSTORE_PASSWORD not set!"; \
		exit 1; \
	fi

check-contract:
	@if [ -z "${CONTRACT_ADDRESS}" ]; then \
		echo "Error: CONTRACT_ADDRESS not set!"; \
		exit 1; \
	fi

check-address:
	@if [ -z "${WALLET_ADDRESS}" ]; then \
		echo "Error: ADDRESS not set!"; \
		exit 1; \
	fi
# --------------------------
# Advanced Validation Helpers
# --------------------------
check-token-address:
	@if [ -z "${TOKEN_ADDRESS}" ]; then \
		echo "Error: TOKEN_ADDRESS not set!"; \
		exit 1; \
	fi

check-nft-address:
	@if [ -z "${NFT_ADDRESS}" ]; then \
		echo "Error: NFT_ADDRESS not set!"; \
		exit 1; \
	fi

check-tx-hash:
	@if [ -z "${TX_HASH}" ]; then \
		echo "Error: TX_HASH not set!"; \
		exit 1; \
	fi

check-function-sig:
	@if [ -z "${FUNCTION}" ]; then \
		echo "Error: FUNCTION signature not set!"; \
		exit 1; \
	fi

check-block-range:
	@if [ -z "${FROM_BLOCK}" ] || [ -z "${TO_BLOCK}" ]; then \
		echo "Error: FROM_BLOCK and TO_BLOCK must be set!"; \
		exit 1; \
	fi

# --------------------------
# Smart Contract Security
# --------------------------
slither:  ## Run static analysis with Slither
	@slither . --config-file slither.config.json

mythril:  ## Run symbolic execution with Mythril
	@myth analyze ${CONTRACT} \
		--rpc ${RPC_URL} \
		--max-depth 50

echidna:  ## Run fuzz testing with Echidna
	@echidna-test . \
		--contract ${CONTRACT} \
		--config echidna.config.yml

# --------------------------
# Multi-Chain Management
# --------------------------
deploy-mainnet:  ## Deploy to Ethereum Mainnet
	@make deploy RPC_URL=${MAINNET_RPC_URL} CHAIN_ID=1

deploy-sepolia:  ## Deploy to Sepolia Testnet
	@make deploy RPC_URL=${SEPOLIA_RPC_URL} CHAIN_ID=11155111

deploy-polygon:  ## Deploy to Polygon Mainnet
	@make deploy RPC_URL=${POLYGON_RPC_URL} CHAIN_ID=137


# --------------------------
# Wallet Management
# --------------------------
generate-wallet:  ## Generate new EOA wallet
	@cast wallet new > .wallet.sec && \
	cast wallet address < .wallet.sec

import-wallet:  ## Import wallet from private key
	@echo "${KEYSTORE_PASSWORD}" | cast wallet import

export-keystore:  ## Export wallet to keystore
	@cast wallet export --keystore ${KEYSTORE_PASSWORD} < .wallet.sec

# --------------------------
# Advanced Transactions
# --------------------------
speed-up-tx: check-network check-tx-hash  ## Speed up pending transaction
	@cast tx --replace ${TX_HASH} \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--private-key ${KEYSTORE_PASSWORD} \
		--gas-price ${GAS_PRICE}

batch-txs:  ## Send batch transactions
	@for tx in ${TX_LIST}; do \
		cast send $$tx \
			--rpc-url ${SEPOLIA_RPC_URL} \
			--private-key ${KEYSTORE_PASSWORD}; \
	done

# --------------------------
# Contract Analysis
# --------------------------
storage-layout: check-contract  ## Inspect contract storage layout
	@forge inspect ${CONTRACT_ADDRESS} storage-layout --pretty

gas-estimate: check-contract  ## Estimate contract deployment gas
	@forge inspect ${CONTRACT_ADDRESS} gas-estimates --pretty

bytecode: check-contract  ## Show contract bytecode
	@forge inspect ${CONTRACT_ADDRESS} bytecode

# --------------------------
# Governance & DAO
# --------------------------
create-proposal:  ## Create governance proposal
	@cast send ${GOVERNOR_ADDRESS} \
		"propose(address[],uint256[],bytes[],string)" \
		"${TARGETS}" "${VALUES}" "${CALLDATAS}" "${DESCRIPTION}" \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--private-key ${KEYSTORE_PASSWORD}

vote-proposal:  ## Vote on governance proposal
	@cast send ${GOVERNOR_ADDRESS} \
		"castVote(uint256,uint8)" \
		${PROPOSAL_ID} ${SUPPORT} \
		--rpc-url ${RPC_URL} \
		--private-key ${KEYSTORE_PASSWORD}

# --------------------------
# DevOps & Monitoring
# --------------------------
deploy-graph:  ## Deploy subgraph to The Graph
	@graph deploy ${SUBGRAPH_NAME} \
		--node ${GRAPH_NODE} \
		--ipfs ${IPFS_NODE} \
		--access-token ${GRAPH_TOKEN}

monitor-events:  ## Real-time event monitoring
	@cast watch --address ${CONTRACT_ADDRESS} \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--from-block latest

# --------------------------
# Utility Functions
# --------------------------
wei-to-eth:  ## Convert wei to ETH
	@cast --to-eth ${AMOUNT}

eth-to-wei:  ## Convert ETH to wei
	@cast --to-wei ${AMOUNT}

keccak:  ## Compute Keccak-256 hash
	@cast keccak "${DATA}"

disassemble: check-contract  ## Disassemble contract bytecode
	@cast disassemble ${CONTRACT_ADDRESS} \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--full
=======
clean:
	@forge clean

remove:
	@rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "Cleanup modules"

install:
	@forge install cyfrin/foundry-devops@0.2.2 --no-commit
	@forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit
	@forge install foundry-rs/forge-std@v1.8.2 --no-commit
	@forge install transmissions11/solmate@v6 --no-commit

update:
	@forge update

build:
	@forge build

# ================================
# Testing and Coverage
# ================================

test:
	@forge test

coverage:
	@forge coverage

fuzz-test:
	@forge test --fuzz-runs 265

# ================================
# Deployment and Interaction
# ================================

NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --keystore $(KEYSTORE_PASSWORD) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy:
	@forge script script/DeployRaffle.s.sol:DeployRaffle $(NETWORK_ARGS)

send:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(KEYSTORE_PASSWORD)" ]; then echo "❌ ERROR: KEYSTORE_PASSWORD is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast send $(CONTRACT_ADDRESS) "$(FUNCTION)" --keystore $(KEYSTORE_PASSWORD) --rpc-url $(SEPOLIA_RPC_URL) --value $(VALUE)

call:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast call $(CONTRACT_ADDRESS) "$(FUNCTION)" --rpc-url $(SEPOLIA_RPC_URL)

logs:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast logs --from-block latest --address $(CONTRACT_ADDRESS) --rpc-url $(SEPOLIA_RPC_URL)

balance:
	@if [ -z "$(WALLET_ADDRESS)" ]; then echo "❌ ERROR: WALLET_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast balance $(WALLET_ADDRESS) --rpc-url $(SEPOLIA_RPC_URL)

# ================================
# Debugging and Inspection
# ================================

debug:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@forge debug $(CONTRACT_ADDRESS) --rpc-url $(SEPOLIA_RPC_URL)

trace:
	@if [ -z "$(TX_HASH)" ]; then echo "❌ ERROR: TX_HASH is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast trace $(TX_HASH) --rpc-url $(SEPOLIA_RPC_URL)

inspect:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@forge inspect $(CONTRACT_ADDRESS)

# ================================
# Wallet and Gas Utilities
# ================================

create-wallet:
	@forge create-wallet

estimate-gas:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(FUNCTION)" ]; then echo "❌ ERROR: FUNCTION is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast estimate $(CONTRACT_ADDRESS) "$(FUNCTION)" --rpc-url $(SEPOLIA_RPC_URL)

# ================================
# Contract Flattening and Verification
# ================================

flatten:
	@forge flatten

verify:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(ETHERSCAN_API_KEY)" ]; then echo "❌ ERROR: ETHERSCAN_API_KEY is not set!"; exit 1; fi
	@forge verify-contract $(CONTRACT_ADDRESS) --etherscan-api-key $(ETHERSCAN_API_KEY)

publish:
	@forge publish

# ================================
# Snapshots
# ================================

create-snapshot:
	@forge snapshot create

revert-snapshot:
	@if [ -z "$(SNAPSHOT_ID)" ]; then echo "❌ ERROR: SNAPSHOT_ID is not set!"; exit 1; fi
	@forge snapshot revert $(SNAPSHOT_ID)

# ================================
# Gas Reporting and Build Info
# ================================

gas-report:
	@forge test --gas-report

build-info:
	@forge build-info

# ================================
# Forking Mainnet for Local Testing
# ================================

fork:
	@if [ -z "$(MAINNET_RPC_URL)" ]; then echo "❌ ERROR: MAINNET_RPC_URL is not set!"; exit 1; fi
	@anvil --fork-url $(MAINNET_RPC_URL) --block-time 1

fork-test:
	@if [ -z "$(MAINNET_RPC_URL)" ]; then echo "❌ ERROR: MAINNET_RPC_URL is not set!"; exit 1; fi
	@forge test --fork-url $(MAINNET_RPC_URL)

# ================================
# Formatting and Local Anvil Node
# ================================

format:
	@forge fmt

anvil:
	@anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1
>>>>>>> 58fccf3 (Remove invalid submodules)
