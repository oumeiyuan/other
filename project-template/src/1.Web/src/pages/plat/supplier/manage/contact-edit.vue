<template>
    <sapi-dialog v-model="visible" width="500px" top="26%" class="add" @on-open="open" @on-close="close">
        <span slot="title" v-text="$t('supplierManage.editSupplierContactTitle')"></span>
        <div class="form-error-tips"></div>
        <div class="form-content">
            <div class="fullline">
                <span class="w-65 must-star" v-text="$t('supplierManage.contactName')"></span>
                <div class="right-auto-box">
                    <el-input id="txtContactName"  v-model.trim="editModel.ContactName" :maxlength="100"></el-input>
                </div>
            </div>

            <div class="fullline">
                <span class="w-65" v-text="$t('supplierManage.positionName')"></span>
                <div class="right-auto-box">
                    <el-input id="txtPositionName"  v-model.trim="editModel.PositionName" :maxlength="50"></el-input>
                </div>
            </div>
            
            <div class="fullline">
                <span class="w-65" v-text="$t('supplierManage.sex')"></span>
                <el-radio-group v-model="editModel.Sex">
                    <el-radio class="radio" :label="0">{{$t('supplierManage.sexData.man')}}</el-radio>
                    <el-radio class="radio" :label="1">{{$t('supplierManage.sexData.woman')}}</el-radio>
                </el-radio-group>
            </div>

            <div class="fullline">
                <span class="w-65" v-text="$t('supplierManage.email')"></span>
                <div class="right-auto-box">
                    <el-input id="txtEmail"  v-model.trim="editModel.Email" :maxlength="100"></el-input>
                </div>
            </div>

            <div class="fullline">
                <span class="w-65" v-text="$t('supplierManage.officePhone')"></span>
                <div class="right-auto-box">
                    <el-input id="txtOfficePhone"  v-model.trim="editModel.OfficePhone" :maxlength="100"></el-input>
                </div>
            </div>

            <div class="fullline">
                <span class="w-65" v-text="$t('supplierManage.mobileTelephone')"></span>
                <div class="right-auto-box">
                    <el-input id="txtMobileTelephone"  v-model.trim="editModel.MobileTelephone" :maxlength="100"></el-input>
                </div>
            </div>

        </div>

        <div class="footer">
            <el-button size="small" class="default-button" @click="close" v-text="$t('cancel')"></el-button>
            <el-button size="small" class="blue-button" :disabled="disabled" @click="submit" v-text="$t('submit')"></el-button>
        </div>
    </sapi-dialog>
</template>

<script>
    import tips from "@/components/sapi-tips.js";
    import dialog from "@/components/sapi-dialog.vue";

    export default {
        data() {
            return {
                disabled: false,
                visible: false,
                editModel: {   
                    Index:"",            
                    ContactName: "",
                    PositionName:"",
                    Sex:null,
                    Email:"",
                    OfficePhone:"",
                    MobileTelephone:""
                }             
            }
        },
        props: ["value","option"],
        methods: {
            open() {
                var obj={              
                    ContactName: "",
                    PositionName:"",
                    Sex:null,
                    Email:"",
                    OfficePhone:"",
                    MobileTelephone:""
                } ;
                this.editModel=this.option;
            },
            close() {
                this.$closeWaringTips(".form-error-tips");
                this.$emit("input", false);
            },
            submit() {
                if (!this.validate()) {
                    return;
                }
                this.$emit("call-back",[this.editModel,"contactEdit"]);
                this.close();
            },
            validate() {
                this.$closeWaringTips(".form-error-tips");
                if(!this.editModel.ContactName) {
                    this.$errorTips(this.$t('supplierManage.contactNameNotBeEmpty'),"#txtContactName");
                    return false;
                }
                return true;
            }
        },
        components: {
            "sapi-dialog": dialog
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
