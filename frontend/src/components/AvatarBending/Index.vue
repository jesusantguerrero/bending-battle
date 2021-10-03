<script setup>
import List from "./List.vue"
import Admin from "./admin.vue"
import { computed, reactive } from "@vue/reactivity";

const props = defineProps({
    contract: {
        type: Object,
        required: true
    },
    account: {
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
    enemyId: null,
    toggleButtonText: computed(() => state.admin ? "Back to List" : "Create bender")
});

const updateBenders = async () => {
    state.benders = await props.contract.getBenders();
}

const attack = async (bender) => {
    if(state.enemyId == null) {
        return alert('Should select an enemy first')
    }
    await props.contract.fight(bender, state.enemyId).catch((err) => {
        alert("Can't attack yet");
    });
    state.enemyId = null;
    updateBenders();
}

const setEnemy = (enemyId) => {
    state.enemyId = enemyId == state.enemyId ? null : enemyId;
}

const getMyBenders = () => {
    return state.benders.filter(b => b.owner == props.account.address);
}

updateBenders();
</script>

<template>
<h1 class="mb-5 text-2xl font-bold text-primary"> {{ msg }} </h1>
<Admin :contract="contract" v-if="state.admin" @created="updateBenders" :account="account" />
<List v-else :benders="state.benders" @attack="attack" @select="setEnemy" :selected="state.enemyId" />
<button class="mt-5 btn btn-primary" @click="state.admin = !state.admin"> 
    {{ state.toggleButtonText }}
</button>
</template>