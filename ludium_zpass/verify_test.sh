#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

#    transition verify_field(s: signature, a: address, v: field) -> bool {
#        return signature::verify(s, a, v);
#    }

SIG=sign1qafy4wuc9pqzqhwd5pervqen57nzyap3zc6qf755qt62tahaavpg0stexawrtzg97uhe59gnv3fu55vt4d8ek5vkpy26dh64y7pygqp4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6x9fhmj
ISSUER=aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z
MSG_HASH=7008524940045791203999848867183584738587782508703254509438457557080158883755field

leo run "verify_field" "${SIG}" "${ISSUER}" "${MSG_HASH}"

