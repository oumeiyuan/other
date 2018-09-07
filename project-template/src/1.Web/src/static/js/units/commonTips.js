let timeout;
/**
 * description 系统报错提醒信息
 * @params {Array} texts：上下行显示的文本(必填)
 * @params {Object} option：选填，包括btns（两个按钮显示文本）、top（顶部距离）、width（宽度大小）、className（给dom添加的class）、align（第二行文字的对齐方式）、timeout(过时时间)
 * **/
export const errorTips = function (texts, option) {
	if (!Array.isArray(texts) || texts.length === 0) {
		console.warn("请输入文本数组！！！");
		return;
	}

	option = option || {};

	var dom = document.querySelector("body>.dialog-error");
	var clickFn = function (e) {
		if (!dom) {
			return;
		}

		if (e) {
			let nodeName = e.target.nodeName.toLocaleLowerCase();
			if (nodeName !== "i" && nodeName !== "span") {
				return;
			}
		}

		dom.outerHTML = "";
		dom.removeEventListener("click", clickFn);
		dom = null;
	}

	clearTimeout(timeout);
	timeout = setTimeout(function () {
		clickFn();
	}, option.timeout || 120000);

	if (!dom) {
		var div = document.createElement("div");
		let className = option.className ? (" " + option.className) : "";
		if (option.align) {
			className += " " + option.align;
		}
		div.className = "dialog-error" + className;
		let btnHtml = "";
		if (Array.isArray(option.btns)) {
			btnHtml = "<span>" + option.btns[0] + "</span>";
			if (option.btns[1]) {
				btnHtml = "<span>" + option.btns[1] + "</span>" + btnHtml;
			}
		}

		let style = "";
		if (option.top) {
			style = "top:" + option.top + ";"
		}
		if (option.width) {
			style += "width:" + option.width + ";"
		}
		if (style) {
			style = "style='" + style + "'";
		}
		let html = '<div class="dialog-error-box" ' + style + '>';
		html += '<i class="el-icon-close box-close-btn"></i>';
		html += '<div class="box-text1">' + texts[0] + '</div>';
		html += '<div class="box-text2">' + texts[1] + '</div>';
		html += '<div class="box-btns">' + btnHtml + '</div>';
		html += '</div>';

		div.innerHTML = html;
		document.body.appendChild(div);
		dom = div;
		dom.addEventListener("click", clickFn, false);
		return;
	}

	let className = "dialog-error";
	if (option.className) {
		className = className + " " + option.className;
	}

	if (option.align) {
		className = className + " " + option.align;
	}

	dom.className = className;

	if (option.top || option.width) {
		let domBox = dom.querySelector(".dialog-error-box");
		option.top && (domBox.style.top = option.top);
		option.width && (domBox.style.width = option.width);
	}

	if (Array.isArray(option.btns) && option.btns.length > 0) {
		let domBtns = dom.querySelector(".box-btns");
		let html;
		html = "<span>" + option.btns[0] + "</span>";
		if (option.btns[1]) {
			html = "<span>" + option.btns[1] + "</span>" + html;
		}
		domBtns.innerHTML = html;
	}

}

export const message = {
	install(Vue) {
		var clearMsgTime;
		/**
		 * msg 提示信息
		 * @params {String} text：提示的内容
		 * @params {Object} option：option.type:info、error、success
		 ***/
		var msg = function (text, option) {
			if (!text) {
				return;
			}

			option = option || {};

			var dom = document.querySelector(".dialog-msg-box");
			if (!dom) {
				let div = document.createElement("div");
				div.className = "dialog-msg";
				div.innerHTML = '<div class="dialog-msg-box dialog-msg-info"><i class="dialog-msg-flag-icon"></i><span class="dialog-msg-box-text"></span></div>';
				document.querySelector("body").appendChild(div);
				dom = div.querySelector(".dialog-msg-box");
			}

			var textDom = dom.querySelector(".dialog-msg-box-text");
			textDom.innerHTML = text;

			dom.className = dom.className.replace(/\s*?(dialog-msg-error|dialog-msg-success|dialog-msg-info)/g, "");
			if (option.type === "error") {
				dom.className = dom.className + " dialog-msg-error";
			} else if (option.type === "success") {
				dom.className = dom.className + " dialog-msg-success";
			} else {
				dom.className = dom.className + " dialog-msg-info";
			}

			if (option.width) {
				dom.style.width = option.width;
				let left = parseInt(option.width);
				dom.style.left="calc(50% - "+option.width.replace(left+"",left/2)+")";
			}

			var parentNode = dom.parentNode;
			parentNode.className = parentNode.className + " show";

			textDom.removeAttribute("style", "lineHeight");
			if (textDom.clientHeight > 48) {
				textDom.style.lineHeight = "24px";
			}

			clearTimeout(clearMsgTime);
			clearMsgTime = setTimeout(function () {
				parentNode.className = parentNode.className.replace(/\s*?show/g, "");
				parentNode = null;
			}, option.timeout || 2000);

			var eventFunc = function (e) {
				if (!parentNode) {
					return;
				}
				if (e) {
					e.stopPropagation();
				}

				clearTimeout(clearMsgTime);
				this.removeEventListener("click", eventFunc);
				parentNode.className = parentNode.className.replace(/\s*?show/g, "");
				parentNode = null;
			}

			parentNode.addEventListener("click", eventFunc, false);
		}

		/**
		 * successMsg 成功提示信息
		 * @params {String} text：提示的内容
		 * @params {Object} option：option.type:info、error、success
		 ***/
		Vue.successMsg = function (text, option) {
			option = option || {};
			option.type = "success";
			msg(text, option);
		}

		/**
		 * errorMsg 失败提示信息
		 * @params {String} text：提示的内容
		 * @params {Object} option：option.type:info、error、success
		 ***/
		Vue.errorMsg = Vue.msg = function (text, option) {
			option = option || {};
			option.type = "error";
			msg(text, option);
		}
	}
}