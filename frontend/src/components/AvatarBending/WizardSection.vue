<script setup>
defineProps({
    title: {
        type: String
    },
    subtitle: {
        type: String
    }
})

</script>

<template>
<div>
    <div class="mb-10">
        <h1 class="text-4xl font-bold text-fire-map-50 "> {{ title }}</h1>
        <h2 class="text-lg font-bold text-white">{{ subtitle }}</h2>
    </div>
    <slot></slot>
</div>
</template>