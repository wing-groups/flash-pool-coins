module flashpoolcoins::coin {
    use std::signer;
    use std::string::utf8;

    use aptos_framework::coin::{Self, MintCapability, BurnCapability};

    /// Represents test USDC coin.
    struct USDC {}

    /// Represents test USDT coin.
    struct USDT {}

    /// Represents test ETH coin.
    struct ETH {}

    /// Represents test BTC coin.
    struct BTC {}

    /// Represents DAI coin.
    struct DAI {}

    struct WING {}

    /// Storing mint/burn capabilities for `USDC` and `ETH` coins under user account.
    struct Caps<phantom CoinType> has key {
        mint: MintCapability<CoinType>,
        burn: BurnCapability<CoinType>,
    }

    /// Initializes `ETH`, `USDC`, ,USDT , BTC , and `DAI` coins.
    public entry fun register_coins(token_admin: &signer) {
        let (eth_b, eth_f, eth_m) =
            coin::initialize<ETH>(token_admin,
                utf8(b"ETH"), utf8(b"ETH"), 8, true);
        let (btc_b, btc_f, btc_m) =
            coin::initialize<BTC>(token_admin,
                utf8(b"BTC"), utf8(b"BTC"), 8, true);
        let (usdc_b, usdc_f, usdc_m) =
            coin::initialize<USDC>(token_admin,
                utf8(b"USDC"), utf8(b"USDC"), 6, true);
        let (usdt_b, usdt_f, usdt_m) =
            coin::initialize<USDT>(token_admin,
                utf8(b"USDT"), utf8(b"USDT"), 6, true);
        let (dai_b, dai_f, dai_m) =
            coin::initialize<DAI>(token_admin,
                utf8(b"DAI"), utf8(b"DAI"), 6, true);

        let (wing_b, wing_f, wing_m) =
            coin::initialize<WING>(token_admin,
                utf8(b"WING"), utf8(b"WING"), 9, true);

        coin::destroy_freeze_cap(eth_f);
        coin::destroy_freeze_cap(usdc_f);
        coin::destroy_freeze_cap(dai_f);
        coin::destroy_freeze_cap(wing_f);
        coin::destroy_freeze_cap(btc_f);
        coin::destroy_freeze_cap(usdt_f);

        move_to(token_admin, Caps<ETH> { mint: eth_m, burn: eth_b });
        move_to(token_admin, Caps<USDC> { mint: usdc_m, burn: usdc_b });
        move_to(token_admin, Caps<DAI> { mint: dai_m, burn: dai_b });
        move_to(token_admin, Caps<WING> { mint: wing_m, burn: wing_b });
        move_to(token_admin, Caps<BTC> { mint: btc_m, burn: btc_b });
        move_to(token_admin, Caps<USDT> { mint: usdt_m, burn: usdt_b });
    }

    /// Mints new coin `CoinType` on account `acc_addr`.
    public entry fun mint_coin<CoinType>(token_admin: &signer, acc_addr: address, amount: u64) acquires Caps {
        let token_admin_addr = signer::address_of(token_admin);
        let caps = borrow_global<Caps<CoinType>>(token_admin_addr);
        let coins = coin::mint<CoinType>(amount, &caps.mint);
        coin::deposit(acc_addr, coins);
    }

    /// Mints new coin `CoinType` on account `acc_addr`.
    public entry fun register<CoinType>(account: &signer) {
        if (!coin::is_account_registered<CoinType>(signer::address_of(account))) {
            coin::register<CoinType>(account);
        };
    }
}