<template>
	<sapi-dialog class="customer-add" v-model="visible" width="850px" top="13%" @on-open="open" @on-close="close">
		<span slot="title">新增客户</span>
		<div class="form-error-tips"></div>
		<div class="form-content">
			<div class="fullline">
				<div class="wp-50">
					<span class="w-65 must-star">客户名称</span>
					<div class="right-auto-box">
						<el-input id="txtCustomerName" v-model.trim="createModel.CustomerName" :maxlength="100"></el-input>
					</div>
				</div>
				<div class="wp-50 float-right">
					<span class="w-65 must-star">客户编号 </span>
					<div class="right-auto-box">
						<el-input id="txtCustomerNo" v-model.trim="createModel.CustomerNo" :maxlength="100"></el-input>
					</div>
				</div>
			</div>
			<div class="fullline">
				<div class="wp-50">
					<span class="w-65 must-star">客户级别 </span>
					<div class="right-auto-box">
						<el-radio-group id="radCustomerLevel" v-model="createModel.CustomerLevel">
								<el-radio :label="1">一级</el-radio>
								<el-radio :label="2">二级</el-radio>
								<el-radio :label="3">三级</el-radio>
						</el-radio-group>
					</div>
				</div>							
			</div>
			<div class="fullline">
				<span class="w-65">客户地址 </span>
				<div class="right-auto-box">
					<el-input v-model.trim="createModel.CustomerAddress" :maxlength="100"></el-input>
				</div>
			</div>
			<!--联系人信息-->
			<div class="set-contacter-box mb-10">
				<span class="w-65 line-height">联系人</span>
				<div class="right-auto-box width-p100">
					<div class="mb-10">
						<el-button size="small" :plain="true" type="info" @click="openAddContacterDialog">新增联系人</el-button>
					</div>
					<el-table class="common-table" v-show="createModel.Contacters" :data="createModel.Contacters">
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
						<el-table-column label="操作" fixed="right" width="100">
							<template slot-scope="props">
                                <a class="table-btn" href="javascript:void(0)" @click.stop="openEditContacterDialog(props.row,props.$index)">修改</a>
                                <a class="table-btn" href="javascript:void(0)" @click.stop="deleteContacter(props.row,props.$index)">删除</a>
                            </template>
						</el-table-column>
					</el-table>				
				</div>
			</div>
			<div class="fullline">
				<span class="w-65">描述 </span>
				<div class="right-auto-box">
					<el-input v-model="createModel.Description" type="textarea" :autosize="{ minRows: 2, maxRows: 4}" :maxlength="200"></el-input>	
				</div>
			</div>			
		</div>
		
		<div class="footer">
			<el-button size="small" class="default-button" @click="close">取消</el-button>
			<el-button class="blue-button" size="small" :disabled="disabled" @click="submit">提交</el-button>			
		</div>
		
		<!--添加、修改联系人-->
		<component slot="moreDialog" v-bind:is="currentView" v-model="currentVisible" :option="currentOption" @callback="backModel"></component>
	</sapi-dialog>	
</template>

<script>
	import tips from "@/components/sapi-tips.js";
	import dialog from "@/components/sapi-dialog.vue";
	
	export default{
		data() {
			return {
				visible: false,
				disabled: false,
				createModel: {
					CustomerName:null,
					CustomerNo:null,
					CustomerLevel:0,
					CustomerAddress:null,
					Description:null,
					Contacters:[]	//联系人集合
				},
				currentView: null,	
				rowIndex: 0,
				currentVisible: false,
				currentOption: {}
			}
		},
		props: ["value"],
		methods: {
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit('input', false);
			},
			open() {
				this.createModel.CustomerName = null;
				this.createModel.CustomerNo = null;
				this.createModel.CustomerLevel = 0;
				this.createModel.CustomerAddress = null;
				this.createModel.Description = null;
				this.createModel.Contacters = [];
			},			
			submit() {
				if (!this.validate()){
					return;
				}				
				
				this.disabled = true;
				this.$post("/api/ims/customers/", this.createModel, function(res){
					this.disabled = false;
					this.$parent.loadData();
					this.close();
					Vue.successMsg("添加成功");
				});			
			},
			validate() {
				//先移除原来的错误提示信息
				this.$closeWaringTips(".form-error-tips");
				if (!this.createModel.CustomerName) {
					this.$errorTips("客户名称不能为空", "#txtCustomerName");
					return false;
				}
				if (!this.createModel.CustomerNo) {
					this.$errorTips("客户编号不能为空", "#txtCustomerNo");
					return false;
				}
				if (!this.createModel.CustomerLevel) {
					this.$errorTips("客户级别不能为空", "#radCustomerLevel");
					return false;
				}				
				return true;
			},
			openAddContacterDialog(){
				this.currentView = "contacter-add";
				this.currentVisible = true;
				this.currentOption = this.createModel;
			},
			openEditContacterDialog(row, index){
				this.currentView = "contacter-edit";
				this.currentVisible = true;
				this.currentOption = row;
				this.rowIndex = index;
			},
			deleteContacter(row, index){
				this.createModel.Contacters.splice(index, 1);
			},
			backModel(data, isEditContacter){
				if(isEditContacter === true) {
					Vue.set(this.createModel.Contacters, this.rowIndex, data);
				} else {
					this.createModel.Contacters.push(data);
				}
			}
		},
		components: {
			"sapi-dialog": dialog,
			"contacter-add": (resolve) => {
				require(['./contacter-add.vue'], resolve);
			},
			"contacter-edit": (resolve) => {
				require(['./contacter-edit.vue'], resolve);
			},
		},
		created() {
			Vue.use(tips);
		},
		mounted() {
			this.visible = this.value;
		},
		watch: {
			value(val) {
				this.visible = val;
			}
		}
	}
</script>

<style>
	.customer-add .line-height{
		line-height: 24px;
		vertical-align: top;
	}
</style>