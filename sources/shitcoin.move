module shitcoin::token_name {
    use std::option; 
    use sui::coin::{Self, Coin, TreasuryCap}; 
    use sui::transfer; 
    use sui::url::new_unsafe_from_bytes;
    use sui::tx_context::{Self, TxContext}; 

    struct TOKEN_NAME has drop {}

    fun init(otw: TOKEN_NAME, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<TOKEN_NAME>(
            otw, 
            6, // Token decimals 
            b"SHIT", // Token symbol
            b"Shitcoin", // Token Name
            b"The shittiest coin of them all", // Token Description 
            option::some(new_unsafe_from_bytes(b"image.com/image")), // Token Icon URL
            ctx
        ); 

        transfer::public_freeze_object(metadata); 
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    // ===== Allow Contract Manager to Mint New Tokens =====
    public fun mint(
        treasury_cap: &mut TreasuryCap<TOKEN_NAME>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    // ===== Allow Contract Manager to Burn New Tokens =====
    public fun burn(treasury_cap: &mut TreasuryCap<TOKEN_NAME>, coin: Coin<TOKEN_NAME>) {
        coin::burn(treasury_cap, coin); 
    }

    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(TOKEN_NAME {}, ctx)
    }
}