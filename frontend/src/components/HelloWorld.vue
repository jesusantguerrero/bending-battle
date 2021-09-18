<script setup>
import { ethers } from "ethers";
import { ref, reactive, computed } from "vue";

const provider = new ethers.providers.WebSocketProvider("ws://localhost:8545")

const state = reactive({
  balance: 0,
  accounts: [],
  formattedBalance: computed(() => ethers.utils.formatEther(state.balance)),
  currency: 'ETH',
})

const getBalance = async (address) => {
  state.balance = await provider.getBalance(address);
}

const getAccounts = async () => {
  state.accounts = [await provider.getSigner().getAddress()];
  getBalance(state.accounts[0]);
}
getAccounts();
</script>

<template>
  <h1> {{ state.accounts[0] }}</h1>
  <h1> {{ state.formattedBalance }} {{ state.currency }}</h1>
</template>

