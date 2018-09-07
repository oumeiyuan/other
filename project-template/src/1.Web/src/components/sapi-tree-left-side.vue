<template>
	<div class="left-side-tree">
		<sapi-tree :data="treeData" :lazy-load="lazyLoad" :select-after="activeNode" :render-content="renderContent" :props="props" :actived-id="nodeId" @on-click="treeNodeClick">
		</sapi-tree>
		<!--下拉选择框-->
		<div class="selector-wrapper" @click="selWrapperClick" v-show="hasOpeater" :class="className">
			<div class="drop-down-selector" ref="dropDown" :style="{left:left,top:top}">
				<p class="add-siblings" v-if="permissions.Add && showObj.AddSame!==false" @click="changeHandleType(1)">
					<img src="../static/images/add-same.png" />
					<span v-text="$t('addSiblingTitle')"></span>
				</p>
				<p class="add-children" v-if="permissions.Add  && showObj.AddChild!==false" @click="changeHandleType(2)">
					<img src="../static/images/add-next.png" />
					<span v-text="$t('addChildTitle')"></span>
				</p>
				<p class="edit-stru" v-if="permissions.Edit && showObj.Edit!==false" @click="changeHandleType(0)">
					<img src="../static/images/stru-edit.png" />
					<span v-text="$t('edit')"></span>
				</p>
				<p class="delete-stru" v-if="permissions.Delete && showObj.Delete!==false" @click="changeHandleType(3)">
					<img src="../static/images/stru-delete.png" />
					<span v-text="$t('delete')"></span>
				</p>
			</div>
		</div>
	</div>
</template>

<script>
	import tree from "@/components/tree";
	export default {
		components: {
			"sapi-tree": tree
		},
		data() {
			return {
				item: {},
				permissions: {},
				props: {},
				left: null,
				top: null,
				className: null
			}
		},
		computed: {
			hasOpeater() {
				this.permissions = this.$parent.permissions || {};
				return(this.permissions.Add || this.permissions.Edit || this.permissions.Delete);
			},
			showObj() {
				return this.showController || {};
			}
		},
		props: {
			"treeProp": Object,
			"treeData": Array,
			"nodeKey": String,
			"nodeId": String,
			"showController": Object,
			"lazyLoad": Function
		},

		methods: {
			activeNode(item) {
				this.item = item;
			},
			treeNodeClick(data) {
				this.$emit("on-click", data);
			},
			removeMousewheel(e) {
				e.preventDefault();
			},
			openDropdown(data, e) {
				var bodyHeight = document.body.clientHeight - 160;

				//e.stopPropagation();
				var x = e.clientX - 52;
				var y = e.clientY + 26;

				var drop = this.$refs.dropDown;
				var className = "";
				if(y > bodyHeight) {
					y -= 210;
					className = " upDropNode";
				}
				this.className = drop.parentNode.className + " active" + className;

				this.left = x + "px";
				this.top = y + "px";

				this.$emit("action-click", data);
			},
			selWrapperClick() {
				this.className = null;
			},
			changeHandleType(type) {
				this.$emit("change-handle", type);
			},
			renderContent(data) {
				var className = "";
				var iconType = data[this.treeProp.type];
				if(typeof iconType === "number") {
					if(iconType === 0) {
						className = "icon-company";
					} else {
						className = "icon-department";
					}
				}

				let eventName = "";
				let opeaterClass = "";
				if(this.hasOpeater) {
					eventName = " @click='openDropdown'";
					opeaterClass = "add-btn-span";
				}

				return "<span class='" + opeaterClass + "'" + eventName + "></span><i class='" + className + "'></i>" + data[this.treeProp.label];
			},
			getSelectNode() {
				return this.item;
			}
		},
		created() {
			var props = this.treeProp || {};
			this.props = {
				label: props.label,
				value: props.value || props.nodeKey,
				children: props.children,
				hasChild: props.hasChild
			}
		}
	}
</script>

<style>
	.left-side-tree {
		position: absolute;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		border-right: 1px solid #F2F2F2;
	}
	
	.selector-wrapper {
		width: 100%;
		height: 100%;
		position: fixed;
		z-index: 9;
		left: 0;
		top: 0;
		display: none;
	}
	
	.selector-wrapper.active {
		display: block;
	}
	
	.drop-down-selector {
		width: 110px;
		height: auto;
		position: absolute;
		left: 50px;
		top: 350px;
		z-index: 10;
		background-color: #fff;
		padding: 6px;
		color: #4B5C64;
		font-size: 14px;
		box-shadow: 0 0 16px 5px #eee;
		border-radius: 6px;
	}
	
	.drop-down-selector:before {
		content: "";
		width: 0;
		height: 0;
		border: 6px;
		border-color: transparent transparent #fff transparent;
		border-style: dashed dashed solid dashed;
		position: absolute;
		top: -12px;
		left: 50%;
		margin-left: -6px;
	}
	
	.upDropNode>.drop-down-selector:before {
		display: none;
	}
	
	.upDropNode>.drop-down-selector:after {
		content: "";
		width: 0;
		height: 0;
		border: 6px;
		border-color: #fff transparent transparent transparent;
		border-style: dashed dashed solid dashed;
		position: absolute;
		bottom: -12px;
		left: 50%;
		margin-left: -6px;
	}
	
	.drop-down-selector>p {
		margin: 0;
		padding: 8px;
	}
	
	.drop-down-selector img {
		margin-right: 4px;
		vertical-align: top;
	}
	
	.drop-down-selector>p:hover {
		background-color: #f6f7f7;
		cursor: pointer;
	}
	
	p.add-children {
		border-bottom: 1px solid #F1F1F1;
		padding-bottom: 14px;
	}
	
	p.edit-stru {
		padding-top: 14px;
	}
	
	.tree-node-label:hover>.add-btn-span {
		display: block;
	}
	
	.add-btn-span {
		position: relative;
		display: none;
		float: right;
		width: 40px;
		height: 40px;
		background: url(../static/images/drop-down-trigger.png) 0 -2px;
		z-index: 1;
	}
	
	.left-side-tree .sapi-tree .tree-node-label>i {
		padding-right: 6px;
	}
	
	.tree-wrapper .el-tree-node__label {
		width: calc(100% - 30px);
	}
</style>