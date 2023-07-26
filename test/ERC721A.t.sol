// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import 'src/ERC721A.sol';
import {DSTest} from 'ds-test/test.sol';

contract ERC721ATest is ERC721A, DSTest {

    constructor() ERC721A("erc721", "721") { }

    // inv1: the balance of the owner of an existing token is non-zero.
    function inv1(uint tokenId) public view returns (bool) {
        return !_exists(tokenId) || balanceOf(ownerOf(tokenId)) > 0;
    }

    // inv2: the ownership slot of unminted tokens is uninitialized.
    function inv2(uint tokenId) public view returns (bool) {
        return !(_packedOwnerships[tokenId] != 0) || tokenId < _nextTokenId();
    }

    // inv3: if the ownership slot is uninitialized, their parent token's _BITMASK_NEXT_INITIALIZED is unset.
    function inv3(uint tokenId) public view returns (bool) {
        return !(_packedOwnerships[tokenId] == 0) || _packedOwnershipOf(tokenId) & _BITMASK_NEXT_INITIALIZED == 0;
    }

    // inv4: if _BITMASK_NEXT_INITIALIZED is set, the ownership slot of the next token (if any) is initialized.
    function inv4(uint tokenId) public view returns (bool) {
        return !(_packedOwnershipOf(tokenId) & _BITMASK_NEXT_INITIALIZED != 0)
            || !(tokenId + 1 < _nextTokenId())
            || _packedOwnerships[tokenId + 1] != 0;
    }

    function proveInvariant1(uint tokenId, address addr1, address addr2, uint num, uint rand) public { _proveInvariant(inv1(tokenId), addr1, addr2, num, rand); }
    function proveInvariant2(uint tokenId, address addr1, address addr2, uint num, uint rand) public { _proveInvariant(inv2(tokenId), addr1, addr2, num, rand); }
    function proveInvariant3(uint tokenId, address addr1, address addr2, uint num, uint rand) public { _proveInvariant(inv3(tokenId), addr1, addr2, num, rand); }
    function proveInvariant4(uint tokenId, address addr1, address addr2, uint num, uint rand) public { _proveInvariant(inv4(tokenId), addr1, addr2, num, rand); }

    function _proveInvariant(
        bool inv,
        address addr1, address addr2, uint num,
        uint rand
    ) internal {
        require(inv);

        if (rand == 0) {
            _mint(addr1, num);
        } else if (rand == 1) {
            _burn(num);
        } else {
            transferFrom(addr1, addr2, num);
        }

        assert(inv);
    }
}
