/*
/// Module: twy_coin
module twy_coin::twy_coin {
    mint:
    sui client call --package <PACKAGE_ID> --module supra --function mint --args <TREASURYCAP_ID> 1000000 <RECIPIENT_ADDRESS> --gas-budget 300000000
    testnet: sui client call --package 0x97f121396831b86bb981834581d161d673cf801489625331e050aba074a5754d --module djytwy --function mint --args 0xd927d0b068597e3b53cc7ea254e2419e2ed2016bdf90f919759c38e206906a11 3000000000 0x9aa11c53051e4d66e7acd6f59c54dd760ca33cee636f4f6f0f6949501ad0e3cc --gas-budget 300000000
    switch address:
    sui client switch --address 0xe015d825eb4af16ec3606d6239e061de2b74aca873c8303cb84780a16145c0c8
}
*/

module twy_coin::djytwy {
    use std::option;
    use sui::coin;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    // Name matches the module name, but in UPPERCASE
    public struct DJYTWY has drop {}

    // Module initializer is called once on module publish.
    // A treasury cap is sent to the publisher, who then controls minting and burning.
    fun init(witness: DJYTWY, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(witness, 9, b"TWY", b"DJYTWY", b"", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, tx_context::sender(ctx))
    }

    // Manager can mint new DJYTWY tokens
    public entry fun mint(
        treasury: &mut coin::TreasuryCap<DJYTWY>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx)
    }

    // Manager can burn DJYTWY tokens
    public entry fun burn(treasury: &mut coin::TreasuryCap<DJYTWY>, coin: coin::Coin<DJYTWY>) {
        coin::burn(treasury, coin);
    }
}