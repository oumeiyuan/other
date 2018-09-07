<template>
	<sapi-dialog v-model="visible" width="500px" top="26%" @on-open="open"  @on-close="close">
		<span slot="title" v-text="$t('supplierBaseClass.editSupplierBaseClassTitle')"></span>
		<div class="form-error-tips"></div>
		<div class="form-content">
            <div class="fullline">
				<span class="w-65 must-star" v-text="$t('supplierBaseClass.className')"></span>
				<div class="right-auto-box">
					<el-input id="txtClassName" v-model.trim="editModel.ClassName" :maxlength="100"></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-65" v-text="$t('rowIndex')"></span>
				<div class="right-auto-box">
					<el-input-number v-model="editModel.RowIndex" :min="0" :max="999999999" :controls="false"></el-input-number>
				</div>
			</div>
            <div class="fullline">
				<span class="w-65" v-text="$t('supplierBaseClass.remark')"></span>
				<div class="right-auto-box">
					<el-input  :maxlength="200" type="textarea" :autosize="{ minRows: 2, maxRows: 4}"  v-model="editModel.Remark" ></el-input>
				</div>
			</div>
		</div>
		<div class="footer">
			<el-button size="small" class="default-button" @click="close" v-text="$t('cancel')"></el-button>
			<el-button class="blue-button" size="small" :disabled="disabled" @click="submit" v-text="$t('submit')"></el-button>			
		</div>
	</sapi-dialog>
</template>

<script>
    import tips from "@/components/sapi-tips.js";
	import dialog from "@/components/sapi-dialog.vue";
    export default {
      data() {
			return {
				disabled:false,
				visible: false,
				editModel: {}
			}
		},
        props:["option","value"],   
        components: {
			"sapi-dialog": dialog
        },
        methods: {
			open() {
				this.getEditModel();
			},
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input",false);
			},
			getEditModel(){	
				var params = {};
                this.$get("/api/plat/supplierBaseClasses/"+this.option.ClassId, params, function(res) {
					this.editModel = res;
				});
            },
			submit() {
				if(!this.validate()){
					return;
				}
				this.disabled=true;
				this.$put("/api/plat/supplierBaseClasses/", this.editModel, function(res) {
					this.disabled=false;
					this.$parent.loadData();
					this.close();
					Vue.successMsg(this.$t('supplierBaseClass.editSupplierBaseClassSuccess'));
				});
            },            
			validate(){
				this.$closeWaringTips(".form-error-tips");
                if (!this.editModel.ClassName) {
					this.$errorTips(this.$t('supplierBaseClass.classNameNotBeEmpty'),"#txtClassName");
					return false;
                }
                return true;				
			}
        },
        created(){
			Vue.use(tips);
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