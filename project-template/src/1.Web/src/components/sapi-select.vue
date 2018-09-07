<template>
	<div class="sapi-select" :class="{'readonly':readonly===''||readonly===true}">
		<div @click="handleClick" class="input-wrap" :class="{'delete-icon':clearIconFlag,active:visible}">
			<el-input readonly :placeholder="placeholderText" class="sapi-select-input" :value="input"></el-input>
			<i class="el-icon-arrow-down sapi-select-icon" :class="{'active':visible}"></i>
			<i class="icon-closer sapi-select-icon" @click.stop="clear" :class="{'active':visible}"></i>
		</div>

		<div ref="selectList" :id="selectId" class="sapi-select-box-wrap" :style="{left:sLeft,top:sTop,width:sWidth}" :class="{active:visible}">
			<i class="up-arrow set-position"></i>
			<div class="sapi-select-box-list" @mousedown.stop="">
				<sapi-scrollbar ref="scrollbar" :style="{maxHeight:maxHeight,height:height}">
					<component :is="currentView" :showTip="true" ref="treeRef" :expand-on-click-node="expandOnClickNode" :actived-id="nodeId" :lazy-load="lazyLoad" :select-after="getSelectNode" :data="datas" :props="treeProps" @on-click="treeClick"></component>
					<ul v-if="isTree!==true" class="sapi-select-box-list-ul">
						<slot :row="item" :$index="index" v-for="(item,index) in datas">
							<li class="label" :title="item[treeProps.label]" v-text="item[treeProps.label]" :class="{disabled:item[sDisabled]===true,active:item.active}" @click.stop="nodeClick(item)"></li>
						</slot>
					</ul>
				</sapi-scrollbar>
			</div>
		</div>

	</div>
</template>

<script>
	//window 点击事件方法集合
	var windowEventFns = {};
	import scrollbar from "@/components/sapi-scrollbar.vue";
	import importLocale from "@/static/js/importLocale.js";
	import { main, sapi } from "@/components/locale-component.js";
	export default {
		components: {
			"tree-nav": (resolve) => {
				require(['./tree'], resolve);
			},
			"sapi-scrollbar": scrollbar
		},
		data() {
			return {
				selectId: 'sapi-select-' + Math.ceil(Math.random() * 100000),
				input: "",
				datas: [],
				visible: false,
				currentView: "",
				nodeId: null,
				changeFlag: false,
				label: "label",
				val: "value",
				sDisabled: "",
				treeProps: {},
				isDefault: false,
				inInput: false,
				sLeft: null,
				sTop: null,
				sWidth: null,
				maxHeight: 0
			}
		},
		computed: {
			clearIconFlag() {
				if(!this.input) {
					return false;
				}

				if((this.clearable === "" || this.clearable === true) && this.visible === false) {
					return true;
				}

				return false;
			},
			placeholderText() {
				if(this.readonly === '' || this.readonly === true) {
					return "";
				}

				return this.placeholder || this.$t('selectOne');
			}
		},
		props: {
			value: [String, Boolean, Number],
			data: Array, //数据源
			props: Object, //数据源匹配的键值集合 label，value，disabled，children，hasChild，前两个为一般下拉列表必须，后两个为树型特有
			placeholder: String, //空值时提示的文字
			width: String, //宽度，带单位
			height: String, //下拉列表的高度，不能超过最高值，超过取最大值
			readonly: [Boolean, String], //是否只读，默认为可选择,
			clearable: [Boolean, String], //可否清除已选中值，默认不显示,
			matchFailText: String, //匹配失败时显示文本
			isTree: Boolean, //是否是树型下拉列表  ，下面的属性都是树的
			expandOnClickNode: { //点击label节点时是否展示子节点，默认true，默认展开或者收缩子节点
				type: Boolean,
				default: true
			},
			activeHasChild: { //点击有子类的节点时是否能选中，默认true能选中的
				type: Boolean,
				default: true
			},
			exceptId: [String,Array], //排除某个值不能选，或者某几个值不能选
			lazyLoad: Function, //展开时，调用该方法添加子节点,
			activeAfter:Function  //初始化选中之后触发的回调函数
		},
		
		methods: {
			beforEnter() {
				console.log(11)

			},
			clear(e) {
				this.inInput = false;
				//this.input = "";
				this.$emit("input", null);
				this.$emit("clear");
				this.close();
			},
			handleClick(e) {
				if(this.readonly === '' || this.readonly === true || this.visible === true) {
					return;
				}

				document.body.appendChild(this.$refs.selectList);

				//无数据时进行无数据初始化
				if(!this.data || this.data.length === 0) {
					if(this.datas.length === 0) {
						var data = {};
						data[this.treeProps.label] = this.$t('noData');
						data[this.treeProps.value] = null;
						data[this.sDisabled] = true;
						this.datas.push(data);
						this.isDefault = false;
					}
				}

				//初始化展开第一级树
				if(this.isTree === true && (this.nodeId === null || this.nodeId === undefined) && this.isDefault === false) {
					this.$refs.treeRef.defaultExpandNode();
					this.isDefault = true;
				}

				this.visible = true;

				let x = e.clientX - e.offsetX; //input节点的左边界线
				let y = e.clientY - e.offsetY; //input节点的上边界线

				let target = e.target;
				let parentNode;

				let className = target.className;
				if(className.indexOf("sapi-select-input") > -1) {
					parentNode = target;
				} else {
					parentNode = target.parentNode;
					//假如当前节点不是input节点，是图标节点
					if(className.indexOf("sapi-select-icon") > -1) {
						x -= target.offsetLeft;
						y -= target.offsetTop;
					}
				}

				let sTop = y + parentNode.clientHeight;
				//let dialog = document.querySelector(".dialog.current-dialog>.dialog-box");
				let maxHeight;
				this.upArrow = true;
				let top = 0;
				let subHeight = 40; //10(padding)+10(箭头)+20（预留空间）
				/*if(dialog) {
					top = parseInt(dialog.style.top) || 0;
					let height = dialog.clientHeight;
					maxHeight = height - (y - top) - parentNode.clientHeight - subHeight;
				} else {
					let clientHeight = document.body.clientHeight;
					maxHeight = clientHeight - y - parentNode.clientHeight - subHeight
				}*/

				let clientHeight = document.body.clientHeight;
				maxHeight = clientHeight - y - parentNode.clientHeight - subHeight

				//对列表的位置进行自动调整
				/*if(maxHeight < 200) {
					subHeight = 81; //36(tab)+30(margin)+5(预留空间)+10(箭头位置)
					let _maxHeight = y - top - subHeight;
					if(maxHeight < _maxHeight) {
						this.upArrow = false;
						maxHeight = _maxHeight > 295 ? 295 : _maxHeight;
						sTop = y - maxHeight - subHeight;
					}
				}*/

				this.maxHeight = maxHeight + "px";

				this.sTop = sTop + (this.top || 0) + "px";
				this.sLeft = x + (this.left || 0) + "px";
				this.sWidth = this.width || (parentNode.clientWidth + "px");
				if(this.isTree !== true && this.isDefault === false) {
					this.scrollToY();
					this.isDefault = true;
				}
				setTimeout(() => {
					this.addWindowClick();
				});
			},
			scrollToY() {
				this.$refs.scrollbar.scrollToY(0);
				setTimeout(() => {
					let dom = this.$el.querySelector(".sapi-select-box-list .label.active");
					if(!dom) {
						return;
					}
					if(dom.offsetTop < 51) {
						return;
					}
					this.$refs.scrollbar.scrollToY(dom.offsetTop);
				});

			},
			close() {
				this.visible = false;
			},
			//列表click
			nodeClick(item) {
				if(item[this.sDisabled] === true) {
					return false;
				}

				var data = {};
				for(var key in item) {
					if(key !== "active") {
						data[key] = item[key];
					}
				}

				var datas = this.datas;
				for(var i = 0, ii = datas.length; i < ii; i++) {
					datas[i].active = false;
				}

				item.active = true;

				this.input = data[this.treeProps.label];
				this.changeFlag = true;
				this.$emit("input", data[this.treeProps.value]);
				this.$emit("change", data);
				//this.close();
				this.removeWindowClick();
			},
			//树的click
			treeClick(data, target) {
				//禁止点击时
				if(data[this.sDisabled] === true) {
					return false;
				}

				if(this.activeHasChild === false) {
					//限制有子节点的节点选中
					let childs = data[this.treeProps.children];
					let isStop = childs && childs.length > 0;
					if(isStop === false) {
						isStop = data[this.treeProps.hasChild];
					}
					if(isStop === true) {
						return false;
					}
				}

				var nodeId = data[this.treeProps.value];
				let exceptId=this.exceptId;
				//某几个值不能选
				if(exceptId){
					if(typeof exceptId ==="string"&& nodeId ===exceptId){
						Vue.errorMsg(this.$t('sapiSelect.currentNodeNotBeSelected'));
						return false;
					}else if(Array.isArray(exceptId)&&exceptId.indexOf(exceptId)>-1){
						Vue.errorMsg(this.$t('sapiSelect.currentNodeNotBeSelected'));
						return false;
					}
				}

				this.input = data[this.treeProps.label];
				this.changeFlag = true;
				this.nodeId = nodeId;
				this.$emit("input", nodeId);
				this.$emit("change", data);
				//this.close();
				this.removeWindowClick();
			},
			mousewheel(e) {
				e.preventDefault();
			},
			getSelectNode(item) {
				this.input = item[this.treeProps.label];
				if(this.input === undefined) {
					this.input = this.matchFailText || "";
					this.$emit("matchFailure");
					return;
				}

				if(typeof this.activeAfter==="function"){
					this.activeAfter(item);
				}
			},
			init() {
				var datas = this.datas = this.data || [];
				var value = this.value;

				this.isDefault = false;
				//常规列表初始化
				if(this.isTree !== true) {
					if(datas.length === 0) {
						return;
					}
					var label = this.treeProps.label;
					var val = this.treeProps.value;
					var flag = false;
					for(var i = 0, ii = datas.length; i < ii; i++) {
						//当前选中的值
						if(value === datas[i][val]) {
							this.input = datas[i][label];
							datas[i].active = true;
							flag = true;
						} else {
							datas[i].active = false;
						}
					}
					if(flag === false && value !== null) {
						this.input = "";
						this.$emit("matchFailure");
					}
				} else {
					//显示树型下拉列表组件
					this.currentView = "tree-nav";
				}
			},
			//移除当前注册的隐藏下拉列表事件
			removeWindowClick() {
				let fn = windowEventFns[this.vmIndex];
				if(typeof fn === "function") {
					fn();
				}
			},
			//注册隐藏下拉列表事件
			addWindowClick() {
				let _this = this;
				!windowEventFns[this.vmIndex] && (windowEventFns[_this.vmIndex] = function() {
					document.body.removeEventListener("mousedown", windowEventFns[_this.vmIndex]);
					_this.close();
				});
				document.body.addEventListener("mousedown", windowEventFns[this.vmIndex], false);
			},
		},
		watch: {
			data(val) {
				this.datas = val;
				if(this.value) {
					this.init();
				}
			},
			value(val) {
				this.nodeId = this.value;
				//$emit() 会触发这里更新，但是这里不想执行init
				if(this.changeFlag === false && this.data.length > 0) {
					this.init();
				} else {
					this.changeFlag = false;
				}

				if(val === undefined || val === null) {
					this.input = '';
				}
			}
		},
		created() {
			!Vue.toLocale && Vue.use(importLocale);
			let obj = Vue.extendLangs(main, sapi);
			Vue.toLocale(obj);

			this.vmIndex = Math.ceil(Math.random() * 1000);
			var props = this.props || {};
			this.sDisabled = props.disabled || "select-disabled";
			this.treeProps = {
				label: props.label,
				value: props.value || props.nodeKey,
				disabled: this.sDisabled,
				children: props.children,
				hasChild: props.hasChild
			}
			this.init();
		},
		beforeDestroy() {
			windowEventFns[this.vmIndex] = null;
			if(window[this.selectId]) {
				window[this.selectId].outerHTML = "";
			}
		}
		
	}
</script>
<style lang="less">
	@import "~@/static/css/sapi-global";
	.sapi-select {
		position: relative;
		.el-input__inner {
			padding-right: 22px;
		}
		.el-input__inner[readonly] {
			cursor: pointer;
		}
		.input-wrap {
			position: relative;
		}
		.sapi-select-icon {
			position: absolute;
			right: 10px;
			top: 8px;
			width: 13px;
			height: 13px;
			padding-left: 2px;
			line-height: 13px;
			cursor: pointer;
			&.icon-closer {
				display: none;
			}
		}
		.input-wrap {
			position: relative;
			.el-icon-arrow-down {
				transition: all 0.3s;
			}
			.el-icon-arrow-down.active {
				transform: rotate(180deg);
			}
			&.delete-icon:hover {
				.icon-closer {
					display: block;
				}
				.el-icon-arrow-down {
					display: none;
				}
			}
			&.active .el-input__inner,
			&:hover .el-input__inner {
				border-color: @active-color;
			}
		}
		.sapi-select-box-wrap-input {
			position: relative;
			clear: both;
			height: 38px;
			cursor: pointer;
			overflow: hidden;
		}
	}
	
	.sapi-select-box-wrap {
		display: none;
		position: absolute;
		z-index: 199;
		min-width: 200px;
		padding-top: 12px;
		&.active {
			display: block;
		}
		.set-position {
			top: 3px;
			left: 35px;
		}
		.sapi-select-box-list-ul>li {
			padding: 0px 20px;
			position: relative;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
			height: 34px;
			line-height: 34px;
			box-sizing: border-box;
			cursor: pointer;
		}
		.sapi-select-box-list-ul>li:hover {
			background-color: #f5f7fa;
			color: @active-color;
		}
		.sapi-select-box-list-ul .active,
		.sapi-select-box-list-ul :active {
			color: @active-color;
		}
		.sapi-select-box-list-ul .disabled {
			color: @disable-color;
			cursor: not-allowed;
			&:hover {
				color: @disable-color;
				background-color: @background-color;
			}
		}
		&.readonly .sapi-select-icon,
		&.readonly .sapi-select-box {
			display: none;
		}
		&.readonly .el-input__inner[readonly] {
			cursor: default;
		}
		.sapi-tree {
			.tree-node-icon,
			.tree-node-text,
			.tree-node-label {
				height: 34px;
				line-height: 34px;
			}
			.tree-node>.tree-node-text {
				overflow: hidden;
			}
			.tree-node-text:hover {
				background: #f5f7fa;
			}
			.tree-node-text.active,
			.tree-node-text:active {
				color: @active-color;
				background: @background-color;
			}
			.is-disabled>.tree-node-text {
				background-color: @background-color;
				&:hover {
					background-color: @background-color;
				}
				&>.tree-node-label {
					color: @disable-color;
					cursor: not-allowed;
				}
			}
		}
		.sapi-select-box-list {
			padding: 5px 0px;
			border-radius: @border-radius;
			background-color: @background-color;
			#main-box-shadow();
		}
	}
	
	#arrow-fn();
</style>