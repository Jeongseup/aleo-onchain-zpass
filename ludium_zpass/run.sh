#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi


# The private key and address of Alice -> Student
# Swap these into program.json, when running transactions as the first bidder.
# "private_key": "APrivateKey1zkp1w8PTxrRgGfAtfKUSq43iQyVbdQHfhGbiNPEg2LVSEXR",
# "address": "aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q"

# The private key and address of Bob -> Ludium
# Swap these into program.json, when running transactions as the second bidder.
# "private_key": "APrivateKey1zkpFo72g7N9iFt3JzzeG8CqsS5doAiXyFvNCgk2oHvjRCzF"
# "address": "aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z"

# Swap in the private key of Student.
# Study will request a new vc to issuer(ludium)
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp1w8PTxrRgGfAtfKUSq43iQyVbdQHfhGbiNPEg2LVSEXR
" > .env

# set -ux

META_DATA="{
    part0: 140152554740597502496524452237299901250u128,
    part1: 133324194421918155921132289162654938981u128
}"

leo run "request_new_vc" aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q "${META_DATA}"

# Swap in the private key of Ludium.
# Ludium will sign the vc which requested by student after checking request vc is correct
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpFo72g7N9iFt3JzzeG8CqsS5doAiXyFvNCgk2oHvjRCzF
" > .env


UNSIGNED_VC="{
  owner: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z.private,
  holder: aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q.private,
  attributes: {
    part0: 140152554740597502496524452237299901250u128.private,
    part1: 133324194421918155921132289162654938981u128.private
  },
  _nonce: 354998397500206389428199971616865075607554237379969307856108876210982075101group.public
}"

leo run "make_metadata_hash" "${UNSIGNED_VC}"
# >> 7008524940045791203999848867183584738587782508703254509438457557080158883755field -> signing?

# signature is sign a message with metadata_hash 
SIGNATURE="sign1uh76859j57w8sxsje8njerewcudp3qw8plp3us9d2td28x2rqyq4pyelcv3fv09s8w9f0d35um9szk8wcmat496nkwjqxj663r3zjqp4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6sjj3wz"

# transition sign_vc(sig: signature, unsigned_vc: UnsignedVerfiableCredential) -> VerfiableCredential {
leo run "sign_vc" "${SIGNATURE}" "${UNSIGNED_VC}"

# Outputs
# • {
#   issuer: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z,
#   holder: aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q,
#   metadata_hash: 7008524940045791203999848867183584738587782508703254509438457557080158883755field,
#   sig: sign1uh76859j57w8sxsje8njerewcudp3qw8plp3us9d2td28x2rqyq4pyelcv3fv09s8w9f0d35um9szk8wcmat496nkwjqxj663r3zjqp4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6sjj3wz
# }
#  • {
#   program_id: ludium_zpass.aleo,
#   function_name: sign_vc,
#   arguments: [
#     {
#   issuer: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z,
#   holder: aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q,
#   metadata_hash: 7008524940045791203999848867183584738587782508703254509438457557080158883755field,
#   sig: sign1uh76859j57w8sxsje8njerewcudp3qw8plp3us9d2td28x2rqyq4pyelcv3fv09s8w9f0d35um9szk8wcmat496nkwjqxj663r3zjqp4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6sjj3wz
# }
#   ]
# }

# verify
# transition verify(decrypted_metadata: String64) -> field {


ATTRIBUTES="{
    part0: 140152554740597502496524452237299901250u128,
    part1: 133324194421918155921132289162654938981u128
}"

ATTRIBUTES="{
    part0: 140152554740597502496524452237299901250u128,
    part1: 133324194421918155921132289162654938980u128
}"

leo run "verify" "${ATTRIBUTES}"

# function signature_verification2(msg_hash: field, sig: signature, issuer: address) -> bool {
MSG_HASH="7008524940045791203999848867183584738587782508703254509438457557080158883755field"
SIG="sign1gt4a0k69c46xw3rue5k2thwrg59umezvxf0gv9xzag7wtxug35qyevqk422w5evz2xmrcqukmc9r2aeqvfzfq0dpcdl6tw0g8e4txqe4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6vk0r3s"
ISSUER="aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z"
leo run "verify_test" "${MSG_HASH}" "${SIG}" "${ISSUER}"

# 뭔가 안되는데 일단 그냥 된다고 치고.. 

# function signature_verification2(msg_hash: field, sig: signature, issuer: address) -> bool {
# MSG_HASH="7008524940045791203999848867183584738587782508703254509438457557080158883755field"
# SIG="sign1gt4a0k69c46xw3rue5k2thwrg59umezvxf0gv9xzag7wtxug35qyevqk422w5evz2xmrcqukmc9r2aeqvfzfq0dpcdl6tw0g8e4txqe4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6vk0r3s"
# ISSUER="aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z"
# leo run "verify_field" "${SIG}" "${ISSUER}" "${MSG_HASH}"