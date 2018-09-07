<template>
	<div class="sapi-collapse">
		<slot></slot>
	</div>
</template>

<script>
	import item from "./collapse-item.vue";
	Vue.component("collapse-item", item);
	export default {
		data() {
			return {
				items: [],
				activeIndexs: [0],
				changeFlag: false
			}
		},
		props: {
			activeName: [Array, Number, String]  //展开的折叠面板项，默认只展开第一项
		},
		methods: {
			//初始化时添加子对象
			addItem(item) {
				this.items.push(item);
			},
			//收缩、展开时调用
			editItem(item) {
				let index = this.activeIndexs.indexOf(item.index);
				if(item.hide === true) {
					this.activeIndexs.splice(index, 1);
				} else {
					this.activeIndexs.push(item.index);
				}
				this.changeFlag = true;
				this.$emit("update:activeName", this.activeIndexs);
				this.$emit("expandClick", item.index);
				setTimeout(()=>{
					this.changeFlag=false;
				});
			},
			init() {
				this.changeFlag = false;
				if(this.items.length === 0) {
					return;
				}

				let activeNames = this.activeName;
				
				if(!activeNames && activeNames !== 0) {
					return;
				}

				let arrs = [].concat(activeNames);
				if(arrs.length===0){
					return;
				}
				
				let indexs = [];

				//初始化展开面板
				this.items.forEach((item) => {
					let current = arrs.find((arr) => {
						return item.index == arr || item.name === arr;
					});

					if(current != undefined) {
						indexs.push(item.index);
						item.slot.hide = false;
					} else {
						item.slot.hide = true;
					}
				});

				this.activeIndexs = indexs;
			}
		},
		created() {
			this.items = [];
			this.$nextTick(() => {
				this.init();
			});
		},
		watch: {
			activeName(val) {
				!this.changeFlag && this.init();
			}
		}
	}
</script>

<style lang="less">
	.sapi-collapse {
		.collapse-item.item-hide {
			overflow: hidden;
			clear: both;
			margin-bottom: 6px;
		}
		.collapse-item-title {
			position: relative;
			display: inline-block;
			width: 100%;
			height: 30px;
			margin-bottom: 10px;
			padding-left: 24px;
			padding-right: 11px;
			line-height: 30px;
			font-size: 14px;
			color: #3b515c;
			font-weight: bold;
			cursor: pointer;
			background-color: #fff;
			&:hover {
				background-color: #f5f5f5;
			}
			&>i {
				display: none;
				position: absolute;
				right: 8px;
				top: 10px;
				color: #c5c6c6;
				font-size: 12px;
				transform: rotate(-90deg);
			}
		}
		.collapse-item-content {
			clear: both;
			padding-bottom: 10px;
			padding-left: 24px;
			padding-right: 24px;
		}
		.item-hide {
			.collapse-item-title {
				background-color: #f5f5f5;
				&>i {
					display: inline-block;
				}
			}
			.collapse-item-content {
				display: none;
				padding-bottom: 0px;
			}
		}
	}
</style>