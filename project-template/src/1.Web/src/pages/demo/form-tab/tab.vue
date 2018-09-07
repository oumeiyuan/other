<template>
	<div>

		<sapi-tabs activeName="1233">
			<tab-pane label="abcd" name="123">234</tab-pane>
			<tab-pane label="abcd22" name="1235" :disabled="disabled">
				<span slot="label">
					abcd22
				</span>
				<div>abcd</div>
			</tab-pane>
			<tab-pane label="34345" name="1233">5453</tab-pane>
		</sapi-tabs>
		
		<sapi-tabs :activeName="activeName" type="card" @tab-click="tabClick">
			<tab-pane label="abcd" name="123">234</tab-pane>
			<tab-pane label="abcd22" name="1235" :disabled="disabled">
				<span slot="label">
					abcd22
				</span>
				<div>abcd</div>
			</tab-pane>
			<tab-pane label="34345" name="1233">5453</tab-pane>
		</sapi-tabs>

	</div>
</template>

<script>
	import tabs from "@/components/tabs";
	export default {
		data() {
			return {
				activeName: '1233',
				tabIndex: 0,
				disabled:false
			}
		},
		components:{
			"sapi-tabs":tabs
		},
		methods: {
			tabClick(index) {
				this.tabIndex = index;
				console.log(this.tabIndex)
			}
		},
		mounted(){
			setTimeout(()=>{
				this.activeName=0;
			},3000);
		}
	}
</script>