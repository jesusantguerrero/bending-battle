<script setup>
import { ethers } from "ethers";
import {  reactive, computed, ref, watch } from "vue";
import avatarJSON from "../../../artifacts/contracts/AvatarBending.sol/AvatarBending.json";
import AvatarBending from "./AvatarBending/Index.vue";
import BendingHeader from "./BendingHeader.vue";
const provider = new ethers.providers.WebSocketProvider("ws://localhost:8545")

const tabsState = reactive({
  current: "Assets",
  tabs: ['Assets', 'Transactions', 'Settings'],
});

const state = reactive({
  balance: 0,
  accounts: [],
  selectedAccount: null,
  greet: "",
  formattedBalance: computed(() => 
    Number(ethers.utils.formatEther(state.balance)).toFixed(4)
  ),
  currency: 'ETH',
})

const getBalance = async (address) => {
  state.balance = await provider.getBalance(address);
}

const getAccounts = async () => {
  state.accounts = await provider.listAccounts();
  state.selectedAccount = state.accounts[0];
}

watch(() => state.selectedAccount, () => {
  if (state.selectedAccount) {
    getBalance(state.selectedAccount);
    initContract();
  }
}, { immediate: true });

//  Contracts
const avatarContract = ref(null);

const initContract = async () => {
  avatarContract.value = new ethers.Contract(import.meta.env.VITE_AVATAR_ADDRESS, avatarJSON.abi, provider.getSigner(state.selectedAccount)); 
}

getAccounts();
</script>

<template>
  <BendingHeader
    :balance="state.formattedBalance"
    :currency="state.currency"
    :accounts="state.accounts"
    v-model="state.selectedAccount"
  />

    <div class="flex flex-col items-center justify-center mt-10">
      <div v-if="avatarContract" class="mt-40 mb-10">
        <AvatarBending :contract="avatarContract" msg="" />
      </div>
    </div>
</template>

