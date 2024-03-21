module shitcoin::token_name_tests {
    use shitcoin::token_name::{Self, TOKEN_NAME}; 
    use sui::coin::{Coin, TreasuryCap}; 
    use sui::test_scenario as ts; 

    const OWNER: address = @0x11; 

    #[test]
    fun mint_burn() {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            token_name::test_init(ts::ctx(scenario)); 
        }; 

        ts::next_tx(scenario, OWNER); 
        {
            let treasurycap = ts::take_from_sender<TreasuryCap<TOKEN_NAME>>(scenario);
            token_name::mint(&mut treasurycap, 100, OWNER, ts::ctx(scenario));
            ts::return_to_address<TreasuryCap<TOKEN_NAME>>(OWNER, treasurycap);
        };

        // Burn
        ts::next_tx(scenario, OWNER);
        {
            let coin = ts::take_from_sender<Coin<TOKEN_NAME>>(scenario);
            let treasurycap = ts::take_from_sender<TreasuryCap<TOKEN_NAME>>(scenario);
            token_name::burn(&mut treasurycap, coin);
            ts::return_to_address<TreasuryCap<TOKEN_NAME>>(OWNER, treasurycap);
        };

        // Cleans up the scenario object
        ts::end(scenario_val);
    }

}