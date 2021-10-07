import { reactive } from "vue";

const AppState = reactive({
    bender: null,
    level: {
        max: 100,
        min: 0,
    }
})

export default AppState;