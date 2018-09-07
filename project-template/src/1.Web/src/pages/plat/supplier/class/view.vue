<template>
	<div class="supplierClass-view">
		<div class="fullline">
			<span class="w-80" v-text="$t('supplierClass.className')"></span>
			<div class="right-box">
				<el-input v-model="viewModel.ClassName" readonly></el-input>
			</div>
		</div>
		<div class="fullline">
			<span class="w-80" v-text="$t('supplierClass.baseClassName')"></span>
			<div class="right-box">
				<el-input v-model="viewModel.BaseClassName" readonly></el-input>
			</div>
		</div>
        <div class="fullline" v-show="viewModel.Level > 1">
			<span class="w-80" v-text="$t('supplierClass.parentClassName')"></span>
			<div class="right-box">
				<el-input v-model="viewModel.ParentClassName" readonly></el-input>
			</div>
		</div>
		<div class="fullline">
			<span class="w-80" v-text="$t('rowIndex')"></span>
			<div class="right-box">
				<el-input v-model="viewModel.RowIndex" readonly></el-input>
			</div>
		</div>
		<div class="fullline">
			<span class="w-80" v-text="$t('supplierClass.remark')"></span>
			<div class="right-box">
				 <el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4}" v-model="viewModel.Remark" readonly>
				</el-input>
			</div>
		</div>
        <!--供方资质-->
		<div class="set-handleUrl-box">
			<span class="w-80" v-text="$t('supplierClass.qualification')"></span>
			<div class="right-path-box width-p100">
				<el-table class="common-table" v-show="viewModel.SupplierQualifications" :data="viewModel.SupplierQualifications">
					<el-table-column prop="QualificationName" :label="$t('supplierClass.qualificationName')" width="150" show-overflow-tooltip>
                    </el-table-column>
                    <el-table-column prop="Remark" :label="$t('supplierClass.remark')" min-width="" show-overflow-tooltip>
                    </el-table-column>				
                    <el-table-column prop="RowIndex" :label="$t('rowIndex')" width="100" show-overflow-tooltip>
                    </el-table-column>		
				</el-table>
			</div>
		</div>
	</div>
</template>

<script>
	export default{
		data(){
			return{
				viewModel:{}
			}
		},
		props:["option"],
		methods:{
			getViewModel(val){
				this.viewModel=val;
            }
		},
		mounted(){
			this.getViewModel(this.option);
		},
		watch:{
			option(val){
				this.getViewModel(val);
			}
		}
	}
</script>

<style>
	.supplierClass-view{
		width: 100%;
		height: 100%;
		overflow: auto;
		padding: 30px 15px 15px 15px;
	}
	.supplierClass-view .right-path-box{
		display: inline-block;
	    width: calc(100% - 90px);
	    vertical-align: top;	
	}
</style>