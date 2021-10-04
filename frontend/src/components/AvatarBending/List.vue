<script setup> 
import AvatarCard from './AvatarCard.vue';

defineProps({
    benders: {
        type: Array,
        required: true,
    },
    selected: {
        type: [Number, null],
        default: null
    }
});
</script>

<template>
    <div class="flex justify-center mx-auto space-x-5">
        <AvatarCard
            v-for="(bender) in benders" 
            :name="bender.name" 
            :element="bender.element"
            :bender="bender"
            :is-selected="selected == bender.tokenId"
            class="cursor-pointer"
            @click="$emit('select', bender.tokenId)"
            @attack="$emit('attack', bender.tokenId)"
            @levelUp="$emit('levelUp', bender.tokenId)"
        />
    </div>
</template>