module MyToken::Token {
    use std::signer;
    use std::vector;

    /// Структура балансу для користувача
    struct Balance has key {
        amount: u64,
    }

    /// Ініціалізація балансу з початковою кількістю токенів
    public entry fun init(account: &signer, supply: u64) {
        move_to(account, Balance { amount: supply });
    }

    /// Перевірити баланс користувача
    public fun balance_of(account: &signer): u64 acquires Balance {
        borrow_global<Balance>(signer::address_of(account)).amount
    }

    /// Передати токени іншому користувачу
    public entry fun transfer(sender: &signer, recipient: address, value: u64) acquires Balance {
        let sender_balance = borrow_global_mut<Balance>(signer::address_of(sender));
        assert!(sender_balance.amount >= value, 1);

        sender_balance.amount = sender_balance.amount - value;

        if (!exists<Balance>(recipient)) {
            move_to(&signer::new(recipient), Balance { amount: value });
        } else {
            let recipient_balance = borrow_global_mut<Balance>(recipient);
            recipient_balance.amount = recipient_balance.amount + value;
        }
    }
}
