<script setup>
import List from "./List.vue"
import Admin from "./admin.vue"
import { computed, reactive, inject } from "vue";
import { watch } from "@vue/runtime-core";
import { ethers } from "ethers";

const props = defineProps({
    contract: {
        type: Object,
        required: true
    },
    account: {
        type: String,
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
    myBenders: computed(() => state.benders.filter((bender) => {
        console.log(bender.tokenId.toNumber(), bender.name, state.myBendersIndexes);
        return state.myBendersIndexes.includes(bender.tokenId.toNumber())
    })),
    enemies: computed(() => state.benders.filter((bender) => {
        return !state.myBendersIndexes.includes(bender.tokenId.toNumber())
    })),
});

const updateBenders = async () => {
    try {
        state.myBendersIndexes = (await props.contract.getBendersByOwner(props.account)).map(big => {
            return big.toNumber()
        });
        state.benders = await props.contract.getBenders();
    } catch (e) {
        console.dir(e);
    }
}

const useMessage = inject('useMessage');
const levelUp = async (bender) => {
    let levelUpFee = '0.001';
    levelUpFee = ethers.utils.parseEther(levelUpFee);
    useMessage('Upgrading bender power')
    const trx = await props.contract.levelUp(bender, { from: props.account, value: levelUpFee })
    .catch(() => {
        useMessage('Cant level up');
    });

    await trx.wait()
    updateBenders();
    useMessage('Bender upgraded');
}

const attack = async (bender) => {
    if(state.enemyId == null) {
        useMessage('Should select an enemy first')
    }
    const trx = await props.contract.fight(bender, state.enemyId).catch((err) => {
        useMessage('Cant attack yet');
        console.log(err);
    });

    if (trx) {
        useMessage("The fight has started");
        const receipt = await trx.wait().catch(() => {
            useMessage('Error in the attack');
        });

        const eventDelay = 3000; 
        receipt.events.forEach((event, index) => {
            setTimeout(() => {
                if (event.event == 'FightResult') {
                    const { damage, damageReceived, winner } = event.args;
                    useMessage(`${winner} won the fight. You has received ${damageReceived} and attack caused ${damage}`, eventDelay);
                    updateBenders();
                } else {
                    const { benderName, damage, message } = event.args;
                    useMessage(`${benderName} ${message} ${damage}`, eventDelay);
                }
            }, eventDelay * (index + 1));
        });
    }
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
    <List :benders="state.myBenders" @attack="attack" @levelUp="levelUp" :class="{'mr-20': state.isBattle}" />
    <List v-if="state.isBattle" :benders="state.enemies" @select="setEnemy" :selected="state.enemyId" />
</div>
<button 
    v-if="state.admin || (!state.isBattle && !state.hasBenders)"
    class="mt-5 btn btn-primary" 
    @click="state.admin = !state.admin" 
>
    {{ state.toggleButtonText }}
</button>

</template>