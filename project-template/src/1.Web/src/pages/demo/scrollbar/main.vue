<template>
	<sapi-scrollbar class="scrollbalDemo" ref="scroll">
		<ul>
			<li v-for="(item,index) in datas" v-text="item.label"></li>
		</ul>
	</sapi-scrollbar>
</template>

<script>
	import scrollbar from "@/components/sapi-scrollbar.vue";
	export default{
		data(){
			return {
				datas:[]
			}
		},
		components:{
			"sapi-scrollbar":scrollbar
		},
		methods:{
			
		},
		mounted(){
			let datas=[];
			for(let i=0;i<100;i++){
				datas.push({label:"英雄储钱："+i,id:i});
			}
			
			setTimeout(()=>{
				this.datas=datas;
				this.$nextTick(()=>{
					this.$refs.scroll.scrollToY(150);
				})
			},500)
		}
	}
</script>

<style>
	.scrollbalDemo{
		width: 300px;
		height: calc(100% - 50px);
	}
	
	.scrollbalDemo li{
		height: 30px;
		line-height: 30px;
	}
</style>