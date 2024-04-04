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

# Swap in the private key of Alice.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkp1w8PTxrRgGfAtfKUSq43iQyVbdQHfhGbiNPEg2LVSEXR
" > .env

set -ux

META_DATA="{
    part0: 140152554740597502496524452237299901250u128,
    part1: 133324194421918155921132289162654938981u128
}"

leo run "request_new_vc" aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q "${META_DATA}"

exit(1);

# Swap in the private key of Bob.
echo "
NETWORK=testnet3
PRIVATE_KEY=APrivateKey1zkpFo72g7N9iFt3JzzeG8CqsS5doAiXyFvNCgk2oHvjRCzF
" > .env

UNSIGNED_VC="{
  owner: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z.private,
  holder: aleo13ssze66adjjkt795z9u5wpq8h6kn0y2657726h4h3e3wfnez4vqsm3008q.private,
  attributes: {
    part0: 140152554740597502496524452237299901250u128.private,
    part1: 133324194421918155921132289162654938981u128.private,
    part2: 93509703548909910993375653557521895508u128.private,
    part3: 147831289382731815962129268963868147712u128.private
  },
  _nonce: 354998397500206389428199971616865075607554237379969307856108876210982075101group.public
}"

leo -d run "sign_vc" "${UNSIGNED_VC}"
