import { useState } from 'react';
import ludium_zpass from '../ludium_zpass/build/main.aleo?raw';
import { AleoWorker } from './workers/AleoWorker.js';
import { Background } from './Backgroud.jsx';
import { Footer } from './Footer.jsx';
import { Button } from './Button.jsx';
import { Card } from './Card.jsx';
import { Modal } from './Modal.jsx';

const aleoWorker = AleoWorker();
function App() {
  // #####################################
  // ###          User & Verifier        #
  // #####################################

  const studentAccount =
    'APrivateKey1zkp1w8PTxrRgGfAtfKUSq43iQyVbdQHfhGbiNPEg2LVSEXR';
  const [studentAddress, setStudentAddress] = useState(null);

  const loadStudentAddress = async () => {
    const address = await aleoWorker.getAddress(studentAccount);
    setStudentAddress(address);
  };

  // #####################################
  // ###          Issuer                 #
  // #####################################

  const ludiumAccount =
    'APrivateKey1zkpFo72g7N9iFt3JzzeG8CqsS5doAiXyFvNCgk2oHvjRCzF';
  const [ludiumAddress, setLudiumAddress] = useState(null);

  const loadLudiumAddress = async () => {
    const address = await aleoWorker.getAddress(ludiumAccount);
    setLudiumAddress(address);
  };

  // #####################################
  // ###          Program                #
  // #####################################
  const [programState, setProgramState] = useState(null);

  // #####################################
  // ###          Workflow               #
  // #####################################

  // 1. request new vc from student
  const studentMetadata =
    '{part0: 140152554740597502496524452237299901250u128,part1: 133324194421918155921132289162654938981u128}';
  const [executingRequestNewVC, setExecutingRequestNewVC] = useState(false);
  const [unsignedVc, setUnsignedVc] = useState(null);

  async function requestNewVC() {
    setExecutingRequestNewVC(true);

    const result = await aleoWorker.localProgramExecution(
      ludium_zpass,
      'request_new_vc',
      [studentAddress, studentMetadata]
    );

    const cleanedResult = result[0].replace(/\n/g, '');

    setExecutingRequestNewVC(false);
    setUnsignedVc(cleanedResult);
    handleOpenModal('Created a new unsigned VC', cleanedResult);
  }

  // 2. sign into requested vc by ludium

  const unsigned_vc = `{
    owner: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z.private,
    holder: aleo129hg4nn7d8x23ny0y859vkel82tn5r44v8kc5k3twp0hj9eflg8sa63y6q.private,
    attributes: {
      part0: 140152554740597502496524452237299901250u128.private,
      part1: 133324194421918155921132289162654938981u128.private
    },
    _nonce: 302645000592134357133380247975811182313144404750169370354575912370996304830group.public
  }`;
  const signature =
    'sign1uh76859j57w8sxsje8njerewcudp3qw8plp3us9d2td28x2rqyq4pyelcv3fv09s8w9f0d35um9szk8wcmat496nkwjqxj663r3zjqp4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6sjj3wz';
  const [executingSignVC, setExecutingSignVC] = useState(false);

  async function signVC() {
    setExecutingSignVC(true);

    const cleanedUnsignedVc = unsigned_vc.replace(/\n/g, '');
    const result = await aleoWorker.localProgramExecution(
      ludium_zpass,
      'sign_vc',
      [signature, cleanedUnsignedVc]
    );

    const cleanedVC = result[0].replace(/\n/g, '');
    const cleanedState = result[1].replace(/\n/g, '');

    setExecutingSignVC(false);
    setProgramState(cleanedState);
    handleOpenModal('Signed on a new VC', cleanedVC);
  }

  // 2. verify vc when user need to verify to other verfiers about own vc
  const vc = `{
    issuer: aleo17vy26rpdhqx4598y5gp7nvaa9rk7tnvl6ufhvvf4calsrrqdaqyshdsf5z,
    holder: aleo129hg4nn7d8x23ny0y859vkel82tn5r44v8kc5k3twp0hj9eflg8sa63y6q,
    metadata_hash: 7008524940045791203999848867183584738587782508703254509438457557080158883755field,
    sig: sign1uh76859j57w8sxsje8njerewcudp3qw8plp3us9d2td28x2rqyq4pyelcv3fv09s8w9f0d35um9szk8wcmat496nkwjqxj663r3zjqp4wvk4qf6keyrq0k82kl3lncv97wmk90he4ssfj2kg4qdhthnepka9qj92l3ywpfwe4x2xhpuw88lwqlk6d9cescjc8ac997dh9ctq6sjj3wz
  }`;

  const [executingVerify, setExecutingVerify] = useState(false);
  async function verify() {
    setExecutingVerify(true);

    const result = await aleoWorker.localProgramExecution(
      ludium_zpass,
      'verify',
      [studentMetadata]
    );

    const cleanedResult = result[0].replace(/\n/g, '');
    console.log(cleanedResult);

    if (cleanedResult !== '') {
      handleOpenModal('Verify result', 'true');
    } else {
      handleOpenModal('Verify result', 'false');
    }

    setExecutingVerify(false);
  }

  // #####################################
  // ###          ETC                    #
  // #####################################

  const handleOpenModal = (title, content) => {
    setModalTitle(title); // 모달 타이틀을 설정합니다.
    setModalContent(content); // 모달 콘텐츠를 설정합니다.
    setModalOpen(true);
  };

  const handleCloseModal = () => {
    setModalOpen(false);
  };

  const [isModalOpen, setModalOpen] = useState(false);
  const [modalTitle, setModalTitle] = useState('');
  const [modalContent, setModalContent] = useState('');

  return (
    <>
      <div className="relative isolate bg-white h-[100dvh]">
        <main className="mx-auto max-w-screen-2xl py-8 px-8 md:px-24 tall:min-h-[calc(100dvh-128px)]">
          <h1 className="text-5xl md:text-6xl font-bold tracking-tight md:pt-24 text-center">
            Aleo OnChain zPass Applicatiion For Ludium
          </h1>

          <Card
            title="ludium_zpass.aleo"
            content={
              programState
                ? programState
                : 'Here will be replaced with states of ludium_zpass program'
            }
          />

          <div class="flex ">
            {/* <!-- 왼쪽 부분, 유저 영역 --> */}
            <div class="flex-1">
              <h3 className="text-5xl md:text-5xl font-bold tracking-tight md:pt-12">
                Student Section
              </h3>
              <Button onClick={loadStudentAddress}>
                {studentAddress
                  ? `Address is ${JSON.stringify(studentAddress)}`
                  : `Load a user address`}
              </Button>
              <Button disabled={!studentAddress}>
                {studentAddress
                  ? `Encoded Metadata: ${JSON.stringify(studentMetadata)}`
                  : `Subject: Leo Token / Date: 2024-04-05`}
              </Button>
              <Button
                onClick={requestNewVC}
                disabled={!studentAddress || executingRequestNewVC}
              >
                Request New VC
              </Button>
              <Button
                onClick={verify}
                disabled={!studentAddress || executingVerify}
              >
                Verify My VC
              </Button>
            </div>

            {/* <!-- 오른쪽 부분, 이슈어 영역 --> */}
            <div class="flex-1 ">
              <h3 className="text-5xl md:text-5xl font-bold tracking-tight md:pt-12">
                Ludium Section
              </h3>
              <Button onClick={loadLudiumAddress}>
                {ludiumAddress
                  ? `Address is ${JSON.stringify(ludiumAddress)}`
                  : `Load a user address`}
              </Button>
              <Button
                onClick={signVC}
                disabled={!ludiumAddress || executingSignVC}
              >
                Sign On Requested VC
              </Button>
            </div>
          </div>

          <Modal
            isOpen={isModalOpen}
            onClose={handleCloseModal}
            title={modalTitle}
            content={modalContent}
          />
        </main>
        <Footer />
        <Background />
      </div>
    </>
  );
}

export default App;
