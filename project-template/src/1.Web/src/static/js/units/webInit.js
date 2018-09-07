export default {
	install(Vue) {
		Vue.prototype.$setTitle = function(name) {
			document.title = name;
		}

		//设置main模块里面的map
		function setBodyMap() {
			if(!this.$root.menuName) {
				return;
			}

			var dom = this.$el.querySelector(".main-header-map>.main-header-map-text");
			if(dom) {
				dom.innerText = this.$root.menuName || "";
			}
		}

		//从sessionStorage获取权限
		Vue.prototype.$init = function(option) {
			option = option || {};

			if(option.noPermission !== true) {
				//初始化权限
				var str = sessionStorage["permissions"];
				this.permissions = JSON.parse(str || "{}");
			}

			//初始化表格最大高度
			if(option.noTable !== true) {
				var clientHeight = document.querySelector(".index-body-box-content").clientHeight;
				option.subHeight = option.subHeight || 108;
				var maxHeight = clientHeight - option.subHeight;
				this.maxBodyHeight = maxHeight > 0 ? maxHeight : 100;
			}

			//设置map
			if(option.notMap !== true) {
				this.$nextTick(() => {
					setTimeout(() => {
						setBodyMap.call(this);
					}, 50);
				});
			}
		}
	}
}