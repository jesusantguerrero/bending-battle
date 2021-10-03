<script setup>
defineProps({
    modelValue: {
        type: Object,
        required: true
    },
    accounts: {
        type: Array,
        required: true
    },
    balance: {
        type: Number,
        required: true
    },
    currency: {
        type: String,
        required: true
    },
})
</script>

<template>
  <div class="fixed top-0 flex justify-around w-full h-10 mx-auto transform bg-header">
    <div class="rounded-md h-36 w-36">
        <div class="w-full h-full mt-2 text-white bg-fire-map rounded-badge">
            
        </div>
        <div>
        <h4 class="mb-2 font-bold text-white"> Account </h4>
        <select :modelValue="selectedAccount" @change="$emit('update:modelValue', $event.target.value)">
            <option v-for="account in accounts" :value="account">
            {{ account.slice(0, 10) }}
            </option>
        </select>
        <h1 class="font-bold"> {{ balance }} {{ currency }}</h1>
        
        </div>
    </div>
    <div class="w-8/12 h-full py-2 font-bold text-white border-2 border-t-0 rounded-b-full shadow-lg bg-fire-map-500 border-fire">
      Bending Battle
    </div>
    <div class="flex items-center justify-center mt-2 text-4xl font-bold text-white border-4 border-white rounded-full cursor-pointer bg-fire-map h-36 w-36">
        Menu
    </div>
  </div>
</template>
