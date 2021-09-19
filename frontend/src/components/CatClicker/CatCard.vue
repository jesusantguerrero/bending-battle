<template>
<div>
    <div class="avatar">
        <div class="w-24 h-24 rounded-box ring ring-primary ring-offset-base-100 ring-offset-2">
            <img :src="url">
        </div>
    </div>
    <h4> {{ name }} </h4>
    <p> {{ count }} </p>
</div>
</template>

<script setup>
    defineProps({
        name: {
            type: String,
        },
        url: {
            type: String,
        },
        count: {
            type: Number,
            default: 0,
        }
    })
</script>