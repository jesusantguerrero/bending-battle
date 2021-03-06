<script setup> 
import { reactive, toRefs, computed, ref } from 'vue';
import AbilityCard from './AbilityCard.vue';
import WizardSection from './WizardSection.vue';
import ElementCard from './ElementCard.vue';

const props = defineProps({
    contract: {
        type: Object,
        required: true
    },
    account: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['created'])

const elements = {
    air: {
        name: "Air",
        element: "air"
    },
    water: {
        name: "Water",
        element: "water",

    }, 
    earth: {
        name: "Earth",
        element: "earth"
    },
    fire: {
        name: "Fire",
        element: "fire"
    }
};

const form = reactive({
    name: '',
    element: '',
    abilities: {
        strength: 0,
        speed: 0,
        agility: 0,
        chi: 0
    }
});

const clearForm = () => {
    form.name = '';
    form.element = '';
};

const points = 15;
const pointsLeft = computed(() => {
    return points - Object.values(form.abilities).reduce((sum,  num) => sum+num, 0) ;
})

const { contract } = toRefs(props);

const bendingAttributes = ref({}); 
const setElement = async (element) => {
    const attributes = await contract.value.getBending(element, form.abilities);
    bendingAttributes.value = {
        strength: attributes.strength.toNumber(),
        speed: attributes.speed.toNumber(),
        agility: attributes.agility.toNumber(),
        chi: attributes.chi,
    }
    form.element = element
}

const isLoading = ref(false);
const createBender = async () => {
    if (isLoading.value) return;
    isLoading.value = true;
    const trx = await contract.value.createRandomBender(form.name, form.element, form.abilities)
    .catch(err => {
        console.log(err);
        const message = err?.message || err.data?.message;
        alert(message);
    });
    if (trx) {
        await trx.wait();
        emit('created');
        clearForm();
    }
    isLoading.value = false;
}
</script>

<template>
    <div>
        <WizardSection 
            v-if="!form.element"
            title="Select an element"
            subtitle="Each element would define your initial attributes and weapon"
        >
            <div class="flex space-x-5">
                <ElementCard
                    v-for="(element, elementName) in elements"
                    :name="element.name"
                    :bender="element"
                    @click="setElement(elementName)"
                    class="transform cursor-pointer hover:scale-105"
                />
            </div>
        </WizardSection>

        <WizardSection
            v-if="form.element && pointsLeft"
            title="Set your abilities"
            :subtitle="`You've got ${pointsLeft } remaining`"
        >
            <div class="flex space-x-5">
                <template 
                    v-for="(ability, name) in form.abilities"
                    :key="name"
                >
                    <AbilityCard
                        :base="bendingAttributes[name]"
                        :name="name"
                        :modelValue="ability"
                        :points="pointsLeft"
                        @update:modelValue="form.abilities[name]=$event"
                    />            
                </template>
            </div>
        </WizardSection>

        <WizardSection 
            v-if="form.element && !pointsLeft"
            title="The name of your bender"
        >
            <form @submit.prevent="createBender" class="max-w-2xl mx-auto space-y-2">
                <div class="form-control">
                    <label class="label">
                    <span class="label-text text-primary">Name</span>
                    </label>
                    <input type="text" class="text-gray-300 input dark:text-white input-bordered input-primary" placeholder="name" required v-model="form.name">
                </div>
                <button class="btn btn-primary"
                    :disabled="isLoading"
                > 
                    <i class="fa fa-spin fa-spinner" v-if="isLoading"></i>
                    Create my bender 
                 </button>
            </form>
        </WizardSection>
    </div>
</template>