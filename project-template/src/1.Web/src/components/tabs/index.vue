<template>
	<div class="sapi-tabs" :class="className">
		<div class="tab-header">
			<template v-for="(item,index) in items">
				<template v-if="item.slot">
					<title-item @on-click="tabClick" :class="{active:activeIndex===index,disabled:item.disabled}" :index="index" :item="item"></title-item>
				</template>
				<template v-else>
					<span class="tabs-title" :class="{active:activeIndex===index}" @click="tabClick(item,index)">{{item.label}}</span>
				</template>
			</template>
		</div>
		<div class="tab-content" ref="tabContent">
			<slot></slot>
		</div>
	</div>
</template>

<script>
	import pane from "./tab-pane.vue";
	import renderTitle from "./tab-title-render.js";

	Vue.component("tab-pane", pane);
	export default {
		data() {
			return {
				items: [],
				activeIndex: -1,
				changeFlag:false,
			}
		},
		props: {
			type: String, //暂时有两种类型，一种是默认(空值)，另外一种 card,可扩展，直接追加type，添加样式即可
			activeName: [String, Number] //为字符串：匹配的是name，如果多个同名只会匹配第一个对应的名字；为数字类型时：tab的索引，从零开始，超出界限，不选中
		},
		computed: {
			//类型
			className() {
				if(this.type) {
					return this.type;
				}

				return "";
			}
		},
		methods: {
			//添加tab pane
			addPane(item) {
				this.items.push(item);
			},
			//更新disabled的值
			update(val, index) {
				this.items[index].disabled = val;
			},
			//内容选中展示
			showContent(index) {
				this.activeIndex = index;
				let tabs = this.$refs.tabContent.querySelectorAll(".tab-pane");
				for(let i=0,ii=tabs.length;i<ii;i++){
					let tab=tabs[i];
					if(i === index) {
						tab.className = tab.className + " active";
					} else {
						tab.className = tab.className.replace(" active", "");
					}
				}
			},
			//tab点击事件
			tabClick(item, index) {
				if(item.disabled === true || this.activeIndex === index) {
					return;
				}

				this.showContent(index);
				this.$emit("tab-click", index);
				this.changeFlag=true;
				this.$emit("update:activeName", index);
			},
			init(){
				this.changeFlag=false;
				//选中初始化
				let type = this.$typeof(this.activeName);
				if(type === "number") {
					this.showContent(this.activeName);
					return;
				}

				if(type === "string" && this.activeName) {
					let items = this.items;
					let name = this.activeName;
					let index = 0;
					for(let i = 0, ii = items.length; i < ii; i++) {
						if(items[i].name === name) {
							index = i;
							break;
						}
					}
					this.showContent(index);
					return;
				}

				//默认选中第一个
				this.showContent(0);
			}
		},
		components: {
			"title-item": renderTitle
		},
		created() {
			this.items = [];

			this.$nextTick(function() {
				this.init();
			});
		},
		watch:{
			activeName(val){
				!this.changeFlag&&this.init();
			}
		}
	}
</script>

<style lang="less">
	@tab-active-color: #3b515c;
	@disabled-color: #ccc;
	.sapi-tabs {
		.tab-header {
			clear: both;
			height: 40px;
			padding-left: 26px;
			list-style: none;
			border-bottom: 1px solid #f5f3f4;
			overflow: hidden;
			&>span {
				display: block;
				float: left;
				height: 100%;
				margin: 0 10px;
				text-align: center;
				line-height: 40px;
				color: @tab-active-color;
				font-size: 12px;
				font-weight: bold;
				cursor: pointer;
			}
			&>.active,
			&>span:hover {
				border-bottom: 2px solid @tab-active-color;
			}
			&>.disabled,
			&>.disabled:hover {
				color: @disabled-color;
				border-bottom: 0px;
				cursor: default;
			}
		}
		.tab-content {
			&>div {
				display: none;
				clear: both;
				min-height: 100px;
				list-style: none;
			}
			&>.active {
				display: block;
			}
		}
		&.card {
			.tab-header {
				height: 32px;
				padding-left: 10px;
				border-bottom-width: 0;
				background-color: #f5f5f5;
				&>span {
					height: 27px;
					padding: 0 18px;
					margin-top: 5px;
					line-height: 27px;
					border-bottom-width: 0px;
					&.active:not(.disabled),
					&:hover:not(.disabled) {
						border-top-left-radius: 3px;
						border-top-right-radius: 3px;
						background-color: #fff;
					}
					
					
				}
			}
		}
	}
</style>