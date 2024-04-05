#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

MSG_HASH="7008524940045791203999848867183584738587782508703254509438457557080158883755field"
SIG="sign1gt4a0k69c46xw3rue5k2thwrg59umezvxf0gv9xzag7wtxug35qyevqk422w5evz2xmrcqukmc9r2aeqvfzfq0dpcdl6tw0g8e4txqe4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6vk0r3s"
ISSUER="aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z"

leo run "verify_field" "${SIG}" "${ISSUER}" "${MSG_HASH}"