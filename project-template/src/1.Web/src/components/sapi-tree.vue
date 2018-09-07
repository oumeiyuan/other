<template>
	<sapi-tree :data="data" :default-expand-all="defaultExpandAll" :__domId="__domId" @expanded-click="expandedClick" :expanded-fn="expandedAddChild||expandedFunc" :indent="indent" :showTip="showTip" :noCache="noCache" :get-select-node="getSelectNode" :render-content="renderContent" :render-node-click="renderNodeClick" :props="props" :node-id="nodeId" @node-click="handlerClick">
	</sapi-tree>
</template>

<script>
	import tree from "@/components/base/base-tree.js";
	export default {
		data() {
			return {
				expandedFunc: null,
				param: {},
				paramId: "",
				__domId: null
			}
		},
		props: ["data", "indent", "defaultExpandAll", "renderContent", "getSelectNode", "renderNodeClick", "props", "nodeId", "expandedAddChild", "url", "params", "noCache", "showTip"],
		components: {
			"sapi-tree": tree
		},
		methods: {
			handlerClick(data, target) {
				//不使用emit的原因：这里需要返回值，如果使用emit的话，就返回不了值
				//this.$emit("on-click", data);

				var func = this.$listeners["on-click"];
				if(typeof func === "function") {
					return func.call(this.$parent, data, target);
				}
			},
			expandedClick(item, target, flag) {
				this.$emit("expanded-click", item, target, flag);
			},
			addChild(item, callback) {
				//每次都获取最新的参数
				var option = this.params || {};
				var params = {};
				for(var key in option) {
					if(key === "nodeIdKey") {
						params[this.params[key]] = item[this.props.value];
					} else {
						params[key] = option[key];
					}
				}

				this.$get(this.url, params, function(res) {
					if(!res) {
						return;
					}

					item[this.props.children] = res;
					if(typeof callback === "function") {
						callback();
					}
				});
			},
			//展开第一个节点
			defaultExpandNode() {
				if(!this.data || this.data.length === 0) {
					return;
				}

				let treeDom = window[this.__domId];
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
			}
		},
		created() {
			if(this.url && this.props && this.props.hasChild) {
				this.expandedFunc = this.addChild;
			}
			this.__domId = "tree-Id-" + Math.ceil(Math.random() * 10000);
		}
	}
</script>

<style lang="less">
	@import "~@/static/css/sapi-global";
	.sapi-tree {
		&ul>li {
			list-style: none;
		}
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