ifneq (,$(wildcard .env))
    include .env
    export
endif

.PHONY: all test clean deploy fund help install snapshot format anvil call send storage logs balance debug trace create-wallet estimate-gas flatten inspect verify publish create-snapshot revert-snapshot gas-report build-info

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make call FUNCTION=\"getEntranceFee()\""
	@echo "  make send FUNCTION=\"enterRaffle()\" VALUE=10000000000000000"
	@echo "  make storage SLOT=0"
	@echo "  make logs"
	@echo "  make balance"

all: clean remove install update build

clean  :; forge clean

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit && forge install transmissions11/solmate@v6 --no-commit

update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --keystore $(KEYSTORE_PASSWORD) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv


     #Transaction (deploy, send to set data ) needs to be signed with the private key of the wallet.
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
storage:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast storage $(CONTRACT_ADDRESS) $(SLOT) --rpc-url $(SEPOLIA_RPC_URL)

logs:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast logs --from-block latest --address $(CONTRACT_ADDRESS) --rpc-url $(SEPOLIA_RPC_URL)

balance:
	@if [ -z "$(WALLET_ADDRESS)" ]; then echo "❌ ERROR: WALLET_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast balance $(WALLET_ADDRESS) --rpc-url $(SEPOLIA_RPC_URL)

debug:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@forge debug $(CONTRACT_ADDRESS) --rpc-url $(SEPOLIA_RPC_URL)

trace:
	@if [ -z "$(TX_HASH)" ]; then echo "❌ ERROR: TX_HASH is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast trace $(TX_HASH) --rpc-url $(SEPOLIA_RPC_URL)

create-wallet:
	@forge create-wallet

estimate-gas:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(FUNCTION)" ]; then echo "❌ ERROR: FUNCTION is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast estimate $(CONTRACT_ADDRESS) "$(FUNCTION)" --rpc-url $(SEPOLIA_RPC_URL)

flatten:
	@forge flatten

inspect:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@forge inspect $(CONTRACT_ADDRESS)

verify:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(ETHERSCAN_API_KEY)" ]; then echo "❌ ERROR: ETHERSCAN_API_KEY is not set!"; exit 1; fi
	@forge verify-contract $(CONTRACT_ADDRESS) --etherscan-api-key $(ETHERSCAN_API_KEY)

publish:
	@forge publish

create-snapshot:
	@forge snapshot create

revert-snapshot:
	@if [ -z "$(SNAPSHOT_ID)" ]; then echo "❌ ERROR: SNAPSHOT_ID is not set!"; exit 1; fi
	@forge snapshot revert $(SNAPSHOT_ID)

gas-report:
	@forge test --gas-report

build-info:
	@forge build-info
