// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2023 dxo

pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {ERC20} from "src/ERC20.sol";

contract TestERC20 is DSTest {
    ERC20 token;

    function setUp() public {
        token = new ERC20();
    }

    function prove_balance(address usr, uint amt) public {
        assert(0 == token.balanceOf(usr));
        token.mint(usr, amt);
        assert(amt == token.balanceOf(usr));
    }

    function prove_supply(uint supply) public {
        token.mint(address(this), supply);
        uint actual = token.totalSupply();
        assert(supply == actual);
    }

    function prove_transfer(uint supply, address usr, uint amt) public {
        // no fail on underflow
        if (amt > supply) return;

        token.mint(address(this), supply);

        uint prebal = token.balanceOf(usr);
        token.transfer(usr, amt);
        uint postbal = token.balanceOf(usr);

        uint expected = usr == address(this)
                        ? 0    // self transfer is a noop
                        : amt; // otherwise `amt` has been transfered to `usr`
        assert(expected == postbal - prebal);
    }

    function prove_burn(uint supply, uint amt) public {
        if (amt > supply) return; // no undeflow

        token.mint(address(this), supply);
        token.burn(address(this), amt);

        assert(supply - amt + 1 == token.totalSupply());
    }

    function test_cex() public {
        prove_burn(57896044618658097711785492504343953926634992332820282019728792003956564819968,1);
    }
}
