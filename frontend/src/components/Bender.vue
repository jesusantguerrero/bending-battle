<script setup>
import { ethers } from "ethers";
import {  reactive, computed, ref, watch, onMounted } from "vue";
import BENDER from "../../../artifacts/contracts/BenderOwnership.sol/BenderOwnership.json";
import config from "../../config";
import AvatarBending from "./AvatarBending/Index.vue";
import BendingHeader from "./BendingHeader.vue";
const provider = ref(null)

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

const getBalance = async (address) => {
  state.balance = await provider.value.getBalance(address);
}

const getAccounts = async () => {
  state.accounts = await provider.value.listAccounts();
  state.selectedAccount = state.accounts[0];
}

watch(() => state.selectedAccount, () => {
  if (state.selectedAccount) {
    getBalance(state.selectedAccount);
    initContract();
  }
}, { immediate: true });

//  Contracts
const benderContract = ref(null);

const initContract = async () => {
  benderContract.value = new ethers.Contract(
    config.bendingAddress, 
    BENDER.abi, 
    provider.value.getSigner(state.selectedAccount)
  ); 
}

const setProvider = async (isMetamask) => {
  if (isMetamask) {
    const prov = new ethers.providers.Web3Provider(window.web3.currentProvider, "any");
    provider.value = prov;
    await provider.value.send("eth_requestAccounts", []);
  } else {
    provider.value = new ethers.providers.WebSocketProvider("ws://localhost:8545");
  }
}

onMounted(async () => {
  setProvider(true);
  window.ethereum.on("accountsChanged", async (event) => {
    await getAccounts();
  });
  getAccounts();
})
</script>

<template>
  <BendingHeader
    v-if="state.selectedAccount"
    :balance="state.formattedBalance"
    :currency="state.currency"
    :accounts="state.accounts"
    :selectedMode="state.mode"
    :modes="state.modes"
    @set-mode="state.mode = $event"
    v-model="state.selectedAccount"
  />

    <div class="flex flex-col items-center justify-center mt-10">
      <div v-if="benderContract" class="mt-40 mb-10">
        <AvatarBending 
          :contract="benderContract"  
          :account="state.selectedAccount"
          :mode="state.mode"
          msg=""
        />
      </div>
    </div>
</template>

