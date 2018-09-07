<template>
	<sapi-dialog class="customer-view" v-model="visible" width="850px" top="13%" @on-open="open" @on-close="close">
		<span slot="title">查看客户</span>
		<div class="form-content no-footer">
			<div class="fullline">
				<div class="wp-50">
					<span class="w-65">客户名称</span>
					<div class="right-auto-box">
						<el-input v-model="viewModel.CustomerName" readonly></el-input>
					</div>
				</div>
				<div class="wp-50 float-right">
					<span class="w-65">客户编号 </span>
					<div class="right-auto-box">
						<el-input v-model="viewModel.CustomerNo" readonly></el-input>
					</div>
				</div>
			</div>
			<div class="fullline">
				<div class="wp-50">
					<span class="w-65">客户级别 </span>
					<div class="right-auto-box">
						<el-radio-group v-model="viewModel.CustomerLevel">
								<el-radio :label="1" disabled>一级</el-radio>
								<el-radio :label="2" disabled>二级</el-radio>
								<el-radio :label="3" disabled>三级</el-radio>
						</el-radio-group>
					</div>
				</div>							
			</div>
			<div class="fullline">
				<span class="w-65">客户地址 </span>
				<div class="right-auto-box">
					<el-input v-model="viewModel.CustomerAddress" readonly></el-input>
				</div>
			</div>
			<!--联系人信息-->
			<div class="set-contacter-box mb-10">
				<span class="w-65 line-height">联系人</span>
				<div class="right-auto-box width-p100">					
					<el-table class="common-table" v-show="viewModel.Contacters" :data="viewModel.Contacters">
						<el-table-column prop="ContacterName" label="联系人名称" width="150" show-overflow-tooltip>
                		</el-table-column>
                		<el-table-column label="性别" width="80">
                			<template slot-scope="props">
                				{{props.row.Sex == 0 ? '男' : '女'}}
                			</template>
                		</el-table-column>
                		<el-table-column prop="MobileTelephone" label="移动电话" width="120" show-overflow-tooltip>
                		</el-table-column>
                		<el-table-column prop="Remark" label="备注 " min-width="150" show-overflow-tooltip>
                		</el-table-column>					
					</el-table>				
				</div>
			</div>
			<div class="fullline">
				<span class="w-65">描述 </span>
				<div class="right-auto-box">
					<el-input v-model="viewModel.Description" type="textarea" :autosize="{ minRows: 2, maxRows: 4}" :maxlength="200" readonly></el-input>	
				</div>
			</div>	
			<div class="fullline">
				<span class="w-65">行号 </span>
				<div class="right-auto-box">
					<el-input v-model="viewModel.RowIndex" readonly></el-input>
				</div>
			</div>
		</div>		
	</sapi-dialog>
</template>

<script>
	import dialog from "@/components/sapi-dialog.vue";
	export default {
		data() {
			return {	
				visible:false,
				viewModel:{
					CustomerId:null,
					CustomerName:null,
					CustomerNo:null,
					CustomerLevel:0,
					CustomerAddress:null,
					Description:null,
					RowIndex:0,
					Contacters:[]	//联系人集合
				},
				currentView: null,	
				rowIndex: 0,
				currentVisible: false,
				currentOption: {}
			}
		},
		props: ["value", "option"],
		methods: {
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input",false);
			},
			open() {
				this.getViewModel();
			},
			getViewModel(){	
				var params = {};		
	            this.$get("/api/ims/customers/" + this.option.CustomerId, params, function(res) {
	            	this.viewModel.CustomerId = res.CustomerId;
					this.viewModel.CustomerName = res.CustomerName;
					this.viewModel.CustomerNo = res.CustomerNo;
					this.viewModel.CustomerLevel = res.CustomerLevel;
					this.viewModel.CustomerAddress = res.CustomerAddress;
					this.viewModel.Description = res.Description;
					this.viewModel.RowIndex = res.RowIndex;
					this.viewModel.Contacters = res.Contacters;
				});
	        },        
		},
		components: {
			"sapi-dialog": dialog,			
		},
		created(){
			
		},
		mounted(){
			this.visible=this.value;
		},
		watch:{
			value(val){
				this.visible=val;
			}
		}
	}
</script>

<style>
	.customer-view .line-height{
		line-height: 24px;
		vertical-align: top;
	}
</style>