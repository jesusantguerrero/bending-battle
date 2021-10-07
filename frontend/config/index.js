export default {
    bendingAddress: import.meta.env.VITE_BENDING_ADDRESS,
    rpcURL: import.meta.env.VITE_RPC_URL,
    mode: import.meta.env.VITE_CONTRACT_MODE || 'prod',
    formaticKey: import.meta.VITE_FORMATIC_KEY
}