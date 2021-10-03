<script setup>
import List from "./List.vue"
import Admin from "./admin.vue"
import { computed, reactive } from "@vue/reactivity";
import { watch } from "@vue/runtime-core";

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
    },
    mode: {
        type: String,
        default: 'dashboard'
    }
});

const state = reactive({
    benders: [],
    admin: false,
    enemyId: null,
    toggleButtonText: computed(() => state.admin ? "Back to List" : "Create bender"),
    myBendersIndexes: [],
    isBattle: computed(() => props.mode == 'battle'),
    hasBenders: computed(() => state.myBenders.length > 0),
    myBenders: computed(() => state.benders.filter((_bender, index) => {
        return state.myBendersIndexes.map(big => big.toNumber()).includes(index)
    })),
    enemies: computed(() => state.benders.filter((_bender, index) => {
        return !state.myBendersIndexes.map(big => big.toNumber()).includes(index)
    })),
});

const updateBenders = async () => {
    state.myBendersIndexes = await props.contract.getBendersByOwner(props.account);
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
watch(() => props.account, () => {
    updateBenders();
}, { immediate: true });
</script>

<template>
<h1 class="mb-5 text-2xl font-bold text-primary"> {{ msg }} </h1>
<Admin :contract="contract" v-if="state.admin" @created="updateBenders" :account="account" />
<div v-else class="flex">
    <List :benders="state.myBenders" @attack="attack" :class="{'mr-20': state.isBattle}" />
    <List v-if="state.isBattle" :benders="state.enemies" @select="setEnemy" :selected="state.enemyId" />
</div>
<button class="mt-5 btn btn-primary" @click="state.admin = !state.admin" v-if="!state.isBattle && !state.hasBenders"> 
    {{ state.toggleButtonText }}
</button>

</template>