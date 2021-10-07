<script setup>
import { provide, ref } from "vue";

const message = ref(null);
const timer = ref(null);
const useMessage = (text, time = 5000) => {
  clearTimeout(timer.value);
  message.value = text;
  if (time) {
      timer.value = setTimeout(() => {
        message.value = null;
      }, time);
  }
}

provide("useMessage", useMessage);
</script>

<template>
<slot />
<div class="fixed z-50 flex justify-center w-full h-32 bottom-5" v-if="message">
    <div class="flex items-center justify-center w-8/12 h-32 text-white bg-black border-2 border-white opacity-70 rounded-box" v-if="message">
        {{ message }}
    </div>
</div>
</template>