build:
	forge build
erc20-safe:
	hevm symbolic --code $$(cat out/ERC20.sol/ERC20.json | jq .deployedBytecode.object -r) --solver cvc5
erc20-broken:
	hevm symbolic --code $$(cat out/ERC20.sol/BrokenERC20.json | jq .deployedBytecode.object -r) --solver cvc5
erc20-soltest:
	hevm test --match "ERC20" --verbose 2
erc721-soltest:
	hevm test --match "ERC721A" --verbose 2 --max-iterations 32
