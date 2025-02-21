ifneq (,$(wildcard .env))
    include .env
    export
endif

.PHONY: all test clean deploy fund help install snapshot format anvil call send storage logs balance

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

NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --keystore $(KEY_STORE) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy:
	@forge script script/DeployRaffle.s.sol:DeployRaffle $(NETWORK_ARGS)

call:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast call $(CONTRACT_ADDRESS) "$(FUNCTION)" --rpc-url $(SEPOLIA_RPC_URL)

send:
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then echo "❌ ERROR: CONTRACT_ADDRESS is not set!"; exit 1; fi
	@if [ -z "$(KEY_STORE)" ]; then echo "❌ ERROR: KEY_STORE is not set!"; exit 1; fi
	@if [ -z "$(KEY_STORE)" ]; then echo "❌ ERROR: KEYSTORE_PASSWORD is not set!"; exit 1; fi
	@if [ -z "$(SEPOLIA_RPC_URL)" ]; then echo "❌ ERROR: SEPOLIA_RPC_URL is not set!"; exit 1; fi
	@cast send $(CONTRACT_ADDRESS) "$(FUNCTION)" --keystore $(KEY_STORE) --password $(KEY_STORE) --rpc-url $(SEPOLIA_RPC_URL) --value $(VALUE)

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
