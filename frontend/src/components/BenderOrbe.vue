<script setup>
import { computed } from "@vue/reactivity";;

const props = defineProps({
    name: {
        type: String,
    },
    level: {
        type: Object
    },
    bender: {
        type: Object,
        required: true,
    },
    isSelected: {
        type: Boolean,
        default: false,
    }
})

const element = computed(() => {
    return props.bender ? props.bender.element : 'air';
})

const nationColor = computed(() => {
    const elements = {
        air: 'bg-blue-300 border-blue-200',
        fire: 'bg-fire-500 border-fire-400',
        earth: 'bg-green-500 border-green-400',
        water: 'bg-blue-600 border-blue-500'
    }
    return elements[element.value]
})

const bgImages = computed(() => {
    const bgImages = {
        fire: '/fire-bg.jpg',
        earth: '/earth-bg.jpg',
        air: '/air-bg.jpg',
        water: '/water-bg.jpg',
    };

    const bgImage = bgImages[element.value]

    return {
        backgroundImage: `url(${bgImage})`,
        backgroundSize: 'cover',
        backgroundPosition: 'center', 
    }
})

const bendingIcon = computed(() => {
    const bgImages = {
        fire: 'fas fa-fire',
        water: 'fas fa-water',
        air: 'fas fa-wind',
        earth: 'fas fa-feather-alt',
    };

    return bgImages[element.value]
})

const orbeColor = computed(() => {
    const elements = {
        air: 'bg-blue-400 border-gray-200',
        fire: 'bg-fire-400 border-fire-200',
        earth: 'bg-green-400 border-roti-300',
        water: 'bg-blue-400 border-blue-700'
    }
    return elements[element.value]
})
</script>

<template>
<div class="relative w-full h-full p-1 mt-2 text-white border-4 cursor-pointer rounded-badge bg-opacity-60" :class="nationColor">
    <div class="w-full h-full rounded-badge opacity-70" :style="bgImages">

    </div>
    <div class="absolute flex w-full -bottom-5">
        <div class="w-full py-1 border-2 rounded-b-box" v-if="bender" :class="orbeColor">
            {{ bender.HP }} / {{ level.max }}
        </div>
    </div>
    <div class="absolute text-white top-7 -right-28">
        <div class="text-3xl" v-if="bender">
            {{ bender.name }}     
        </div>
    </div>
</div>
</template>