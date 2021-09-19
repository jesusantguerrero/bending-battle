<script setup> 
import { reactive, toRefs } from 'vue';

const props = defineProps({
    contract: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['cat-added'])

const form = reactive({
    name: '',
    url: ''
});

const clearForm = () => {
    form.name = '';
    form.url = '';
};

const { contract } = toRefs(props);
const addCat = async () => {
    const trx = await contract.value.createRandomCat(form.name, form.url);
    trx.wait();
    emit('cat-added');
    clearForm();
}
</script>

<template>
    <form @submit.prevent="addCat" class="max-w-2xl mx-auto space-y-2">
        <div class="form-control">
            <label class="label">
              <span class="label-text text-primary">Name</span>
            </label>
            <input type="text" class="input input-bordered input-primary" placeholder="name" required v-model="form.name">
        </div>
        <div class="form-control">
            <label class="label">
              <span class="label-text text-primary">Photo URL</span>
            </label>
            <input type="text" class="input input-bordered input-primary" placeholder="url" required v-model="form.url">
        </div>
        <button class="btn btn-primary"> Add Cat </button>
    </form>
</template>