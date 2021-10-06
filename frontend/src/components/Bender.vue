<script setup>
import { ethers } from "ethers";
import {  reactive, computed, ref, watch, onMounted } from "vue";
import config from "../../config";
import AvatarBending from "./AvatarBending/Index.vue";
import BendingHeader from "./BendingHeader.vue";
import MessageProvider from "./MessageProvider.vue";
import epic from "../assets/audio/epic.mp3"
import Web3Modal, {  } from "web3modal/dist";
import { useSound } from "@vueuse/sound"
const provider = ref(null);
const signer = ref(null);

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
  getBalance(account)
})

const getBalance = async (address) => {
  state.balance = await provider.value.getBalance(address);
}

const getAccounts = async () => {
  state.accounts = await provider.value.listAccounts();
  state.selectedAccount = state.accounts[0];
}

//  Contracts
const benderContract = ref(null);

const initContract = async (signer) => {
  const { BENDER } = await import(`../utils/contracts.${config.mode}.js`)
  benderContract.value  = new ethers.Contract(
    config.bendingAddress,
    BENDER.abi, 
    signer || provider.value
  );
  
  if (signer) {
    await getAccounts();
  }
  return benderContract;
}

const onChangeAccount = async (wallet) => {
  provider.value = new ethers.providers.Web3Provider(wallet, "any");
  const user = provider.value.getSigner();
  await initContract(user)
  signer.value = user;
}

const connectWallet = async () => {
  const web3Modal = new Web3Modal({
    cacheProvider: true,
  });

  const wallet = await web3Modal.connect();
  onChangeAccount(wallet);
  listenProviderEvents(wallet)
}

const listenProviderEvents = (walletProvider) => {
  walletProvider.on("accountsChanged", (accounts) => {
    onChangeAccount(walletProvider, accounts)
  });

  walletProvider.on("chainChanged", (chainId) => {
    console.log(chainId);
  });

  walletProvider.on("connect", (info) => {
    console.log(info);
  });

  walletProvider.on("disconnect", (error) => {
    console.log(error);
  });
}

const setProvider = async (isMetamask) => {
  if (isMetamask) {
    provider.value = new ethers.providers.JsonRpcProvider();
  } else {
    provider.value = new ethers.providers.WebSocketProvider("ws://localhost:8545");
  }
}

const { play, stop } = useSound(epic, { 
  volume: 0.2
 });

const toggleAudio = (mode) => {
  const method = mode == 'play' ? play : stop;
  method(); 
}

onMounted(async () => {
  setProvider(true);
  initContract()
})

</script>

<template>
<MessageProvider>
  <BendingHeader
    :balance="state.formattedBalance"
    :currency="state.currency"
    :accounts="state.accounts"
    :selectedMode="state.mode"
    :modes="state.modes"
    @set-mode="state.mode = $event"
    @music="toggleAudio"
    @connectWallet="connectWallet"
    v-model="state.selectedAccount"
  />
  
  <button class="btn btn-primary" @click="connectWallet" v-if="!signer"> Start </button>

  <div class="flex flex-col items-center justify-center mt-10">
    <div v-if="benderContract && signer" class="mt-40 mb-10">
      <AvatarBending 
        :contract="benderContract"  
        :account="state.selectedAccount"
        :mode="state.mode"
        msg=""
      />
    </div>
  </div>
</MessageProvider>
</template>

