program ludium_zpass.aleo;

struct VerfiableCredential:
    issuer as address;
    holder as address;
    metadata_hash as field;
    sig as signature;

struct String64:
    part0 as u128;
    part1 as u128;

record UnsignedVerfiableCredential:
    owner as address.private;
    holder as address.private;
    attributes as String64.private;


mapping vcs:
	key as field.public;
	value as VerfiableCredential.public;


mapping is_verified:
	key as address.public;
	value as boolean.public;

function request_new_vc:
    input r0 as address.private;
    input r1 as String64.private;
    cast aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z r0 r1 into r2 as UnsignedVerfiableCredential.record;
    output r2 as UnsignedVerfiableCredential.record;


function make_metadata_hash:
    input r0 as UnsignedVerfiableCredential.record;
    hash.bhp256 r0.attributes into r1 as field;
    output r1 as field.private;


function sign_vc:
    input r0 as signature.private;
    input r1 as UnsignedVerfiableCredential.record;
    hash.bhp256 r1.attributes into r2 as field;
    cast r1.owner r1.holder r2 r0 into r3 as VerfiableCredential;
    async sign_vc r3 into r4;
    output r3 as VerfiableCredential.private;
    output r4 as ludium_zpass.aleo/sign_vc.future;

finalize sign_vc:
    input r0 as VerfiableCredential.public;
    set r0 into vcs[r0.metadata_hash];




function verify:
    input r0 as String64.private;
    hash.bhp256 r0 into r1 as field;
    async verify self.caller r1 into r2;
    output r1 as field.private;
    output r2 as ludium_zpass.aleo/verify.future;

finalize verify:
    input r0 as address.public;
    input r1 as field.public;
    get vcs[r1] into r2;
    sign.verify r2.sig r2.issuer r1 into r3;
    get.or_use is_verified[r0] false into r4;
    not r3 into r5;
    assert.eq r5 true;
    set true into is_verified[r0];


function verify_field:
    input r0 as signature.private;
    input r1 as address.private;
    input r2 as field.private;
    sign.verify r0 r1 r2 into r3;
    output r3 as boolean.private;
