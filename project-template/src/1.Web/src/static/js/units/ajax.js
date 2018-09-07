import "babel-polyfill";
import axios from "axios";
import { errorTips } from "./commonTips.js";
import { request } from "https";

export default {
	install(Vue) {

		/*axios 方法初始化,封装*/
		axios.defaults.baseURL = globalConfig.baseUrl;
		axios.defaults.headers.common['Authorization'] = globalConfig.webToken;
		axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';
		axios.defaults.headers.delete['Content-Type'] = 'application/json';

		function error403(error) {
			if (!error || !error.response) {
				if (!error.response) {
					console.error(error);
				}

				return;
			}

			var status = error.response.status;
			if (status == 403 && this.$router) {
				this.$router.push("/403");
			} else if (status == 403) {
				window.location.href = "/403.html";
			}
		}

		//拦截器全局初始化
		axios.interceptors.response.use(function (response) {

			//对响应数据做些事
			return response;
		}, function (error) {

			var status = error.response ? error.response.status : "";
			if (status == 401 && location.href.indexOf(globalConfig.loginUrl) === -1) {
				window.location.href = globalConfig.loginUrl;
			} else if (status == 403) {

			} else if (status !== "") {
				var errorText1 = Vue.__t("ajaxCallError.0");
				var errorText2 = Vue.__t("ajaxCallError.1");
				let texts = [errorText1, errorText2];
				let option = {
					btns: [Vue.__t("ajaxCallErrorBtns.0"), Vue.__t("ajaxCallErrorBtns.1")],
					align: "left"
				}
				errorTips(texts, option);
			} else {
				console.warn(error)
			}

			//请求错误时做些事
			return Promise.reject(error);
		});

		/**success 只有Code===0时才会执行，其他都为error**/

		function ajaxMethod(url, data, success, error, method, requestConfig) {
			var _this = this,
				sParams = {},
				autoCloseLoading = true,
				sSuccess = success || function () { },
				sError = error || function () { };
			if (!url) {
				console.error("请输入链接");
				return;
			}

			var isUpdate = method === "post" || method === "put";

			if (isUpdate && !data) {
				console.error("请输入参数");
				return;
			}

			if (data) {
				if (typeof data == "function") {
					sSuccess = data;
					sError = success || sError;
				} else {
					sParams = data;
				}
			}

			var menuid = "";
			var route = this.$route;
			var routeName;
			if (route) {
				menuid = route.query.menuId;
				routeName = route.name;
			}

			if (sParams.autoOpenLoading !== false) {
				_this.$loadingOpen();
			} else {
				autoCloseLoading = false;
				delete sParams.autoOpenLoading;
			}

			let ajax;
			if (method === "request") {
				requestConfig.headers.MenuId = menuid;
				ajax = axios(requestConfig);
			} else {
				var config = {
					headers: {
						"MenuId": menuid
					}
				}
				var arrs = [];
				arrs.push(url);
				if (isUpdate) {
					_this.disabled !== undefined ? _this.disabled = true : "";
					arrs.push(sParams);
				} else if (method === "delete") {
					arrs.push({
						data: sParams
					});
				} else {
					config.params = sParams;
				}
				arrs.push(config);
				ajax = axios[method].apply(null, arrs);
			}

			ajax.then(function (data) {
				var res = data.data;
				if (res.Code === 0) {
					if (method === "get") {
						sSuccess.call(_this, res.Data, res);
					} else {
						sSuccess.call(_this, res, res);
					}

				} else {
					if (res.Code > 0) {
						var resData = res.Data;
						var resOption;
						if (typeof resData === "number") {
							resOption = {
								0: resData
							}
						} else if (Array.isArray(resData)) {
							resOption = {};
							resData.forEach(function (data, index) {
								resOption[index] = data;
							});
						}

						let errorMsg = _this.$t(routeName + ".code." + res.Code, resOption);
						errorMsg = errorMsg.indexOf("undefined.") === 0 ? res.Message : errorMsg;

						let errorDom = _this.$el.querySelector(".form-error-tips");
						if (isUpdate && _this.$waringTips && errorDom) {
							_this.$waringTips(errorMsg, errorDom);
						} else {
							Vue.msg(errorMsg);
						}
					}
					else {
						Vue.msg(_this.$t("ajaxCallError.1"));
					}

					sError.call(_this, res);
				}

				_this.disabled !== undefined ? _this.disabled = false : "";
				autoCloseLoading && _this.$loadingClose();
			}).catch(function (err) {
				error403.call(_this, err);
				sError.call(_this, err);
				_this.disabled !== undefined ? _this.disabled = false : "";
				autoCloseLoading && _this.$loadingClose();
			});
		}

		/**
		 * description get获取数据
		 * @params {String} url：链接(必填)
		 * @params {Object} params：参数(可选)
		 * @params {Function} success: 成功回调方法(可选)
		 * @params {Function} error：失败时的回调方法(可选)
		 * **/
		Vue.prototype.$get = function (url, params, success, error) {
			ajaxMethod.call(this, url, params, success, error, "get");
		}

		/**
		 * description 数据添加
		 * @params {String} url：链接(必填)
		 * @params {Object} data：参数(必填)
		 * @params {Function} success: 成功回调方法(可选)
		 * @params {Function} error：失败时的回调方法(可选)
		 * **/
		Vue.prototype.$post = function (url, data, success, error) {
			ajaxMethod.call(this, url, data, success, error, "post");

		}

		/**
		 * description 数据修改
		 * @params {String} url：链接(必填)
		 * @params {Object} data：参数(必填)
		 * @params {Function} success: 成功回调方法(可选)
		 * @params {Function} error：失败时的回调方法(可选)
		 * **/
		Vue.prototype.$put = function (url, data, success, error) {
			ajaxMethod.call(this, url, data, success, error, "put");

		}

		/**
		 * description 数据删除
		 * @params {String} url：链接(必填)
		 * @params {Object} data：参数(选填)
		 * @params {Function} success: 成功回调方法(可选)
		 * @params {Function} error：失败时的回调方法(可选)
		 * **/
		Vue.prototype.$delete = function (url, data, success, error) {
			ajaxMethod.call(this, url, data, success, error, "delete");

		}

		/**
		 * description 数据请求
		 * @params {Object} config：参数(必填)
		 * @params {Function} success: 成功回调方法(可选)
		 * @params {Function} error：失败时的回调方法(可选)
		 * **/
		Vue.prototype.$request = function (config, success, error) {
			ajaxMethod.call(this, config.url, config.data, success, error, "request", config);

		}

		/**axios方法封装结束**/

	}
}