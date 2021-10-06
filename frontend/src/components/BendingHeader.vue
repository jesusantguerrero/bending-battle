<script setup>
import { ref, computed } from "vue";

const props = defineProps({
    modelValue: {
        type: String,
        required: true
    },
    signer: {
        type: Object
    },
    accounts: {
        type: Array,
        required: true
    },
    balance: {
        type: [Number, String],
        required: true
    },
    currency: {
        type: String,
        required: true
    },
    modes: {
        type: Array,
        required: true
    },
})

const emit = defineEmits(['set-mode', 'play', 'mute', 'connectWallet', 'disconnectWallet']);

const showMenu = ref(false);
const setMode = (mode) => {
    showMenu.value = false;
    emit("set-mode", mode);
}

const isPlaying = ref(false);
const toggleAudio = () => {
    const mode = isPlaying.value ? 'mute' : 'play'
    isPlaying.value = !isPlaying.value;
    emit('music', mode);
}

const connectionText = computed(() => props.signer ? 'Disconnect' : 'Connect Wallet');
const toggleConnection = () => {
    emit(props.signer ? 'disconnectWallet' : 'connectWallet' )
}
</script>

<template>
  <div class="fixed top-0 flex justify-around w-full h-10 mx-auto transform bg-header">
    <div class="rounded-md h-36 w-36">
        <div class="w-full h-full mt-2 text-white bg-fire-map rounded-badge">
            
        </div>
        <button class="mt-2 btn btn-sm btn-primary bg-fire-400" @click="toggleAudio">
             <i :class="[isPlaying ? 'fa fa-volume-mute' : 'fa fa-play']"></i>
        </button>
    </div>
    <div class="flex justify-around w-8/12 h-full py-2 font-bold text-white border-2 border-t-0 rounded-b-full shadow-lg bg-fire-map-500 border-fire">
      <div>
        {{ balance }}
      </div>

      <div>
        Bending Battle
      </div>

        <div class="flex items-center space-x-2 cursor-pointer" @click="toggleConnection">
            <div class="w-3 h-3 border-2 border-white rounded-full"
            :class="[signer ? 'bg-green-500' : 'bg-fire-map-700']"
            ></div>
            <button> {{ connectionText }}</button>
        </div>
    </div>
    <div>
        <div @click="showMenu=!showMenu" class="flex items-center justify-center mt-2 text-4xl font-bold text-white border-4 border-white rounded-full cursor-pointer bg-fire-map h-36 w-36">
            Menu
        </div>
        <ul class="py-3 mt-3 text-white bg-fire rounded-box" v-if="showMenu">
            <li v-for="mode in modes" @click="setMode(mode)" class="capitalize cursor-pointer hover:font-bold">
                {{ mode }}
            </li>
        </ul>
    </div>
  </div>
</template>
