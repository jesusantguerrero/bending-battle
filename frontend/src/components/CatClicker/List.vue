<script setup> 
import { onMounted, toRefs } from 'vue';

const props = defineProps({
    contract: {
        type: Object,
        required: true
    }
});

onMounted(() => {
    const { contract } = toRefs(props);
    console.log(contract.value, "Here in list");
    contract.value.provider.on('NewCat', (cat) => {
        console.log(cat);
    });
})
</script>

<template>
    <div v-if="contract && contract.cats">
        <div v-for="cat in contract.cats">
            {{ cat }}
            Hola soy un gato
        </div>
    </div>
</template>