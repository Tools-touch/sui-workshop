
module suinftmint::suinftmint {
    use std::string::{Self, String};
    use sui::url::{Self, Url};
    use sui::event;
    // ###############################
    // struct event
    // ###############################
    public struct NFTEvent has copy, drop {
        object_id: ID,
        creator: address,
        name: String
    }


    // ###############################
    // struct 
    // ###############################
    public struct MyNFT has key, store {
        id: UID,
        url: Url,
        name: String,
        description: String
    }

    /// 从 CLI 可调用：把 url 当作 String 传进来，再在链上转成 Url
    public fun mint_nft(
        name: String, 
        url_str: String, 
        description: String, 
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        // 将字符串转为 Url（unsafe 版本够用；如果想严格校验可换 safe 版本）
        let url = url::new_unsafe_from_bytes(string::into_bytes(url_str));

        let nft = MyNFT {
            id: object::new(ctx),
            url,
            name,
            description
        };
        // 触发事件
        event::emit(NFTEvent {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });
        // 转给发起者
        transfer::public_transfer(nft, sender);
        
    }
}
