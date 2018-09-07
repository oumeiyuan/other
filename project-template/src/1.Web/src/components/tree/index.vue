<template>
	<div class="sapi-tree" @click="treeClick"></div>
</template>

<script>
	import tree from "./render.js";
	export default {
		mixins: [tree],
		props: {
			data: Array, //数据源
			props: { //数据源结构映射对象
				type:Object,
				default:function () {
					return {
						label:null,
						value:null,
						children:null,
						disabled:null,
						hasChildren:null
					}
				}
			}, 
			activedId: String, //初始化选中节点

			indent: [String, Number], //缩进距离
			defaultExpandAll: Boolean, //是否展开所有的子节点
			renderContent: Function, //渲染函数  这里有两种返回方式，第一种就是直接返回html字符串，另外一种是返回一个对象，比如{html:'<div></div>',vm:this}  这里vm需要返回的原因是：renderContent距离sapi-tree太远，难以定位，（假如renderContent定义跟sapi-tree引入不在同一个组件，必须使用该方式）
			lazyLoad: Function, //按需加载调用此函数
			showTip: Boolean, // 鼠标经过时是否显示提示文字（为原生的提示）
			selectAfter: Function, //初始化选中之后的回调函数
			expandOnClickNode:{//是否在点击节点的时候展开或者收缩节点，如果为 false，则只有点箭头图标的时候才会展开或者收缩节点， 默认值为 false。
				type:Boolean,
				default:false
			}, 
			uniqueOpened:{  //是否只保持一个顶层节点展开
				type:Boolean,
				default:false
			}

			/*nodeId: String, //已弃用，使用activedId代替
			getSelectNode: Function, //已弃用，使用selectAfter代替
			url: String, //已弃用，使用链接获取子节点
			params: Object, //已弃用，配合url获取子节点*/
		},
		data() {
			return {
				isAddChild:false,
				isRender: true, //是否需要进行渲染，得数据源改变的情况下才会进行渲染
				$_activedId: null,  //节点选中时进行保存的ID，作用，避免activedId再次进行初始化
			}
		},
		methods: {
			handlerClick(item, target) {
				//不使用emit的原因：这里需要返回值，如果使用emit的话，就返回不了值
				//this.$emit("on-click", data);

				var func = this.$listeners["on-click"];
				if(typeof func === "function") {
					return func.call(this.$parent, item, target);
				}
			},
			expandedClick(item, target, flag) {
				this.$emit("expanded-click", item, target, flag);
			},
			addChild(item, callback) {
				if(typeof this.lazyLoad === "function") {
					let _this = this;
					this.lazyLoad(item, function(res) {
						if(!res) {
							return;
						}
						item[_this.props.children] = res;
						callback();
						_this.isAddChild=true;
						_this.$nextTick(function(){
							this.isAddChild=false;
						});
					});
				}
			},
			//展开第一个节点
			defaultExpandNode() {
				if(!this.data || this.data.length === 0) {
					return;
				}

				let treeDom = this.$el;
				if(!treeDom) {
					return;
				}

				let data = this.data[0];
				let childs = data[this.props.children];
				let hasChild = false;
				if(childs && childs.length > 0 || data[this.props.hasChild]) {
					hasChild = true;
				}

				if(hasChild === false) {
					return;
				}

				let iconDom = treeDom.querySelector(".sapi-tree>ul>li:not(.tree-node-no-child)>.tree-node-text>.tree-node-icon");
				if(iconDom) {
					iconDom.click();
				}
			},
			init() {
				if(this.isRender === true) {
					this.render();
				}

				this.$_activedId = this.activedId;
				this.setActiveNode();
				this.$nextTick(() => {
					this.isRender = false;
				});
			}
		},
		watch: {
			data() {
				if(this.isAddChild===true){
					return;
				}
				
				this.isRender = true;
				this.init();
			},
			activedId(val) {
				//$_activedId当前已选中的节点
				if(this.isRender !== true && val !== this.$_activedId) {
					this.init();
				}
			}
		},
		created() {
			this.$nextTick(function() {
				this.isRender = true;
				this.init();
			});
		}
	}
</script>

<style lang="less">
	@import "~@/static/css/sapi-global";
	.sapi-tree {
		.tree-node-icon,
		.tree-node-text,
		.tree-node-label {
			height: 36px;
			line-height: 36px;
		}
		.tree-node-text {
			vertical-align: middle;
		}
		.tree-node-text:hover {
			.tree-node-icon {
				color: #999;
			}
			background-color:#ededed;
		}
		.tree-node-text.active {
			background-color: #f8f8f8;
			color: @active-color;
		}
		.tree-node-icon {
			display: block;
			float: left;
			width: 24px;
			padding-left: 4px;
			font-size: 20px;
			color: #ccc;
			cursor: pointer;
			transform: translateY(1px);
		}
		.tree-node-expanded>.tree-node-text>.tree-node-icon {
			transform: rotate(90deg) translateX(-2px);
		}
		.tree-node-label {
			float: left;
			width: calc(100% - 28px);
			white-space: nowrap;
			text-overflow: ellipsis;
			cursor: pointer;
			overflow: hidden;
		}
		.tree-node-no-child>.tree-node-text>.tree-node-icon {
			display: none;
		}
		.tree-node-no-child>.tree-node-text>.tree-node-label {
			margin-left: 25px;
		}
		.tree-node-childs {
			display: none;
		}
		.tree-node-no-child>.tree-node-childs {
			display: none;
		}
		.tree-node-expanded>.tree-node-childs {
			display: block;
		}
	}
</style>