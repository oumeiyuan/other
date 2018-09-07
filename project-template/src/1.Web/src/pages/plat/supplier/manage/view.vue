<template>
    <sapi-dialog v-model="visible" width="1200px" top="10%" class="add" @on-open="open" @on-close="close">
        <span slot="title" v-text="$t('supplierManage.viewSupplierTitle')"></span>
        <div class="form-error-tips"></div>
        <div class="form-content">
            <div class="form-collapses">
                <div class="fullline">
                    <div class="wp-50">
                        <span class="w-65 " v-text="$t('supplierManage.supName')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtSupName" v-model.trim="viewModel.SupName" readonly></el-input>
                        </div>
                    </div>
                    <div class="wp-50 float-right">
                        <span class="w-65 " v-text="$t('supplierManage.supNo')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtSupNo" v-model.trim="viewModel.SupNo" readonly></el-input>
                        </div>
                    </div>  
                </div>

                <div class="fullline">
                    <div class="wp-50">
                        <span class="w-65" v-text="$t('supplierManage.area')"></span>
                        <div class="right-auto-box">
                            <el-input :value="getProvinceCityAreaName()" readonly></el-input>
                        </div>
                    </div>
                    <div class="wp-50 float-right">                                
                        <span class="w-65 " v-text="$t('supplierManage.creditCode')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtCreditCode" v-model="viewModel.CreditCode" readonly></el-input>
                        </div>
                    </div>    
                </div>

                <div class="fullline">
                    <span class="w-65 " v-text="$t('supplierManage.className')"></span>
                    <div class="right-auto-box">
                        <sapi-select-btn v-model="viewModel.SupplierClassRelats" :props="classRelatProps" height="56px" :has-more="true" :readonly="true"></sapi-select-btn>
                    </div>   
                </div>

                <div class="fullline">
                    <span class="w-65 " v-text="$t('supplierManage.businessLicence')"></span>
                    <div class="right-auto-box">
                        <sapi-upload :count="1" type=".jpg,.gif,.png,.jpeg,.svg" :has-load="false"
                            :has-date="false"  :has-size="false" :has-delete="false"
                            v-model="businessLicenceUrlModel" :readonly="true"></sapi-upload>
                    </div>
                </div>

                <div class="fullline">
                    <div class="wp-50">
                        <span class="w-65" v-text="$t('supplierManage.enterpriseForm')"></span>
                        <div class="right-auto-box"> 
                            <el-input id="txtEnterpriseFormValue" v-model="enterpriseFormValue[viewModel.EnterpriseForm]" readonly></el-input>
                        </div>
                    </div>
                    <div class="wp-50 float-right">
                        <span class="w-65" v-text="$t('supplierManage.taxPayer')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtTaxPayer" v-model="taxPayerValue[viewModel.TaxPayerId]" readonly></el-input>
                        </div>
                    </div>  
                </div>

                <div class="fullline">
                    <div class="wp-50">
                        <span class="w-65 " v-text="$t('supplierManage.legalRepresentative')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtLegalRepresentative" v-model.trim="viewModel.LegalRepresentative" readonly></el-input>
                        </div>
                    </div>
                    <div class="wp-50 float-right">
                        <span class="w-65 " v-text="$t('supplierManage.registeredCapital')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtRegisteredCapital" v-model.trim="viewModel.RegisteredCapital" readonly></el-input>
                        </div>
                    </div>  
                </div>

                <div class="fullline">
                    <div class="wp-50">
                        <span class="w-65 " v-text="$t('supplierManage.address')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtAddress" v-model.trim="viewModel.Address" readonly></el-input>
                        </div>
                    </div>
                    <div class="wp-50 float-right">
                        <span class="w-65 " v-text="$t('supplierManage.postalCode')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtPostalCode" v-model.trim="viewModel.PostalCode" readonly></el-input>
                        </div>
                    </div>  
                </div>

                <div class="fullline">
                    <div class="wp-50">
                        <span class="w-65 " v-text="$t('supplierManage.officePhone')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtOfficePhone" v-model.trim="viewModel.OfficePhone" readonly></el-input>
                        </div>
                    </div>
                    <div class="wp-50 float-right">
                        <span class="w-65 " v-text="$t('supplierManage.faxNumber')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtFaxNumber" v-model.trim="viewModel.FaxNumber" readonly></el-input>
                        </div>
                    </div>  
                </div>

                <div class="fullline">
                    <div class="wp-50">
                        <span class="w-65" v-text="$t('supplierManage.email')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtEmail" v-model.trim="viewModel.Email" readonly></el-input>
                        </div>
                    </div>
                    <div class="wp-50 float-right">
                        <span class="w-65" v-text="$t('supplierManage.officialWebsite')"></span>
                        <div class="right-auto-box">
                            <el-input id="txtOfficialWebsite" v-model.trim="viewModel.OfficialWebsite" readonly></el-input>
                        </div>
                    </div>  
                </div>

                <div class="fullline">
                    <span class="w-65 lh-30" v-text="$t('supplierManage.remark')"></span>
                    <div class="right-auto-box">
                        <el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4}" readonly v-model="viewModel.Remark">
                        </el-input>
                    </div>
                </div>

                <div class="fullline">
                    <span class="w-65" v-text="$t('supplierManage.setContact')"></span>
                    <div class="right-auto-box">
                        <div class="common-table width-p100">
                            <el-table border :data="tableContactData" ref="bodyTable" >				
                                <el-table-column prop="ContactName" :label="$t('supplierManage.contactName')" width="120" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="PositionName" :label="$t('supplierManage.positionName')" width="80" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="Sex" :label="$t('supplierManage.sex')" width="50" show-overflow-tooltip>
                                    <template slot-scope="props">
                                        {{props.row.Sex==0?"男":"女"}}
                                    </template>
                                </el-table-column>
                                <el-table-column prop="OfficePhone" :label="$t('supplierManage.officePhone')" width="150" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="MobileTelephone" :label="$t('supplierManage.mobileTelephone')" width="150" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="Email" :label="$t('supplierManage.email')" min-width="120" show-overflow-tooltip>
                                </el-table-column>
                            </el-table>
                        </div>
                    </div>
                </div>

                <div class="fullline">
                    <span class="w-65" v-text="$t('supplierManage.setQualification')"></span>
                    <div class="right-auto-box">
                        <div class="common-table width-p100">
                            <el-table border :data="tableQualficationData" ref="bodyTable" >				
                                <el-table-column prop="QualificationName" :label="$t('supplierManage.qualificationName')" width="150" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="ClassName" :label="$t('supplierManage.className')" width="150" show-overflow-tooltip>
								</el-table-column>
                                <el-table-column prop="QualificationFile" :label="$t('supplierManage.qualificationFile')" min-width="150" show-overflow-tooltip>
                                    <template slot-scope="props">
                                        <sapi-upload :count="5" type=".jpg,.gif,.png,.jpeg,.svg" :has-load="false" :has-size="false"
                                        :has-date="false" :has-delete="false" :readonly="true"
                                        v-model="props.row[props.row.Index]"  ></sapi-upload>
                                    </template>
                                </el-table-column>
                            </el-table>
                        </div>
                    </div>
                </div>

                <div class="fullline">
                    <span class="w-65" v-text="$t('supplierManage.setCooperativeCase')"></span>
                    <div class="right-auto-box">
                        <div class="common-table width-p100">
                            <el-table border :data="tableCaseData" ref="bodyTable" >				
                                <el-table-column prop="CooperativeTypeId" :label="$t('supplierManage.cooperativeType')" width="100" show-overflow-tooltip>
                                    <template slot-scope="props">
                                        {{props.row.CooperativeTypeId==1?"单次":"战略"}}
                                    </template>
                                </el-table-column>
                                <el-table-column prop="CooperativeCompany" :label="$t('supplierManage.cooperativeCompany')" width="120" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="CooperativeProjectName" :label="$t('supplierManage.cooperativeProjectName')" width="120" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="CooperativeRange" :label="$t('supplierManage.cooperativeRange')" width="150" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="ContractAmount" :label="$t('supplierManage.contractAmount')" width="120" show-overflow-tooltip>
                                </el-table-column>
                                <el-table-column prop="CommencementDate" :label="$t('supplierManage.commencementDate')" width="180" show-overflow-tooltip>
                                    <template slot-scope="props">
                                        {{$dateFormat('yyyy.MM.dd', props.row.CommencementDate)}}~{{$dateFormat('yyyy.MM.dd', props.row.CompletionDate)}}
                                    </template>
                                </el-table-column>
                                <el-table-column prop="Remark" :label="$t('supplierManage.remark')" min-width="100" show-overflow-tooltip>
                                </el-table-column>
                            </el-table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer">
            <el-button size="small" class="default-button" @click="close" v-text="$t('close')"></el-button>
        </div>
    </sapi-dialog>
</template>

<script>
	import supplier from "../../static/js/supplier.js";
    import tips from "@/components/sapi-tips.js";
    import dialog from "@/components/sapi-dialog.vue";
	import select from "@/components/sapi-select.vue";
    import upload from "@/components/sapi-upload.vue";
    import selectBtn from "@/components/sapi-select-btn.vue";
    import address from '../../static/js/address.js';

	import '@/static/css/sapi-form-tab.css';

    export default {
        data() {
            return {
				visible: false,
				tableContactData: [],
				tableQualficationData:[],
				tableCaseData:[],
                viewModel: {
                    SupId:null, 
					SupName:null,
					SupNo:null,
					ProvinceId:null,
					ProvinceName:null,
					CityId:null,
					CityName:null,
					AreaId:null,
					AreaName:null,
					ClassId:null,
					CreditCode:null,
					BusinessLicence:null,
					EnterpriseForm:null,
					TaxPayerId:null,
					LegalRepresentative:null,
					RegisteredCapital:null,
                    Address:null,
					PostalCode:null,
					OfficePhone:null,
					FaxNumber:null,
					Email:null,
					OfficialWebsite:null,
					Remark:null,
					SupplierClassRelats:[], //供方分类
					SupplierContacts:[], //联系人信息
					SupplierQualificationFiles:[], //资质文件 
					SupplierCooperativeCases:[] //合作案例
                },
                expand: {},
                classRelatProps:{
					label:"ClassName"
				},
				businessLicenceUrlModel:null,
                qualificationFiles:[], //文件信息
                taxPayerValue: supplier.TaxPayerValue,
                enterpriseFormValue:supplier.EnterpriseFormValue
			}
        },
		props: ["option","value","title"],
		mixins: [getPagerMixin(), getTabMixin()],
        methods: {
            expandClick(index){
				this.expand[index]=!this.expand[index];
			},
            open() {
                this.viewModel= {
                    SupId:null, 
					SupName:null,
					SupNo:null,
					ProvinceId:null,
					ProvinceName:null,
					CityId:null,
					CityName:null,
					AreaId:null,
					AreaName:null,
					ClassId:null,
					CreditCode:null,
					BusinessLicence:null,
					EnterpriseForm:null,
					TaxPayerId:null,
					LegalRepresentative:null,
					RegisteredCapital:null,
                    Address:null,
					PostalCode:null,
					OfficePhone:null,
					FaxNumber:null,
					Email:null,
					OfficialWebsite:null,
					Remark:null,
					SupplierClassRelats:[], //供方分类
					SupplierContacts:[], //联系人信息
					SupplierQualificationFiles:[], //资质文件 
					SupplierCooperativeCases:[] //合作案例
                };
                this.tableContactData=[];
				this.tableQualficationData=[];
				this.tableCaseData=[];
                this.getViewModel();
            },
            close() {
                this.$closeWaringTips(".form-error-tips");
                this.$emit("input", false); 
            },
            getViewModel() {	
				var params = {};
                this.$get("/api/plat/suppliers/"+this.option.SupId, params, function(res) {
                    this.viewModel = res;
                    this.viewModel.SupplierClassRelats=res.SupplierClassRelats||[];
                    if(!res.BusinessLicence) {
                        this.businessLicenceUrlModel = null;
                    }
                    else {
                        this.businessLicenceUrlModel = {
                            Extension:"."+res.BusinessLicence.split(".")[1],
                            FileName:"营业执照",
                            FilePath:res.BusinessLicence,
                            Uploader:res.LastEditByName,
                            UploaderId:res.LastEditBy,
                            UploadDate:res.LastEditDate
                        }
                    }
                    this.tableContactData=res.SupplierContacts;
                    let keyName="fileName";
                    for(var i = 0; i < res.SupplierQualificationFiles.length; i++) {
                        let _this=res.SupplierQualificationFiles[i];
                        if(_this.QualificationFile){
                            _this.QualificationFile.forEach((file)=>{
                                file.Extension="."+file.FilePath.split(".")[1];
                            })
                        }
                        let obj={
                            "Index":keyName,
                            "QualificationName": _this.QualificationName,
                            "ClassId": _this.ClassId,
                            "ClassName": _this.ClassName
                        }
                        obj[keyName]=_this.QualificationFile;
                        this.tableQualficationData.push(obj);
                    }
                    this.tableCaseData=res.SupplierCooperativeCases;
				});
            },
            getProvinceCityAreaName(){
                return address.getAddress(this.viewModel.ProvinceName,this.viewModel.CityName,this.viewModel.AreaName,"/");
            }
        },
        components: {
            "sapi-dialog": dialog,
			"sapi-select": select,
            "sapi-upload":upload,
            "sapi-select-btn":selectBtn
        },
        watch: {
            value(val) {
                this.visible = val;
            }
        },
        created() {
			Vue.use(tips);
			for(var i = 0; i < 5; i++) {
				this.$set(this.expand, i, true);
			}
        },
        mounted() {
            this.visible = this.value;
        }
    }
</script>
