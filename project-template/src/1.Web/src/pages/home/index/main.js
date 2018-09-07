import Vue from 'vue';
import elementModule from "@/static/js/importElement.js";
import '@/static/css/normalize.css';
import '@/static/css/common.css';
import '!style-loader!css-loader!less-loader!@/static/css/theme.less';
import '../css/index.css';

import common from "@/static/js/common.js";
import index from './index.vue';
import "@/static/css/element-extend.css";

Vue.use(common);

new Vue({
	el: '#index',
	render(h) {
		if(!globalConfig.webToken){
			return h("");
		}
		
		return h(index);
	}
});

