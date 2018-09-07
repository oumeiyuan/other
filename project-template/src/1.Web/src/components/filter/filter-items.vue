<template>
	<ul>
		<li v-for="(item,index) in data">
			<item-content :itemSlot="item.childrn"></item-content>
		</li>
	</ul>
</template>

<script>
	import content from "./filter-item-content.js";
	export default{
		data(){
			return{
				data:[],
				items:[]
			}
		},
		props:{
			slots:Array
		},
		components:{
			"item-content":content
		},
		methods:{
			init(){
				let data=[];
				let slots=this.slots;

				slots.forEach((slot)=>{
					if(!slot.tag||!slot.data){
						return;
					}
					let attrs=slot.data.attrs;
					let obj={
						props:attrs.props,
						data:attrs.data,
						related:attrs.related,
						defaultValue:attrs.defaultValue,
						format:attrs.format,
						children:slot.componentOptions.children?slot.componentOptions.children[0]:{}
					}
					data.push(obj);
					
					this.data=data;
				})
			}
		},
		created(){
			
			this.init();
		},
		watch:{
			slots(val){
				this.init();
			}
		}
	}
</script>

<style>
</style>