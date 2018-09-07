window.globalConfig = {
	loginUrl: "/login.html",
	loginMode: webConfig.loginMode,
	userId: window.sessionStorage.getItem("userId"),
	baseUrl: webConfig.baseUrl,
	maxExportNumber: 2000,
	fileSize: 20 * 1024,
	fileUrl: "/api/plat/shares/upload"
}

window.isIE = function() {
	if(!!window.ActiveXObject || "ActiveXObject" in window || navigator.userAgent.indexOf("Edge") > -1)
		return true;
	else
		return false;
}

window.getPagerMixin = function() {
	return {
		data: function() {
			return {
				params: {
					pageIndex: 1,
					pageSize: 20,
					keyword: ""
				},
				pageTotal: 0,
				pageArr: [10, 20, 40, 60, 100],
				pageFunc: null,
				layout: "total, sizes, next, pager, prev",
				maxBodyHeight:0  //不规范，为了动态响应
			}
		},
		methods: {
			pageSizeChange: function(val) {
				this.params.pageSize = val;
				if(this.params.pageIndex !== 1) {
					this.params.pageIndex = 1;
				} else {
					if(typeof this.pageFunc === "function") {
						this.pageFunc();
					}
				}
			},
			pageCurrentChange: function(val) {
				this.params.pageIndex = val;
				if(typeof this.pageFunc === "function") {
					this.pageFunc();
				}
			}
		}
	}
}

window.getTabMixin = function() {
	return {
		mounted() {
			var tabList = this.$el.querySelectorAll('.func-btns>span');
			for(var i = 0; i < tabList.length; i++) {
				tabList[i].index = i;
				tabList[i].onclick = function(evt) {
					//evt.stopPropagation();
					for(var j = 0; j < tabList.length; j++) {
						if(this.index == j) {
							tabList[j].className += ' btn-active';
						} else {
							tabList[j].className = tabList[j].className.replace(/\s*btn\-active/g, '');
						}
					}
				}
			}
			/*document.addEventListener("click", function() {
				for(var i=0;i<tabList.length;i++){
					tabList[i].className=tabList[i].className.replace(/\s*btn\-active/g,'');
				}
			},false)*/
		}
	}
}