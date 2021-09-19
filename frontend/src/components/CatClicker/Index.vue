<script setup>
import List from "./List.vue"
import Admin from "./admin.vue"
import { computed, reactive } from "@vue/reactivity";

const props = defineProps({
    contract: {
        type: Object,
        required: true
    }
});

const state = reactive({
    cats: [],
    admin: false,
    toggleButtonText: computed(() => state.admin ? "Back to List" : "Add new cat")
});

const updateCats = async () => {
    state.cats = await props.contract.getCats();
}

const incrementCat = async (cat) => {
    await props.contract.updateClick(cat);
    updateCats();
}

updateCats();
</script>

<template>
<h1 class="mb-5 text-2xl font-bold text-primary"> Crypto Cat Clicker </h1>
<Admin :contract="contract" v-if="state.admin" @cat-added="updateCats" />
<List v-else :cats="state.cats" @click="incrementCat" />
<button class="mt-5 btn btn-primary" @click="state.admin = !state.admin"> 
    {{ state.toggleButtonText }}
</button>
</template>