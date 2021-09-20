<script setup>
import List from "./List.vue"
import Admin from "./admin.vue"
import { computed, reactive } from "@vue/reactivity";

const props = defineProps({
    contract: {
        type: Object,
        required: true
    },
    msg: {
        type: String,
        default: "Crypto Cat Clicker"
    }
});

const state = reactive({
    benders: [],
    admin: false,
    toggleButtonText: computed(() => state.admin ? "Back to List" : "Create bender")
});

const updateBenders = async () => {
    state.benders = await props.contract.getBenders();
}

const attack = async (bender) => {
    await props.contract.sendAttack(bender).catch((err) => {
        alert("Can't attack yet");
    });
    updateBenders();
}

updateBenders();
</script>

<template>
<h1 class="mb-5 text-2xl font-bold text-primary"> {{ msg }} </h1>
<Admin :contract="contract" v-if="state.admin" @created="updateBenders" />
<List v-else :benders="state.benders" @attack="attack" />
<button class="mt-5 btn btn-primary" @click="state.admin = !state.admin"> 
    {{ state.toggleButtonText }}
</button>
</template>