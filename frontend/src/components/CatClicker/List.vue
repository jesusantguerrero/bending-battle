<script setup> 
import CatCard from './CatCard.vue';

defineProps({
    cats: {
        type: Array,
        required: true,
    }
});
</script>

<template>
    <div class="flex justify-center mx-auto space-x-5">
        <CatCard 
            v-for="(cat, index) in cats" 
            :name="cat.name" 
            :url="cat.url" 
            :count="cat.clicks"
            class="transform cursor-pointer hover:scale-105"
            @click="$emit('click', index)"
        />
    </div>
</template>