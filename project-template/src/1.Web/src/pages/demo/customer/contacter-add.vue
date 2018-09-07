<template>
	<sapi-dialog class="contacter-add" v-model="visible" width="420px" top="18%" @on-open="open" @on-close="close">
		<span slot="title">新增联系人</span>
		<div class="form-error-tips"></div>
		<div class="form-content">
			<div class="fullline">
				<span class="w-80 must-star">联系人名称 </span>
				<div class="right-auto-box">
					<el-input id="txtContacterName" v-model.trim="createModel.ContacterName" :maxlength="100"></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80">性别</span>
				<el-radio-group v-model="createModel.Sex">
					<el-radio class="radio" :label="0">男</el-radio>
					<el-radio class="radio" :label="1">女</el-radio>
				</el-radio-group>
			</div>
			<div class="fullline">
				<span class="w-80">移动电话</span>
				<div class="right-auto-box">
					<el-input id="txtMobileTelephone" v-model.trim="createModel.MobileTelephone" :maxlength="100"></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-80">备注</span>
				<div class="right-auto-box">
					<el-input v-model.trim="createModel.Remark" type="textarea" :autosize="{minRows:2, maxRows:2}" :maxlength="200"></el-input>
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
				createModel: {
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
				// 每次新增先清空联系人信息
				this.createModel.ContacterName = null;
				this.createModel.Sex = 0;
				this.createModel.MobileTelephone = null;
				this.createModel.Remark = null;
			},
			comfirm() {
				if (this.validate()){
					this.$emit('callback', JSON.parse(JSON.stringify(this.createModel)));
					this.close();
				}
			},
			validate() {				
				this.$closeWaringTips(".form-error-tips");
				if(!this.createModel.ContacterName) {
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
	.contacter-add .right-auto-box{
		display: inline-block;
		width: calc(100% - 90px);
		vertical-align: top;
	}
</style>