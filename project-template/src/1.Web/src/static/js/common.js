import extendConfig from "@/extend/extend-config.js";
import importLocale from "@/static/js/importLocale.js";
import * as lang from "./units/baseLang.js";
import formatMixin from "@/components/sapi-directive-input.js";
import loading from "./units/loading.js";
import ajax from "./units/ajax.js";
import { message } from "./units/commonTips.js";
import webInit from "./units/webInit.js";
import "./units/globalInit.js";

extendConfig.init(globalConfig);

//获取Token
function getAccToken() {
	if(location.href.indexOf(globalConfig.loginUrl) > -1) {
		return;
	}

	//允许其他链接没有token，不经过登录口进入系统（单点登录使用）
	if(webConfig.ssoUrl) {
		//单个校验
		if(typeof webConfig.ssoUrl === "string" && location.href.indexOf(webConfig.ssoUrl) > -1) {
			return;
		}
		//多个校验
		else if(Array.isArray(webConfig.ssoUrl) && webConfig.ssoUrl.indexOf(location.host+location.pathname) > -1) {
			return;
		}
	}

	var ws = window.sessionStorage;
	if(ws.getItem("access_token") && ws.getItem("baseUrl") === globalConfig.baseUrl) {
		return ws.getItem("token_type") + ' ' + ws.getItem("access_token");
	}

	ws.clear();
	window.location.href = globalConfig.loginUrl + "?time=" + new Date().getTime();
}

globalConfig.webToken = getAccToken();

var plugin = {};
plugin.install = function(Vue, options) {
	//注册全局性的Vue
	window.Vue = Vue;
	Vue.mixin(formatMixin);

	//注册一个基础的语言包，这样系统可以跑通，不用每个组件再进行语言包注册
	!Vue.toLocale && Vue.use(importLocale);
	let langs = Vue.extendLangs(lang.main, lang.sapi, lang.base);
	Vue.toLocale(langs);

	//loading 图标初始化
	Vue.use(loading);

	//常用方法封装

	//获取后台方法初始化
	Vue.use(ajax);

	//提示信息初始化
	Vue.use(message);

	//list页面常用初始化方法
	Vue.use(webInit);

	/**
	 * $getUrlParams 获取url参数
	 * @params {String} name：获取的参数名称
	 ***/
	Vue.prototype.$getUrlParams = function(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
		var r = window.location.search.substr(1).match(reg);
		if(r != null) return(r[2]);
		return null;
	}

	/**
	 * $getHashParams 获取路由的参数
	 * @params {String} name：获取的参数名称
	 ***/
	Vue.prototype.$getHashParams = function(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
		var arrs = window.location.hash.split("?");
		if(arrs.length < 2) {
			return "";
		}

		var r = arrs[1].match(reg);
		if(r != null) return(r[2]);
		return "";
	}

	//重写时间转换为字符串方法
	Date.prototype.toJSON = function() {
		return this.getFullYear() + "-" + (this.getMonth() + 1) + "-" + this.getDate() + " " + this.getHours() + ":" + this.getMinutes() + ":" + this.getSeconds();
	}

	/**
	 * dateFormat 时间转换格式
	 * @params {String} fmt：时间格式
	 * @params {String|Date} date：时间字符串、时间
	 * description 使用实例：如果做实体内使用，this.$dateFormat("yyyy-MM-dd hh:mm:ss",date)  实体外调用：Vue.dateFormat("yyyy-MM-dd hh:mm:ss",date)
	 ***/
	Vue.dateFormat = Vue.prototype.$dateFormat = function(fmt, date) {
		if(!date || !fmt) {
			return "";
		}

		if(!date.getFullYear) {
			if(date.indexOf("1753") > -1) {
				return "";
			}

			date = date.replace("T", " ").replace(/-/g, "/").replace((/\.\d+(\+.+)?$/), "");
			date = new Date(date);
		} else if(date.getFullYear() === 1753) {
			return "";
		}

		var o = {
			"M+": date.getMonth() + 1, //月份 
			"d+": date.getDate(), //日 
			"h+": date.getHours(), //小时 
			"m+": date.getMinutes(), //分 
			"s+": date.getSeconds() //秒 
		};

		if(/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
		for(var k in o)
			if(new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
		return fmt;
	}

	/**
	 * $checkedASCII检查是否有中文字符
	 * **/
	Vue.prototype.$checkedASCII = function(val) {
		if(!val) {
			return true;
		}

		/*var reg=new RegExp()*/

		return /^[\x00-\x7F]+$/.test(val);
	}

	/**
	 * 判断数据类型
	 * @params {Object|Number|Array...} 所有类型数据
	 * @return {object|number|array...}
	 * **/
	Vue.prototype.$typeof = function(val) {
		return Object.prototype.toString.call(val).slice(8, -1).toLowerCase();
	}

}

export default plugin;