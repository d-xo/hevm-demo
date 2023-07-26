build:
	forge build
erc20:
	hevm symbolic --code $$(cat out/ERC20.sol/ERC20.json | jq .deployedBytecode.object -r) --solver cvc5
