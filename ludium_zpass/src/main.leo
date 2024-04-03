// The 'ludium_zpass' program.
program ludium_zpass.aleo {

    // #####################################
    // ###          TYPE DEFINITION        #
    // #####################################

    struct VerfiableCredential {
        issuer: address,
        holder: address,
        metadata_hash: field,
        sig: signature,
    }

    mapping vcs: field => VerfiableCredential;

    mapping is_verified: address => bool;

    record UnsignedVerfiableCredential {
        owner: /* issuer */ address,  
        holder: /* student */ address,
        attributes: /* student */ String64
    }

    struct String64 {
        part0: /* 수료 날짜 */ u128,
        part1: /* 수료 과목 */ u128,
    }

    // #####################################
    // ###          User                   #
    // #####################################

    // 루디움 주소는 aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z 라고 가정.
    transition request_new_vc(holder: address, attributes: String64) -> UnsignedVerfiableCredential {
        return UnsignedVerfiableCredential {
            owner: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z,
            holder: holder,
            attributes: attributes
        };

        // 그리고 이걸 UnsignedVerfiableCredential 이걸 루디움에 제출함.
    }

    // #####################################
    // ###          Issuer(Ludium)         #
    // #####################################

    // 루디움은 제출된 VC를 확인 후에 signing을 해줌
    transition sign_vc(sig: signature, unsigned_vc: UnsignedVerfiableCredential) -> VerfiableCredential {
        // 어차피 오너는 루디움임
        // assert_eq(self.caller, aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z);
        
        let metadata_hash: field = BHP256::hash_to_field(unsigned_vc.attributes);
        let vc: VerfiableCredential = VerfiableCredential{ 
            issuer: unsigned_vc.owner,
            holder: unsigned_vc.holder,
            metadata_hash: metadata_hash,
            sig: sig
        };

        return vc then finalize(vc);
    }

    finalize sign_vc(vc: VerfiableCredential) {
        Mapping::set(vcs, vc.metadata_hash, vc);
    }

    // #####################################
    // ###          VERIFIER               #
    // #####################################

    transition verify(decrypted_metadata: String64) {
        let metadata_hash: field = BHP256::hash_to_field(decrypted_metadata);        

        return then finalize(self.caller, metadata_hash);
    }

    finalize verify(addr: address, metadata_hash: field) {
        let vc: VerfiableCredential = Mapping::get(vcs, metadata_hash);

        let verified: bool = signature_verification(metadata_hash, vc.sig, vc.issuer);

        let current_verified: bool = Mapping::get_or_use(is_verified, addr, false);

        assert(!verified);

        // 이후에 사실 이걸 가지고 mapping 하면 퍼블릭하게 verify 한 걸 프로그램에 저장할 수도 있음
        Mapping::set(is_verified, addr, true);
    }

    inline signature_verification(msg_hash: field, sig: signature, issuer: address) -> bool {
        return signature::verify(sig, issuer, msg_hash);
    }
}
