<template>
	<sapi-dialog class="contacter-edit" v-model="visible" width="420px" top="18%" @on-open="open" @on-close="close">
		<span slot="title">修改联系人</span>
		<div class="form-error-tips"></div>
		<div class="form-content">
			<div class="fullline">
				<span class="w-80 must-star">联系人名称 </span>
				<div class="right-auto-box">
					<el-input id="txtContacterName" v-model.trim="editModel.ContacterName" :maxlength="100"></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80">性别</span>
				<el-radio-group v-model="editModel.Sex">
					<el-radio class="radio" :label="0">男</el-radio>
					<el-radio class="radio" :label="1">女</el-radio>
				</el-radio-group>
			</div>
			<div class="fullline">
				<span class="w-80">移动电话</span>
				<div class="right-auto-box">
					<el-input id="txtMobileTelephone" v-model.trim="editModel.MobileTelephone" :maxlength="100"></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80">备注</span>
				<div class="right-auto-box">
					<el-input v-model.trim="editModel.Remark" type="textarea" :autosize="{minRows:2, maxRows:2}" :maxlength="200"></el-input>
				</div>
			</div>			
		</div>		
		<div class="footer">
			<el-button size="small" class="default-button" @click="close">取消</el-button>
			<el-button class="blue-button" size="small" :disabled="disabled" @click="comfirm">确定</el-button>	
		</div>
	</sapi-dialog>
</template>

<script>
	import tips from "@/components/sapi-tips.js";
	import dialog from "@/components/sapi-dialog.vue";
	
	export default {
		data() {
			return {
				visible: false,
				disabled: false,
				editModel: {
					ContacterName: null,
					Sex: 0,
					MobileTelephone: null,
					Remark: null
				}
			}
		},
		props: ["value", "option"],
		methods: {
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit('input', false);
			},
			open() {
				this.editModel.ContacterName = this.option.ContacterName;
				this.editModel.Sex = this.option.Sex;
				this.editModel.MobileTelephone = this.option.MobileTelephone;
				this.editModel.Remark = this.option.Remark;
			},
			comfirm() {
				if (this.validate()){
					this.$emit('callback', JSON.parse(JSON.stringify(this.editModel)), true);
					this.close();
				}
			},
			validate() {				
				this.$closeWaringTips(".form-error-tips");
				if(!this.editModel.ContacterName) {
					this.$errorTips("联系人名称不能为空", "#txtContacterName");
					return false;
				}								
				return true;
			}
		},
		components: {
			"sapi-dialog": dialog
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
	.contacter-edit .right-auto-box{
		display: inline-block;
		width: calc(100% - 90px);
		vertical-align: top;
	}
</style>