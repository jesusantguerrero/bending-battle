<script setup>
import { ethers } from "ethers";
import {  reactive, computed, ref, watch } from "vue";
import avatarJSON from "../../../artifacts/contracts/AvatarBending.sol/AvatarBending.json";
import AvatarBending from "./AvatarBending/Index.vue";
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
  formattedBalance: computed(() => ethers.utils.formatEther(state.balance)),
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
    <h4 class="mb-2 font-bold text-primary"> Accounts </h4>
    <div class="py-2">
      <select  v-model="state.selectedAccount">
        <option v-for="account in state.accounts" :value="account">
        {{ account }}
        </option>
      </select>
    </div>
    <h4 class="mb-2 font-bold text-primary"> Balance </h4>
    <h1 class="text-4xl"> {{ state.formattedBalance }} {{ state.currency }}</h1>

    <div class="flex flex-col items-center justify-center mt-5">
      <div v-if="avatarContract" class="mt-5 mb-10">
        <AvatarBending :contract="avatarContract" msg="Avatar Bender" />
      </div>
    </div>
</template>

