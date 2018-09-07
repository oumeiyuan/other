import Vue from 'vue';

import '@/static/css/normalize.css';
import '@/static/css/common.css';
import common from "@/static/js/common.js";
import index  from "./403.vue";
import  "../css/403.css";

Vue.use(common);

var vm = new Vue({
    render(h){
    	return h(index);
    }
}).$mount("#index");
