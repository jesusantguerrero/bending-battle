<template>
<div>
    <div class="relative w-24 h-24 bg-primary rounded-box ring ring-primary ring-offset-base-100 ring-offset-2">
        <span class="text-sm text-white">Level: {{ bender.level }}</span>
        <span class="block text-sm text-white">Exp: {{ bender.experience }}</span>
        <span class="block text-sm text-white">Health: {{ bender.health }}</span>
        <div class="absolute w-full transform bg-teal-400 cursor-pointer -bottom-5 hover:scale-105">
            <div v-for="attack in attacks" class="px-2 py-2 text-xs text-white bg-blue-500 rounded-btn" @click="$emit('attack')">
               {{ attack.name }} {{ attack.element }}
            </div>
        </div>
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
        }
    })

    const attacks = computed(() => {
        return [props.bender.attack]
    })
</script>