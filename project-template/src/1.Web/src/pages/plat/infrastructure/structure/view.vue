<template>
	<sapi-dialog v-model="visible" width="700px" top="26%" class="add" @on-open="open" @on-close="close">
		<span slot="title" v-text="title"></span>
		<div class="form-error-tips"></div>
		<div class="form-content">
			<div class="fullline">
				<span class="w-80" v-text="$t('structure.structureName')"></span>
				<div class="right-box">
					<el-input v-model="viewModel.StruName" readonly></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80" v-text="$t('structure.struFullName')"></span>
				<div class="right-box">
					<el-input v-model="viewModel.StruFullName" readonly></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80" v-text="$t('structure.struNo')"></span>
				<div class="right-box">
					<el-input v-model="viewModel.StruNo" readonly></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80" v-text="$t('structure.struType')"></span>
				<div class="right-box">
					<el-input :value="(viewModel.StruType=='0'?$t('structure.struTypeData.corp'):$t('structure.struTypeData.dept'))" readonly></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80" v-text="$t('structure.parentStruName')"></span>
				<div class="right-box">
					<el-input :value="viewModel.ParentStruName ? viewModel.ParentStruName : '根节点'" readonly></el-input>
				</div>
			</div>
			<div class="fullline" v-if="viewModel.StruType=='1'">
				<span class="w-80" v-text="$t('structure.corpName')"></span>
				<div class="right-box">
					<el-input v-model="viewModel.CorpName" readonly></el-input>
				</div>
			</div>
			<div class="fullline" v-if="viewModel.StruType=='1'">
				<span class="w-80" v-text="$t('structure.deptHeaderName')"></span>
				<div class="right-box">
					<el-input v-model="viewModel.DeptHeaderName" readonly></el-input>
				</div>
			</div>
			<div class="fullline" v-if="viewModel.StruType=='1'">
				<span class="w-80" v-text="$t('structure.chargeLeaderName')"></span>
				<div class="right-box">
					<el-input v-model="viewModel.ChargeLeaderName" readonly></el-input>
				</div>
			</div>
			<div class="fullline" v-if="viewModel.StruType=='1'">
				<span class="w-80" v-text="$t('structure.functionHigherName')"></span>
				<div class="right-box">
					<el-input v-model="viewModel.FunctionHigherName" readonly></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80" v-text="$t('rowIndex')"></span>
				<div class="right-box">
					<el-input v-model="viewModel.RowIndex" readonly></el-input>
				</div>
			</div>
		</div>

		<div class="footer">
			<el-button size="small" class="default-button" @click="close" v-text="$t('close')"></el-button>
		</div>
	</sapi-dialog>
</template>

<script>
	import dialog from "@/components/sapi-dialog.vue";

	export default{
		data(){
			return{
				viewModel:{},
				visible:false
			}
		},
		props:["option","value","title"],
		methods:{
			open(){
				this.$get("/api/plat/structures/"+this.option.StruId, {}, function(res) {
					this.viewModel=res;
					this.viewModel.DeptHeaderName = this.getFullStationName(this.viewModel.DeptHeader);
					this.viewModel.ChargeLeaderName = this.getFullStationName(this.viewModel.ChargeLeader);
					this.viewModel.FunctionHigherName = this.getFullStationName(this.viewModel.FunctionHigher);
				});
			},
			getFullStationName(item){
				if (item){
					return item.CorpName + "/" + item.DeptName + "/" + item.StationName;
				}
				return "";
			},
			close() {
				this.$emit("input", false);
			}
		},
		components: {
			"sapi-dialog": dialog
		},
		watch:{
			value(val) {
				this.visible = val;
			}
		},
		created(){
			this.visible=this.value;
		}
	}
</script>

<style>
	.structrue-view{
		width: 100%;
		height: 100%;
		overflow: auto;
		padding: 30px 15px 15px 15px;
	}
</style>