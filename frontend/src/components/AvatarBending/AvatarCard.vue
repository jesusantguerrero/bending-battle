<template>
<div>
    <div class="relative w-56 px-2 py-5 border-2 border-white rounded-md h-72 ring ring-offset-base-100 ring-offset-0" 
    :class="[isSelected && 'ring-red-400', nationColor ]"
    >
        <span class="absolute top-0 left-0 flex items-center justify-center text-sm font-bold text-white rounded-tl-md w-9 h-9" :class="orbeColor">{{ bender.level }}</span>
        <span class="absolute z-40 flex items-center justify-center text-sm text-white border-2 border-white w-9 h-9 rounded-badge right-2 bottom-2" :class="[orbeColor]">{{ bender.level }}</span>
        <span class="block text-sm text-white">Exp: {{ bender.experience }}</span>
        <span class="block text-sm text-white">Health: {{ bender.health }}</span>
        <span class="block text-sm text-white">Wins: {{ bender.wins }}</span>
        <span class="block text-sm text-white">Losses: {{ bender.losses }}</span>
        <!-- <div class="absolute left-0 w-full transform bg-teal-400 cursor-pointer bottom-5 hover:scale-105" v-if="!isSelected">
            <div v-for="attack in attacks" class="px-2 py-2 text-xs text-white bg-blue-500 border-2 border-white rounded-btn" @click.stop="$emit('attack')">
               {{ attack.name }} {{ attack.element }}
            </div>
        </div> -->
    </div>
    <h4 class="mt-5"> {{ name }} </h4>
</div>
</template>

<script setup>
import { computed } from "@vue/reactivity";

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

    const attacks = computed(() => {
        return [props.bender.attack]
    })

    const nationColor = computed(() => {
        const elements = {
            air: 'bg-blue-300 ring-blue-200',
            fire: 'bg-fire-500 ring-fire-400',
            earth: 'bg-green-500 ring-green-400',
            water: 'bg-blue-600 ring-blue-500'
        }
        return elements[props.bender.element]
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