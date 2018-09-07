<template>
	<div>
		<sapi-collapse :active-name="activeName" @expandClick="expandClick">
			<collapse-item title="这是标题">
				这里是内容区
			</collapse-item>
			<collapse-item title="这是标题2" :is-hide="active">
				这里是内容区2
			</collapse-item>
			<collapse-item title="这是标题3">
				这里是内容区3
			</collapse-item>
			<collapse-item title="这是标题4">
				<template slot="title">
					<span>这是标题4</span>
				</template>
				这里是内容区4
			</collapse-item>
		</sapi-collapse>
	</div>
</template>

<script>
	import collapse from "@/components/collapse";
	
	export default {
		data() {
			return {
				active:true,
				activeName:[0,2]
			}
		},
		components:{
			"sapi-collapse":collapse
		},
		methods:{
			expandClick(index){
				this.active=false;
				console.log(index);
				console.log(this.activeName)
			}
		},
		created() {

		}
	}
</script>
