<script setup> 
import { reactive, toRefs } from 'vue';

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

const form = reactive({
    name: '',
    element: ''
});

const clearForm = () => {
    form.name = '';
    form.element = '';
};

const { contract } = toRefs(props);
const createBender = async () => {
    const trx = await contract.value.createRandomBender(form.name, form.element).catch(err => {
        alert(err.message);
    });
    trx.wait();
    emit('created');
    clearForm();
}
</script>

<template>
    <form @submit.prevent="createBender" class="max-w-2xl mx-auto space-y-2">
        <div class="form-control">
            <label class="label">
              <span class="label-text text-primary">Name</span>
            </label>
            <input type="text" class="input input-bordered input-primary" placeholder="name" required v-model="form.name">
        </div>
        <div class="form-control">
            <label class="label">
              <span class="label-text text-primary">Element</span>
            </label>
            <select type="text" class="input input-bordered input-primary" placeholder="Choose an element" required v-model="form.element">
                <option value="fire">Fire</option>
                <option value="water">Water</option>
                <option value="earth">Earth</option>
                <option value="air">Air</option>
            </select>
        </div>
        <button class="btn btn-primary"> Create my bender </button>
    </form>
</template>