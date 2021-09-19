<script setup>
import { ethers } from "ethers";
import CatClicker from "./CatClicker/Index.vue"
import {  reactive, computed, ref } from "vue";
import greeterJSON from "../../../artifacts/contracts/Greeter.sol/Greeter.json";
import CatJSON from "../../../artifacts/contracts/Clicker.sol/Clicker.json";
const provider = new ethers.providers.WebSocketProvider("ws://localhost:8545")

const tabsState = reactive({
  current: "Assets",
  tabs: ['Assets', 'Transactions', 'Settings'],
});

const state = reactive({
  balance: 0,
  accounts: [],
  greet: "",
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

//  Contracts
const greeter = ref(null);
const catClickerContract = ref(null);

const initContract = async () => {
  greeter.value = new ethers.Contract(import.meta.env.VITE_GREETER_ADDRESS, greeterJSON.abi, provider.getSigner());
  catClickerContract.value = new ethers.Contract(import.meta.env.VITE_CAT_CLICKER_ADDRESS, CatJSON.abi, provider.getSigner()); 
}

initContract();

const greet = async () => {
  state.greet = await greeter.value.greet();
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

  <CatClicker :contract="catClickerContract" />

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

