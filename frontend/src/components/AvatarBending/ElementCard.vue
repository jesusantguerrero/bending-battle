<script setup>
import { computed } from "@vue/reactivity";;

const props = defineProps({
        name: {
            type: String,
        },
        element: {
            type: String,
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

    const nationColor = computed(() => {
        const elements = {
            air: 'bg-blue-300 border-blue-200',
            fire: 'bg-fire-500 border-fire-400',
            earth: 'bg-green-500 border-green-400',
            water: 'bg-blue-600 border-blue-500'
        }
        return elements[props.bender.element]
    })

    const bgImages = computed(() => {
        const bgImages = {
            fire: '/fire-bg.jpg',
            earth: '/earth-bg.jpg',
            air: '/air-bg.jpg',
            water: '/water-bg.jpg',
        };

        const bgImage = bgImages[props.bender.element]

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

        return bgImages[props.bender.element]
    })

    const orbeColor = computed(() => {
        const elements = {
            air: 'bg-blue-400 border-gray-200',
            fire: 'bg-fire-400 border-fire-200',
            earth: 'bg-green-400 border-roti-300',
            water: 'bg-blue-400 border-blue-700'
        }
        return elements[props.bender.element]
    })
</script>

<template>
<div>
    <div class="relative flex flex-col justify-center w-56 px-2 py-5 overflow-hidden rounded-md shadow-md h-72 ring ring-offset-base-100 ring-offset-2" 
    :class="[isSelected ? 'ring-red-400' : 'ring-transparent', nationColor ]"
    >
        <div class="flex items-center justify-center p-1 mx-auto bg-white rounded-full w-28 h-28 avatar-picture">
            <div class="w-full h-full mx-auto my-auto bg-gray-200 rounded-full avatar-picture__container"
                :style="bgImages"
            >
            </div>
        </div>
        <h4 class="mt-2 font-bold text-white"> {{ name }} </h4>

        <span class="absolute top-0 left-0 flex items-center justify-center w-full text-sm font-bold text-white rounded-tl-md h-9" :class="orbeColor">
            Element
        </span>
        <span class="absolute z-40 flex items-center justify-center text-sm text-white border-2 border-white w-9 h-9 rounded-badge right-2 bottom-2" :class="[orbeColor]">
            <i :class="bendingIcon" />
        </span>
        
        <div class="flex flex-col items-center justify-center p-3 mt-2 bg-gray-800 rounded-md rounded-br-lg" v-if="bender.HP">
            <div class="flex space-x-2" v-if="bender.HP">
                <span class="block text-sm text-white">Exp: {{ bender.HP }}</span>
                <span class="block text-sm text-white">Health: {{ bender.health }}</span>
            </div>
            <div class="flex space-x-2" v-if="bender.record">
                <span class="block text-sm text-white">Wins: {{ bender.record.wins }}</span>
                <span class="block text-sm text-white">Losses: {{ bender.record.losses }}</span>
            </div>
        </div>
    </div>
</div>
</template>
