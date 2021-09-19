<script setup>
import List from "./List.vue"
import Admin from "./admin.vue"

const props = defineProps({
    contract: {
        type: Object,
        required: true
    }
});

</script>

<template>
<h1> Crypto Cat Clicker </h1>
<List :contract="contract" v-if="contract" />
<Admin :contract="contract" v-if="contract" />
</template>