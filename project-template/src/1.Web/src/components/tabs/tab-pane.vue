<template>
	<div class="tab-pane">
		<slot :disabled="disabled"></slot>
	</div>
</template>

<script>
	export default {
		data(){
			return {
				index:-1
			}
		},
		props: {
			name: String, //与选项卡 activeName 对应的标识符，表示选项卡别名
			label: String, //选项卡标题
			disabled:Boolean,//是否禁用
		},
		methods: {
			init() {
				let slots = this.$slots;
				let slot={
					name: this.name,
					disabled:this.Boolean
				}

				if(slots.label) {
					slot.label=null;
					slot.slot= slots.label;
				}else{
					slot.label=this.label;
					slot.slot= null;
				}
				
				let parent=this.$parent;
				this.index=parent.items.length;

				parent.addPane(slot);
			}
		},
		created() {
			this.init();
		},
		watch:{
			disabled(val){
				this.$parent.update(val,this.index);
			}
		}
	}
</script>

<style>

</style>