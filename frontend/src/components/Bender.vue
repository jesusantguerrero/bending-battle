<script setup>
import {  reactive } from "vue";
import AvatarBending from "./AvatarBending/Index.vue";
import BendingHeader from "./BendingHeader.vue";
import MessageProvider from "./MessageProvider.vue";
import epic from "../assets/audio/epic.mp3"
import { useSound } from "@vueuse/sound"
import { useContract } from "../utils/useContract";

const state = reactive({
  mode: "dashboard",
  modes: ['dashboard', 'battle', 'market'],
})

const { play, stop } = useSound(epic, { 
  volume: 0.2
});

const toggleAudio = (mode) => {
  const method = mode == 'play' ? play : stop;
  method(); 
}

const { benderContract, contractState, signer, disconnectWallet, connectWallet } = useContract();
</script>

<template>
<MessageProvider>
  <BendingHeader
    :balance="contractState.formattedBalance"
    :currency="contractState.currency"
    :accounts="contractState.accounts"
    :selectedMode="state.mode"
    :modes="state.modes"
    :signer="signer"
    @set-mode="state.mode = $event"
    @music="toggleAudio"
    @disconnectWallet="disconnectWallet"
    @connectWallet="connectWallet"
    v-model="contractState.selectedAccount"
  />

  <div class="flex flex-col items-center justify-center mt-10">
    <div v-if="benderContract && signer" class="mt-40 mb-10">
      <AvatarBending 
        :contract="benderContract"  
        :account="contractState.selectedAccount"
        :mode="state.mode"
        msg=""
      />
    </div>
  </div>
</MessageProvider>
</template>

