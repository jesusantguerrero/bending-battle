<script setup>
import Web3 from "web3/dist/web3.min";
import { ref, reactive, computed } from "vue";

const provider = new Web3("ws://localhost:8545")
let message = ref('message');

const state = reactive({
  balance: 0,
  accounts: [],
  formattedBalance: computed(() => state.balance),
})

const getBalance = async (address) => {
  state.balance = await provider.eth.getBalance(address);
}

const getAccounts = async () => {
  state.accounts = await provider.eth.getAccounts();
}
getAccounts();
</script>

<template>
  <h1> {{ message }}</h1>
  <h1> {{ state.formattedBalance }}</h1>
  <div>
    <ul>
      <li v-for="account in state.accounts" @click="getBalance(account)"> {{ account }}</li>
    </ul>
  </div>
</template>

