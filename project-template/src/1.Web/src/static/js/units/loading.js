

export default {
	install(Vue) {
		var clearTime;
		
		
		/**
		 * $loadingOpen 延迟加载打开
		 ***/
		Vue.prototype.$loadingOpen = function(option) {
			var loadElem = document.querySelector("body>div.simple-loading");

			if(!loadElem) {
				var div = document.createElement("div");
				div.className = "simple-loading";
				document.body.appendChild(div);
				loadElem = document.querySelector("body>div.simple-loading");
				var sysConfig = JSON.parse(localStorage["sysConfigSet"] || "{}");
				if(sysConfig.loading) {
					loadElem.style.backgroundImage = "url(" + sysConfig.loading + ")";
				}
			}

			loadElem.className = loadElem.className.replace(/\s*?hide(?=\s*?)?/g, "");
		}

		/**
		 * $loadingClose 延迟加载关闭  页面加载时load图标，需要在页面添加标签，这里只是关闭load图标，作用是，做html、js等没有加载完成之前就显示该图标
		 ***/
		Vue.prototype.$loadingClose = function() {
			clearTimeout(clearTime);
			clearTime = setTimeout(function() {
				var dom = document.querySelector("body>div.simple-loading");
				if(dom) {
					var className = dom.className;
					if(!(className.search(/\b(hide)\b/i) > -1)) {
						dom.className = className + " hide";
					}
				}
			}, 100);
		}

		//这个与上面的有些不一样，上面的一般是数据加载或者数据提交的时候显示loadding，数据获取完毕会关闭，而这里的不同就在于此，只能自己关闭或者打开
		Vue.prototype.$loading = function(flag) {
			var loadElem = document.querySelector("body>div.simple-loading");

			if(!loadElem) {
				var div = document.createElement("div");
				div.className = "simple-loading";
				document.body.appendChild(div);
				loadElem = document.querySelector("body>div.simple-loading");
			}

			if(flag === true) {
				loadElem.className = loadElem.className + " show";
			} else {
				loadElem.className = loadElem.className.replace(/\s*?show(?=\s*?)?/g, "");
				if(loadElem.className.search(/\b(hide)\b/i) === -1) {
					dom.className = className + " hide";
				}
			}
		}
	}

}