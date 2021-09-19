<script setup>
import { ethers } from "ethers";
import {  reactive, computed } from "vue";
import contractJSON from "../../../artifacts/contracts/Greeter.sol/Greeter.json";

const provider = new ethers.providers.WebSocketProvider("ws://localhost:8545")
const greeterContract = new ethers.Contract("0x5FbDB2315678afecb367f032d93F642f64180aa3", contractJSON.abi, provider.getSigner());

const tabsState = reactive({
  current: "Assets",
  tabs: ['Assets', 'Transactions', 'Settings'],
});

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

const greet = async () => {
  console.log(greeterContract);
  console.log(await greeterContract.functions.greet());
}
getAccounts();
</script>

<template>
  <h1> Account </h1>
  <h2 class=""> {{ state.accounts[0] }}</h2>
  <div class="divider"></div>
  <h1 class="text-4xl"> {{ state.formattedBalance }} {{ state.currency }}</h1>
  <div class="flex justify-center w-full mt-5 text-center">
    <div class="flex space-x-1">
      <button class="btn btn-primary">Buy</button>
      <button class="btn btn-primary">Send</button>
      <button class="btn btn-primary">Swap</button>
    </div>
  </div>
  <div class="flex justify-center w-full mt-5 text-center">
      <button class="btn btn-primary" @click="greet()">Greet</button>
  </div>
  <div class="flex justify-center mt-5">
    <div class="text-center tabs">
      <a 
        class="tab tab-bordered" 
        v-for="tab in tabsState.tabs"
        :class="{'tab-active' : tabsState.current == tab}"
        @click="tabsState.current = tab" 
      >
        {{ tab }}
        </a> 
    </div>
  </div>
</template>

