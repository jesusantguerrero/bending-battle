import Web3Modal from "web3modal/dist/";
import { ethers } from "ethers";
import config from "../../config";
import { ref, reactive, computed, onMounted, watch } from "vue";

const web3Modal = new Web3Modal({
    cacheProvider: true,
});

export const useContract = () => {
    const provider = ref(null);
    const signer = ref(null);
    const wallet = ref(null);


    const state = reactive({
        balance: 0,
        accounts: [],
        selectedAccount: null,
        mode: "dashboard",
        modes: ['dashboard', 'battle', 'market'],
        formattedBalance: computed(() => 
        Number(ethers.utils.formatEther(state.balance)).toFixed(4)
        ),
        currency: 'ETH',
    })
  
    watch(() => state.selectedAccount, (account) => {
        if (account) {
            getBalance(account, signer.value)
        }
    })
  
    const getBalance = async (address) => {
        state.balance = await provider.value.getBalance(address);
    }
    
    //  Contracts
    const benderContract = ref(null);
    
    const initContract = async (signer) => {
        if (!provider.value) {
            setProvider();
        }
        const { BENDER } = await import(`../utils/contracts.${config.mode}.js`)
        benderContract.value  = new ethers.Contract(
            config.bendingAddress,
            BENDER.abi, 
            signer || provider.value
        );
        return benderContract;
    }
    
    const onChangeAccount = async (wallet, account) => {
        provider.value = new ethers.providers.Web3Provider(wallet, "any");
        const selectedAddress = account || wallet.selectedAddress;
        const user = provider.value.getSigner(selectedAddress);
        await initContract(user)
        state.selectedAccount = selectedAddress;
        signer.value = user;
    }
    
    const connectWallet = async () => {
        wallet.value = await web3Modal.connect();
        onChangeAccount(wallet.value);
        listenProviderEvents(wallet.value)
    }
    
    const disconnectWallet  = async () => {
        if (wallet.value.close) {
            await wallet.value.close()
            web3Modal.clearCachedProvider();
        }
        
        signer.value = null;
        provider.value = null;
        initContract();
    }
    
    const listenProviderEvents = (walletProvider) => {
        walletProvider.on("accountsChanged", (accounts) => {
            onChangeAccount(walletProvider, accounts[0])
        });
    
        walletProvider.on("chainChanged", (chainId) => {
            if (chainId !== chainId) {
                // wrong chain
            }
            onChangeAccount(wallet);
        });
    }
    
    const setProvider = async () => {
        provider.value = new ethers.providers.JsonRpcProvider(config.rpcURL, "any");
    }

    onMounted(async () => {
        initContract();
        if (web3Modal.cachedProvider) {
          connectWallet();
        }
    })

    return {
        connectWallet,
        disconnectWallet,
        contractState: state,
        signer,
        benderContract
    }
}