<script setup>
import { ref } from "vue";

defineProps({
    modelValue: {
        type: String,
        required: true
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

const emit = defineEmits(['set-mode']);

const showMenu = ref(false);

const setMode = (mode) => {
    showMenu.value = false;
    emit("set-mode", mode);
}
</script>

<template>
  <div class="fixed top-0 flex justify-around w-full h-10 mx-auto transform bg-header">
    <div class="rounded-md h-36 w-36">
        <div class="w-full h-full mt-2 text-white bg-fire-map rounded-badge">
            
        </div>
    </div>
    <div class="w-8/12 h-full py-2 font-bold text-white border-2 border-t-0 rounded-b-full shadow-lg bg-fire-map-500 border-fire">
      Bending Battle
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
