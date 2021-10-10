<script setup>
import { computed } from "@vue/reactivity";

const props = defineProps({
    base: {
        type: Number
    },
    name: {
        type: String
    },
    modelValue: {
        type: Number
    },
    icon: {
        type: String
    },
    points: {
        type: Number,
        default: -1
    }
});

const emit = defineEmits(['update:modelValue'])

const nationColor = computed(() => {
    const elements = {
        air: 'bg-blue-300 border-blue-200',
        fire: 'bg-fire-600 border border-fire-400',
        earth: 'bg-green-500 border-green-400',
        water: 'bg-blue-600 border-blue-500'
    }
    return elements[props.element] || elements['fire']
})

const orbeColor = computed(() => {
    return "bg-gray-200 border-roti-200"
})

const decrement  = () => {
    if (props.modelValue > 0) {
        emit('update:modelValue', props.modelValue-1)
    }
}

const increment  = () => {
    if (props.points != -1 && !props.points) return
    emit('update:modelValue', props.modelValue+1)
}
</script>

<template>
<div>
    <div class="relative flex flex-col items-center justify-center w-56 px-2 py-5 rounded-md shadow-md h-72 ring ring-offset-base-100 ring-offset-2" 
    :class="[isSelected ? 'ring-red-400' : 'ring-transparent', nationColor ]"
    >
        <div class="flex items-center justify-around w-full">
            <button 
                @click="decrement()" 
                :disabled="modelValue == 0"
                class="border-2 btn hover:border-fire-map border-fire-map bg-fire hover:bg-fire-300"
            >
             <i class="fa fa-minus"></i> 
            </button>
            <div class="relative flex items-center justify-center w-24 h-24 p-1 mx-auto bg-white rounded-full avatar-picture">
                <div class="flex items-center justify-center w-full h-full mx-auto my-auto bg-gray-200 rounded-full text-7xl avatar-picture__container"
                    :style="bgImages"
                >
                    {{ base + modelValue }}
                </div>
                <span @click.stop="$emit('attack')" title="Attack" class="absolute z-40 flex items-center justify-center text-sm text-white border-2 border-white w-9 h-9 rounded-badge right-2 -bottom-2" :class="[orbeColor]">
                    <i :class="icon" />
                </span>
            </div>
            <button :disabled="!points" @click="increment()" class="border-2 btn hover:border-fire-map border-fire-map bg-fire-500 hover:bg-fire-300"> 
                <i class="fa fa-plus"></i>
            </button>
        </div>

        <h4 class="mt-2 font-bold text-white capitalize"> {{ name }} </h4>
    </div>
</div>
</template>
