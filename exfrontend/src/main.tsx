import { Buffer } from 'buffer'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import {StrictMode} from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter as Router } from 'react-router-dom';
import App from './App.js'
import '@rainbow-me/rainbowkit/styles.css';
import {getDefaultConfig, RainbowKitProvider,  darkTheme } from '@rainbow-me/rainbowkit';
import { WagmiProvider, http } from 'wagmi';
import {sei} from 'wagmi/chains';
import './index.css'


const proj = import.meta.env.VITE_PROJECT_ID

const config = getDefaultConfig({
  appName: 'Seitastic',
  projectId: proj || '',
  chains: [sei],
  transports: {
    [sei.id]: http('https://evm-rpc.sei-apis.com'),
    // [seiTestnet.id]: http('https://evm-rpc-testnet.sei-apis.com'),
  },
  ssr: true, // If your dApp uses server side rendering (SSR)
});

globalThis.Buffer = Buffer

const queryClient = new QueryClient()

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
      <RainbowKitProvider theme={darkTheme({
      accentColor: '#1e1e2f',
      accentColorForeground: 'white',
      fontStack: 'system',
      overlayBlur: 'small',
    })}>
        <Router>
          <App />
        </Router>
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  </StrictMode>
)
