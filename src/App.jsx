import { useState } from 'react';
import helloworld_program from '../helloworld/build/main.aleo?raw';
import { AleoWorker } from './workers/AleoWorker.js';
import { Background } from './Backgroud.jsx';
import { Footer } from './Footer.jsx';
import { Button } from './Button.jsx';

const aleoWorker = AleoWorker();
function App() {
  const [account, setAccount] = useState(null);
  const [executing, setExecuting] = useState(false);
  const [deploying, setDeploying] = useState(false);

  const generateAccount = async () => {
    const key = await aleoWorker.getPrivateKey();
    setAccount(await key.to_string());
  };

  async function execute() {
    setExecuting(true);
    const result = await aleoWorker.localProgramExecution(
      helloworld_program,
      'main',
      ['5u32', '5u32']
    );
    setExecuting(false);

    alert(JSON.stringify(result));
  }

  async function deploy() {
    setDeploying(true);
    try {
      const result = await aleoWorker.deployProgram(helloworld_program);
      console.log('Transaction:');
      console.log('https://explorer.hamp.app/transaction?id=' + result);
      alert('Transaction ID: ' + result);
    } catch (e) {
      console.log(e);
      alert('Error with deployment, please check console for details');
    }
    setDeploying(false);
  }

  return (
    <>
      <div className="relative isolate bg-white h-[100dvh]">
        <main className="mx-auto max-w-screen-2xl py-16 px-8 md:px-24 tall:min-h-[calc(100dvh-128px)] ring-2 ring-blue-1000">
          <h1 className="text-5xl md:text-6xl font-bold tracking-tight md:pt-24 ring-2 ring-blue-1000">
            Aleo OnChain zPass
          </h1>
          <p className="py-4 ring-2 ring-blue-1000">
            A sample app build with React, Tailwind and{' '}
            <a
              href="https://juno.build"
              rel="noopener noreferrer"
              target="_blank"
              className="underline"
            >
              Juno
            </a>
            .
          </p>
          <Button onClick={generateAccount}>
            {account
              ? `Account is ${JSON.stringify(account)}`
              : `Click to generate account`}
          </Button>
          <Button onClick={execute} disabled={executing}>
            {executing
              ? `Executing...check console for details...`
              : `Execute helloworld.aleo`}
          </Button>

          {/* Advanced Section */}
          <div className="card">
            <h2>Advanced Actions</h2>
            <p>
              Deployment on Aleo requires certain prerequisites like seeding
              your wallet with credits and retrieving a fee record. Check README
              for more details.
            </p>
            <p>
              <button disabled={deploying} onClick={deploy}>
                {deploying
                  ? `Deploying...check console for details...`
                  : `Deploy helloworld.aleo`}
              </button>
            </p>
          </div>
          <p className="read-the-docs">
            Click on the Aleo and React logos to learn more
          </p>
        </main>

        <Footer />
        <Background />
      </div>
    </>
  );
}

export default App;
