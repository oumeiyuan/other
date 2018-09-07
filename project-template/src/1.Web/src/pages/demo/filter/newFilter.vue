<template>
	<div class="main">
		<div class="main-search-filter">
			<ul class="main-search-filter-items">
				<li>
					<span class="w-65">历史人物</span>
					<span class="right-auto-box">
							<el-input v-model="params.data3" ></el-input>
						</span>
				</li>
				<li><span class="w-65">江湖人物</span>
					<span class="right-auto-box">
						<el-input v-model="params.data4" ></el-input>
					</span>
				</li>
				<li><span class="w-65">江湖人物</span>
					<span class="right-auto-box">
						<el-input v-model="params.data5" ></el-input>
					</span>
				</li>
				<li>
					<span class="w-65">历史人物</span>
					<span class="right-auto-box">
							<el-input v-model="params.data3" ></el-input>
						</span>
				</li>
			</ul>
		</div>
		<div class="main-table"></div>
		<div>
			<el-button @click="open">打开过滤区</el-button>
		</div>
		<sapi-filter ref="filter">
			<filter-item :param.sync="params.data1" prop="data1" :props="props" :related="['data2']">
				<span class="w-65">历史人物</span>
				<span class="right-auto-box">
							<el-input v-model="params.data1" ></el-input>
						</span>
			</filter-item>
			<filter-item :param.sync="params.data2" prop="data2">
				<span class="w-65">江湖人物</span>
				<span class="right-auto-box">
							<el-input v-model="params.data2" ></el-input>
						</span>
			</filter-item>
		</sapi-filter>
	</div>

</template>

<script>
	import filterCmp from "@/components/filter";
	export default {
		data() {
			return {
				params: {
					data1: "123",
					data2: "789",
					data3:null,
					data4:null,
					data5:null,
					projectId: null,
				},
				props: {
					label: "label",
					value: "id"
				},
				init: false,
			}
		},
		methods: {
			open() {
				this.$refs.filter.isActive = true;
			}
		},
		components: {
			"sapi-filter": filterCmp
		},
		mounted() {
			/*setTimeout(()=>{
				this.params.data1="95555";
			},3000);*/
		}
	}
</script>

<style>

</style>