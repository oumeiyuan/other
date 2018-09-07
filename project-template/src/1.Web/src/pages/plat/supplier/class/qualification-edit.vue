<template>
    <sapi-dialog v-model="visible" width="500px" top="26%" class="add" @on-open="open" @on-close="close">
        <span slot="title" v-text="$t('supplierClass.ediSupplierQualificationTitle')"></span>
        <div class="form-error-tips"></div>
        <div class="form-content">
            <div class="fullline">
                <span class="w-65 must-star" v-text="$t('supplierClass.qualificationName')"></span>
                <div class="right-auto-box">
                    <el-input id="txtQualificationName" v-model.trim="qualificationModel.QualificationName" :maxlength="100"></el-input>
                </div>
            </div>

            <div class="fullline">
                <span class="w-65 lh-30" v-text="$t('rowIndex')"></span>
                <div class="right-auto-box">
                    <el-input v-model="qualificationModel.RowIndex" :min="0" :max="999999999" :controls="false" v-format.d="{default:0}"></el-input>
                </div>
            </div>

            <div class="fullline">
                <span class="w-65 lh-30" v-text="$t('supplierClass.remark')"></span>
                <div class="right-auto-box">
                    <el-input v-model="qualificationModel.Remark" type="textarea" :autosize="{ minRows: 2, maxRows: 4}" :maxlength="200"></el-input>
                </div>
            </div>
        </div>

        <div class="footer">
            <el-button size="small" class="default-button" @click="close" v-text="$t('cancel')"></el-button>
            <el-button size="small" class="blue-button" :disabled="disabled" @click="confirm" v-text="$t('confirm')"></el-button>
        </div>
    </sapi-dialog>
</template>

<script>
    import tips from "@/components/sapi-tips.js";
    import dialog from "@/components/sapi-dialog.vue";
    import select from "@/components/sapi-select.vue";

    export default {
        data() {
            return {
                disabled: false,
                visible: false,
                qualificationModel: { 
                    QualificationName: "",
                    RowIndex: "",
                    Remark: ""
                }    
            }
        },
        props: ["value", "title", "option", "index"],
        methods: {
            open() {
                this.qualificationModel = JSON.parse(JSON.stringify(this.option.SupplierQualifications[this.index]));
            },
            close() {
                this.$closeWaringTips(".form-error-tips");
                this.$emit("input", false); 
            },
            confirm() {
				if(this.validate()) {
                    this.$emit('callback', this.qualificationModel, true);
					this.close();
				}
			},
            validate() {
                this.$closeWaringTips(".form-error-tips");
                if(!this.qualificationModel.QualificationName) {
                    this.$errorTips(this.$t('supplierClass.qualificationNameNotBeEmpty'),"#txtQualificationName");
                    return false;
                }
                if(this.checkQualificationNameIsExists(this.qualificationModel.QualificationName)) {
                    this.$errorTips(this.$t('supplierClass.qualificationNameAlreadyExists'), "#txtQualificationName");
                    return false;
                }
                return true;
            },
            //校验资质名称是否已存在
			checkQualificationNameIsExists(val) {
				var isExists = false;
				var supplierQualifications = this.option.SupplierQualifications;
				var index = this.index;
				if(supplierQualifications && supplierQualifications.length > 0) {
					for(var i = 0, ii = supplierQualifications.length; i < ii; i++) {
						var supplierQualification = supplierQualifications[i];
						if(i != index && supplierQualification && supplierQualification.QualificationName == val) {
							isExists = true;
							break;
						}
					}
				}
				return isExists;
			}
        },
        components: {
            "sapi-dialog": dialog,
            "sapi-select": select
        },
        watch: {
            value(val) {
                this.visible = val;
            }
        },
        created() {
            Vue.use(tips);
        },
        mounted() {
            this.visible = this.value;
        }
    }
</script>
