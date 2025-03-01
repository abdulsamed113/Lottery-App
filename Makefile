# -*- makefile -*-
# Makefile for Foundry Project - Professional Edition

# --------------------------
# Environment Configuration
# --------------------------
ifneq (,$(wildcard .env))
    include .env
    export
endif

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
# Main Targets
# --------------------------
help:  ## Display comprehensive help menu
	@printf "\033[1;36m%s\033[0m\n" "Foundry Project Management System"
	@printf "\033[1;34m%-25s\033[0m%s\n" "Target" "Description"
	@printf "───────────────────────────────────────────────\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[1;32m%-25s\033[0m%s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: clean install update  ## Initialize project (clean, install, update)
	@rm -rf .gitmodules .git/modules/* lib node_modules

# --------------------------
# Project Setup
# --------------------------
clean:  ## Clean build artifacts and dependencies
	@forge clean

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
	@forge test -vvv --fork-url ${MAINNET_RPC_URL} --ffi

coverage:  ## Generate coverage report
	@forge coverage --report lcov

snapshot:  ## Create test snapshots
	@forge snapshot

gas-report:  ## Generate gas optimization report
	@forge test --gas-report
 
# --------------------------
# Fork & Local Node
# --------------------------
anvil:  ## Start Anvil node
	@anvil --mnemonic "test test test test test test test test test test test junk"

anvil-fork:  ## Start Anvil node with fork
	@anvil --mnemonic "test test test test test test test test test test test junk" --fork-url ${MAINNET_RPC_URL}
    
node:  ## Start local node
	@anvil

deploy-fork:  ## Start Anvil Fork and Deploy Contract
	@anvil --mnemonic "test test test test test test test test test test test junk" --fork-url ${MAINNET_RPC_URL} & \
	sleep 60; \
	forge script ${CONTRACT_NAME} \
		--rpc-url http://127.0.0.1:8545 \
		--broadcast \
		-vvvv

# --------------------------
# Deployment & Interaction
# --------------------------
deploy: ##deploy to testnet live network
	@forge script ${CONTRACT_NAME} \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--keystore ${KEYSTORE_PASSWORD} \
		--broadcast \
		--verify \
		--etherscan-api-key ${ETHERSCAN_API_KEY} \
		-vvvv

verify: check-network check-contract  ## Verify deployed contract
	@forge verify-contract ${CONTRACT_ADDRESS} ${CONTRACT_NAME} \
		--chain-id 11155111 \
		--etherscan-api-key ${ETHERSCAN_API_KEY}

# --------------------------
# Contract Interactions
# --------------------------
send: check-network check-keystore check-contract  ## Send transaction
	@cast send ${CONTRACT_ADDRESS} "${FUNCTION}" \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--keystore ${KEYSTORE_PASSWORD} \
		--value ${VALUE} \
		--legacy

call: check-network check-contract  ## Call view function
	@cast call ${CONTRACT_ADDRESS} "${FUNCTION}" \
		--rpc-url ${SEPOLIA_RPC_URL}

create2: check-network check-keystore  ## Deploy with CREATE2
	@forge create2 ${CONTRACT_NAME} \
		--rpc-url ${SEPOLIA_RPC_URL} \
		--keystore ${KEYSTORE_PASSWORD} \
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
	@cast abi ${CONTRACT_NAME}

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
	@cast proof ${CONTRACT_ADDRESS} ${STORAGE_KEY} \
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
		echo "Error: SEPOLIA_RPC_URL not set!"; \
		exit 1; \
	fi

check-keystore:
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
		echo "Error: WALLET_ADDRESS not set!"; \
		exit 1; \
	fi 