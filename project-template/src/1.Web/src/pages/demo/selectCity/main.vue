<template>
	<div class="main-demo">
		<div style="height: 350px;">
			<sapi-area v-model="node" :format="format" clearable :left="50" @change="change"></sapi-area>
		</div>
		<sapi-area v-model="node1" @change="change"></sapi-area>
	</div>
</template>

<script>
	
	import city from "@/components/sapi-area.vue";
	
	export default{
		data(){
			return{
				node:null,
				node1:null
			}
		},
		components:{
			"sapi-area":city
		},
		methods:{
			change(data){
				console.log(data)

				
			},
			format(option){
				let text="";
				if(option.province){
					text+=option.province.Name;
				}
				
				if(option.city){
					text+=">"+option.city.Name;
				}
				if(option.area){
					text+=">"+option.area.Name;
				}
				
				return text;
			}
		},
		watch:{
			node(val){
				console.log(val)
			}
		}
	}
</script>

<style>
	.main-demo{
		overflow: auto;
		height: 100%;
	}
</style>