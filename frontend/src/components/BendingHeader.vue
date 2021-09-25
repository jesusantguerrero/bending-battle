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
        <div class="w-full h-full mt-2 text-white bg-red-500 rounded-badge">
            Hola
        </div>
        <div>
        <h4 class="mb-2 font-bold text-primary"> Account </h4>
        <select :modelValue="selectedAccount" @change="$emit('update:modelValue', $event.target.value)">
            <option v-for="account in accounts" :value="account">
            {{ account.slice(0, 10) }}
            </option>
        </select>
        <h1 class="font-bold"> {{ balance }} {{ currency }}</h1>
        
        </div>
    </div>
    <div class="w-8/12 h-full py-2 font-bold text-white rounded-b-full bg-fire-500">
      Bending Battle
    </div>
    <div class="mt-2 bg-red-500 h-36 w-36">
    
    </div>
  </div>
</template>
