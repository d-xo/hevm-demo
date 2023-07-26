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
act-equiv:
	act hevm --spec act/transfer.act --sol act/transfer.sol --contract Token
act-equiv-bad:
	act hevm --spec act/transfer.act --sol act/transfer-bad.sol --contract Token
hevm-equiv:
	solc act/transfer-bad.sol --bin-runtime -o out/solc/transfer-bad.out --overwrite
	solc act/transfer.sol --bin-runtime -o out/solc/transfer.out --overwrite
	hevm equivalence --code-a $$(cat out/solc/transfer.out/Token.bin-runtime) --code-b $$(cat out/solc/transfer-bad.out/Token.bin-runtime)
