<template>
	<div class="collapse-item" :class="{'item-hide':hide}" v-if="isHide!==true">
		<div class="collapse-item-title" @click="expandClick()">
			<slot name="title">
				{{title}}
			</slot>
			
			<i class="el-icon-arrow-down"></i>
		</div>
		<div class="collapse-item-content">
			<slot></slot>
		</div>
	</div>
</template>

<script>
	//import titleRender from "./collapse-title-render.js";
	export default {
		data(){
			return {
				index:-1,
				hide:false
			}
		},
		props: {
			isHide:Boolean, //是否隐藏,初始化隐藏可以达到先不渲染的效果，跟show有些不一样...
			name: String, //与折叠面板 activeName 对应的标识符，表示选项卡别名
			title: String, //折叠面板标题
		},
		methods: {
			//折叠面板收缩、展开事件
			expandClick(){
				this.hide=!this.hide;
				this.$parent.editItem({hide:this.hide,index:this.index});
			},
			init() {
				let parent=this.$parent;
				let index=parent.items.length;
				this.index=index;
				if(index>0){
					this.hide=true;
				}
				
				let item={
					index:index,
					name:this.name,
					hide:this.hide,
					slot:this
				};
				parent.addItem(item);
			}
		},
		created() {
			this.init();
		}
	}
</script>
