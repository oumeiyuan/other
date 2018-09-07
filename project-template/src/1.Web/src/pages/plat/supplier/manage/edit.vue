<template>
    <sapi-dialog v-model="visible" width="1200px" top="10%" class="add" @on-open="open" @on-close="close">
        <span slot="title" v-text="$t('supplierManage.editSupplierTitle')"></span>
        <div class="form-error-tips"></div>
        <div class="form-content">
			<div class="form-collapses">
				<div class="fullline">
					<div class="wp-50">
						<span class="w-65 must-star" v-text="$t('supplierManage.supName')"></span>
						<div class="right-auto-box">
							<el-input id="txtSupName" v-model.trim="editModel.SupName" :maxlength="100"></el-input>
						</div>
					</div>
					<div class="wp-50 float-right">
						<span class="w-65" v-text="$t('supplierManage.supNo')"></span>
						<div class="right-auto-box">
							<el-input v-model.trim="editModel.SupNo" :maxlength="100"></el-input>
						</div>
					</div>  
				</div>

				<div class="fullline">
					<div class="wp-50">
						<span class="w-65 must-star" v-text="$t('supplierManage.area')"></span>
						<div class="right-auto-box">
							<sapi-area v-model="areaModel" clearable ></sapi-area>
						</div>
					</div>
					<div class="wp-50 float-right">
						<span class="w-65" v-text="$t('supplierManage.creditCode')"></span>
						<div class="right-auto-box">
							<el-input id="txtCreditCode" v-model.trim="editModel.CreditCode" :maxlength="18"></el-input>
						</div>
					</div>    
				</div>

				<div class="fullline">
					<span class="w-65 must-star" v-text="$t('supplierManage.className')"></span>
					<div class="right-auto-box">
						<sapi-select-btn v-model="editModel.SupplierClassRelats" :props="classRelatProps" height="56px" :has-more="true" @select="selectClassRelat"></sapi-select-btn>
					</div>
				</div>

				<div class="fullline">
					<span class="w-65 must-star" v-text="$t('supplierManage.businessLicence')"></span>
					<div class="right-auto-box">
							<sapi-upload :count="1" type=".jpg,.gif,.png,.jpeg,.svg" :has-load="false"
							:has-date="false"  :has-size="false"
							v-model="businessLicenceUrlModel"></sapi-upload>
					</div>
				</div>

				<div class="fullline">
					<div class="wp-50">
						<span class="w-65" v-text="$t('supplierManage.enterpriseForm')"></span>
						<div class="right-auto-box"> 
							<sapi-select v-model="editModel.EnterpriseForm" :data="enterpriseFormValues"
								:props="{label:'EnterpriseFormName',value:'EnterpriseForm'}"></sapi-select>
						</div>
					</div>
					<div class="wp-50 float-right">
						<span class="w-65" v-text="$t('supplierManage.taxPayer')"></span>
						<div class="right-auto-box">
							<sapi-select v-model="editModel.TaxPayerId" :data="taxPayerValues"
								:props="{label:'TaxPayerName',value:'TaxPayerId'}"></sapi-select>
						</div>
					</div>  
				</div>

				<div class="fullline">
					<div class="wp-50">
						<span class="w-65 " v-text="$t('supplierManage.legalRepresentative')"></span>
						<div class="right-auto-box">
							<el-input id="txtLegalRepresentative" v-model.trim="editModel.LegalRepresentative" :maxlength="20"></el-input>
						</div>
					</div>
					<div class="wp-50 float-right">
						<span class="w-65 " v-text="$t('supplierManage.registeredCapital')"></span>
						<div class="right-auto-box">
							<el-input id="txtRegisteredCapital" v-model.trim="editModel.RegisteredCapital" :maxlength="50"></el-input>
						</div>
					</div>  
				</div>

				<div class="fullline">
					<div class="wp-50">
						<span class="w-65 " v-text="$t('supplierManage.address')"></span>
						<div class="right-auto-box">
							<el-input id="txtAddress" v-model.trim="editModel.Address" :maxlength="1000"></el-input>
						</div>
					</div>
					<div class="wp-50 float-right">
						<span class="w-65 " v-text="$t('supplierManage.postalCode')"></span>
						<div class="right-auto-box">
							<el-input id="txtPostalCode" v-model.trim="editModel.PostalCode" :maxlength="20"></el-input>
						</div>
					</div>  
				</div>

				<div class="fullline">
					<div class="wp-50">
						<span class="w-65 " v-text="$t('supplierManage.officePhone')"></span>
						<div class="right-auto-box">
							<el-input id="txtOfficePhone" v-model.trim="editModel.OfficePhone" :maxlength="100"></el-input>
						</div>
					</div>
					<div class="wp-50 float-right">
						<span class="w-65 " v-text="$t('supplierManage.faxNumber')"></span>
						<div class="right-auto-box">
							<el-input id="txtFaxNumber" v-model.trim="editModel.FaxNumber" :maxlength="100"></el-input>
						</div>
					</div>  
				</div>

				<div class="fullline">
					<div class="wp-50">
						<span class="w-65" v-text="$t('supplierManage.email')"></span>
						<div class="right-auto-box">
							<el-input id="txtEmail" v-model.trim="editModel.Email" :maxlength="100"></el-input>
						</div>
					</div>
					<div class="wp-50 float-right">
						<span class="w-65" v-text="$t('supplierManage.officialWebsite')"></span>
						<div class="right-auto-box">
							<el-input id="txtOfficialWebsite" v-model.trim="editModel.OfficialWebsite" :maxlength="1000"></el-input>
						</div>
					</div>  
				</div>

				<div class="fullline">
					<span class="w-65 lh-30" v-text="$t('supplierManage.remark')"></span>
					<div class="right-auto-box">
						<el-input type="textarea" v-model="editModel.Remark" :autosize="{ minRows: 2, maxRows: 4}" :maxlength="200">
						</el-input>
					</div>
				</div>

				<div class="fullline">
					<span class="w-65" v-text="$t('supplierManage.setContact')"></span>
					<div class="right-auto-box">
						<div class="fullline">
							<div class="wp-50">
							</div>
							<div class="wp-50 float-right btn-outer">
								<ul class="btn-wrap">
									<li class="icon-build" @click="openAddDialog"></li>
									<li class="icon-deleter" @click="deleteContactItems"></li>
								</ul>
							</div>
						</div>
						<!--联系人列表-->
						<div class="common-table width-p100">
							<el-table border :data="tableContactData" ref="bodyTable" @selection-change="rowContactSelect" >				
								<el-table-column type="selection" width="45"></el-table-column>
								<el-table-column prop="ContactName" :label="$t('supplierManage.contactName')" width="120" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input id="txtContactName" v-model="props.row.ContactName" :maxlength="100"></el-input>
									</template>
								</el-table-column>
								<el-table-column prop="PositionName" :label="$t('supplierManage.positionName')" width="100" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input id="txtPositionName" v-model="props.row.PositionName" :maxlength="50"></el-input>
									</template>
								</el-table-column>
								<el-table-column prop="Sex" :label="$t('supplierManage.sex')" width="110" show-overflow-tooltip>
									<template slot-scope="props">
										<!-- {{props.row.Sex==0?"男":"女"}} -->
										<el-radio-group v-model="props.row.Sex">
											<el-radio class="radio" :label="0">{{$t('supplierManage.sexData.man')}}</el-radio>
											<el-radio class="radio" :label="1">{{$t('supplierManage.sexData.woman')}}</el-radio>
										</el-radio-group>
									</template>
								</el-table-column>
								<el-table-column prop="OfficePhone" :label="$t('supplierManage.officePhone')" width="150" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input id="txtContactOfficePhone" v-model="props.row.OfficePhone" :maxlength="100"></el-input>	
									</template>
								</el-table-column>
								<el-table-column prop="MobileTelephone" :label="$t('supplierManage.mobileTelephone')" width="150" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input id="txtContactMobileTelephone" v-model="props.row.MobileTelephone" :maxlength="100"></el-input>
									</template>
								</el-table-column>
								<el-table-column prop="Email" :label="$t('supplierManage.email')" min-width="120" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input id="txtContactEmail" v-model="props.row.Email" :maxlength="100"></el-input>
									</template>
								</el-table-column>
								<el-table-column :label="$t('handle')" fixed="right" width="50">
									<template slot-scope="props">
										<a  class="table-btn" href="javascript:void(0)" @click.stop="deleteContactItem(props.row,props.$index)" v-text="operateText.delete"></a>
									</template>
								</el-table-column>
							</el-table>
						</div>
					</div>
				</div>

				<div class="fullline">
					<span class="w-65" v-text="$t('supplierManage.setQualification')"></span>
					<div class="right-auto-box">
						<div class="fullline">
							<div class="wp-50">
							</div>
							<div class="wp-50 float-right btn-outer">
								<ul class="btn-wrap">
									<li class="icon-build" @click="openAddQualificationDialog"></li>
									<li class="icon-deleter" @click="deleteQualificationItems"></li>
								</ul>
							</div>
						</div>
						<!--供方资质-->
						<div class="common-table width-p100">
							<el-table border :data="tableQualficationDatas" ref="bodyTable" @selection-change="rowQualificationSelect" >				
								<el-table-column type="selection" width="45"></el-table-column>
								<el-table-column prop="QualificationName" :label="$t('supplierManage.qualificationName')" width="150" show-overflow-tooltip>
								</el-table-column>
								<el-table-column prop="ClassName" :label="$t('supplierManage.className')" width="150" show-overflow-tooltip>
								</el-table-column>
								<el-table-column prop="QualificationFile" :label="$t('supplierManage.qualificationFile')" min-width="150">
									<template slot-scope="props">
										<sapi-upload :count="5" type=".jpg,.gif,.png,.jpeg,.svg" :has-load="false" :has-size="false" :has-date="false" 
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
						<div class="fullline">
							<div class="wp-50">
							</div>
							<div class="wp-50 float-right btn-outer">
								<ul class="btn-wrap">
									<li class="icon-build" @click="addCaseRow"></li>
									<!-- <li class="icon-import" @click="importDialog"></li> -->
									<li class="icon-deleter" @click="deleteCaseItems"></li>
								</ul>
							</div>
						</div>
						<!--合作案例-->
						<div class="common-table width-p100">
							<el-table border :data="tableCaseData" ref="bodyTable"  @selection-change="rowCooperativeCaseSelect">
								<el-table-column type="selection" width="45"></el-table-column>
								<el-table-column prop="CooperativeTypeId" :label="$t('supplierManage.cooperativeType')" width="80" show-overflow-tooltip>
									<template slot-scope="props">
										<!-- {{props.row.CooperativeTypeId==1?"单次":"战略"}} -->
										<sapi-select v-model="props.row.CooperativeTypeId" :data="cooperativeTypes" :props="{label:'CooperativeTypeName',value:'CooperativeTypeId'}"></sapi-select>
									</template>
								</el-table-column>
								<el-table-column prop="CooperativeCompany" :label="$t('supplierManage.cooperativeCompany')" width="120" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input v-model="props.row.CooperativeCompany" :maxlength="100"></el-input>
									</template>
								</el-table-column>
								<el-table-column prop="CooperativeProjectName" :label="$t('supplierManage.cooperativeProjectName')" width="120" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input v-model="props.row.CooperativeProjectName" :maxlength="100"></el-input>
									</template>
								</el-table-column>
								<el-table-column prop="CooperativeRange" :label="$t('supplierManage.cooperativeRange')" width="120" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input v-model="props.row.CooperativeRange" :maxlength="100"></el-input>
									</template>
								</el-table-column>
								<el-table-column prop="ContractAmount" :label="$t('supplierManage.amountUnit')" width="120" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input v-model="props.row.ContractAmount" :min="0" :max="99999999" v-format.f2="{default:'0.00'}"></el-input>
									</template>
								</el-table-column>
								<el-table-column prop="CommencementDate" :label="$t('supplierManage.commencementDate')" width="300" show-overflow-tooltip>
									<template slot-scope="props">
										<el-date-picker style="width: 130px;" v-model="props.row.CommencementDate" type="date" :placeholder="$t('selectDate')">
										</el-date-picker>~
										<el-date-picker style="width: 130px;" v-model="props.row.CompletionDate" type="date" :placeholder="$t('selectDate')">
										</el-date-picker>
									</template>
								</el-table-column>
								<el-table-column prop="Remark" :label="$t('supplierManage.remark')" min-width="100" show-overflow-tooltip>
									<template slot-scope="props">
										<el-input v-model="props.row.Remark" :maxlength="200"></el-input>
									</template>
								</el-table-column>
							</el-table>
						</div>
					</div>
				</div>
			</div>
        </div>
        <div class="footer">
            <el-button size="small" class="default-button" @click="close" v-text="$t('cancel')"></el-button>
            <el-button size="small" class="blue-button" :disabled="disabled" @click="submit" v-text="$t('submit')"></el-button>
        </div>
	
		 <!-- 新增、修改组件 -->
    	<component :is="currentView" slot="moreDialog"  v-model="contactVisible" :option="contactOption" @call-back="selectContact" ></component>
		<!--导入组件-->
		<import-cooperativeCase v-model="importVisible" template-url="/Templates/Excel/Import/合作案例导入模板.xlsx" :title="$t('supplierManage.importCooperativeCaseTitle')" confirm-api="/api/plat/suppliers/import" @callback="importData">
		</import-cooperativeCase>
    </sapi-dialog>
</template>

<script>
	import supplier from "../../static/js/supplier.js";
    import tips from "@/components/sapi-tips.js";
    import dialog from "@/components/sapi-dialog.vue";
	import select from "@/components/sapi-select.vue";
	import upload from "@/components/sapi-upload.vue";
	import selectBtn from "@/components/sapi-select-btn.vue";
	import cooperativeCaseImport from "@/components/sapi-import.vue";
	import area from "@/components/sapi-area.vue";
	import '@/static/css/sapi-form-tab.css';

    export default {
        data() {
            return {
                disabled: false,
				visible: false,
				importVisible:false,
				supplierClasses:[],
				tableContactData: [],
				tableQualficationData:[],
				tableCaseData:[],
				caseIndex: 0,
				cooperativeTypes:
				[
					{
						"CooperativeTypeId": 1,
						"CooperativeTypeName": "单次"
					},
					{
						"CooperativeTypeId": 2,
						"CooperativeTypeName": "战略"
					},
				],
				contactOption:{},
				classRelatProps:{
					label:"ClassName"
				},
                editModel: {
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
				areaModel:{
					provinceId:null,
					provinceName:null,
					cityId:null,
					cityName:null,
					areaId:null,
					areaName:null
				},
				expand: {},
				businessLicenceUrlModel:{
                    Extension:null,
                    FileName:null,
                    FilePath:null,
                    Uploader:null,
                    UploaderId:null,
                    UploadDate:null
                },
				contactVisible:false,
				currentView:"",
				operateText:{
                	edit:this.$t('edit'),
                	delete:this.$t('delete')
				},   
				contactDeleteIds:[],
				qualificationDeleteIds:[],
				dooperativeCaseDeleteIds:[],
				qualificationFileModel:[], //资质文件
				taxPayerValues:supplier.TaxPayerValues, //纳税人类型
				enterpriseFormValues:supplier.EnterpriseFormValues, //企业类型
				errorTipsOption:{
					timeout: 2500,
					width: "330px"
				}
			}
		},
		computed:{
			tableQualficationDatas(I) {
				let arrs=[];
				if(this.editModel.SupplierClassRelats){
					this.editModel.SupplierClassRelats.forEach(row=>{
						this.tableQualficationData.forEach(data=>{
							if(data.ClassId===row.ClassId) {
								arrs.push(data);
							}
						});
					});
				}
				return arrs;
			}
		},
		props: ["option","value","title"],
		mixins: [getPagerMixin(), getTabMixin()],
        methods: {
			expandClick(index){
				this.expand[index]=!this.expand[index];
			},
			open() {
				this.getSupplierClasses();
                this.editModel = {
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
                this.getEditModel();
            },
            close() {
                this.$closeWaringTips(".form-error-tips");
                this.$emit("input", false); 
            },
            getEditModel() {	
				var params = {};
                this.$get("/api/plat/suppliers/"+this.option.SupId, params, function(res) {
					this.editModel = res;
					this.areaModel.provinceId=this.editModel.ProvinceId;
					this.areaModel.provinceName=this.editModel.ProvinceName;
					this.areaModel.cityId=this.editModel.CityId;
					this.areaModel.cityName=this.editModel.CityName;
					this.areaModel.areaId=this.editModel.AreaId;
					this.areaModel.areaName=this.editModel.AreaName;
					if(!res.BusinessLicence) {
						this.businessLicenceUrlModel = null;
                    }
                    else {
                        this.businessLicenceUrlModel = [{
                            Extension:"."+res.BusinessLicence.split(".")[1],
                            FileName:"营业执照",
                            FilePath:res.BusinessLicence,
                            Uploader:res.LastEditByName,
                            UploaderId:res.LastEditBy,
                            UploadDate:res.LastEditDate
						}]
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
					if(this.tableCaseData && this.tableCaseData.length > 0) {
						for(var i=0;i < this.tableCaseData.length;i++) {
							this.tableCaseData[i].Index = this.caseIndex += 1;
						}
					}
				});
            },
			openAddDialog() {
				this.contactVisible=true;
				this.currentView="contact-add";
			},
			openEditDialog(row,index) {
				this.contactVisible=true;
				this.contactOption=row;
				this.contactOption.Index=index;
				this.currentView="contact-edit";
			},
			addCaseRow() {
				var obj={              
                    CooperativeTypeId: "",
                    CooperativeCompany: "",
                    CooperativeProjectName: "",
                    CooperativeRange: "",
                    ContractAmount: "",
					CommencementDate: "",
					CompletionDate: "",
					Remark: "",
					Index: this.caseIndex += 1
				}
				this.tableCaseData.push(obj);
			},
			importDialog() {
				this.importVisible=true;
			},
			importData(res) {
				this.tableCaseData=res.ImportData;
				if(this.tableCaseData && this.tableCaseData.length > 0) {
					for(var i=0;i < this.tableCaseData.length;i++) {
						this.tableCaseData[i].Index = this.caseIndex += 1;
					}
				}
			},
			selectClassRelat() {
				this.contactOption=this.editModel.SupplierClassRelats;
				this.contactVisible=true;
				this.currentView="class-multi";
			},
			selectContact(res) {
				if(res) {
					if( res[1]=="contactAdd") {
						this.tableContactData.push(res[0]);
					}
					else if(res[1]=="contactEdit") {
						this.set(this.tableContactData, this.res[0].Index, this.res[0])				
					}
					else if(res[1]=="qualification") {
						//重新构建资质文件
						let qualficationData=[];
						if(this.tableQualficationData.length>0) {
							qualficationData=this.tableQualficationData;
							let isAdd = true;
							for(var i=0;i<res[0].length;i++)
							{
								for(var j=0;j<this.tableQualficationData.length;j++)
								{
									if(this.tableQualficationData[j].QualificationName == res[0][i].QualificationName
										&& this.tableQualficationData[j].ClassId == res[0][i].ClassId) {
										isAdd = false;
									}
								}
								if(isAdd) {
									qualficationData.push(res[0][i]);
								}
								isAdd = true;
							}
						}
						else {
							qualficationData = res[0];
						}
						this.tableQualficationData=qualficationData;
					}
					else if(res[1]=="class") {
						this.editModel.SupplierClassRelats=res[0];	
					}
				}
			},
			rowContactSelect(datas) {
				var _this = this;
				_this.contactDeleteIds = [];
				if(datas.length > 0) {
					datas.forEach(function(data) {
						_this.contactDeleteIds.push(data.ContactName); 
					});
				}
			},
			rowQualificationSelect(datas) {
				var _this = this;
				_this.qualificationDeleteIds = [];
				if(datas.length > 0) {
					datas.forEach(function(data) {
						_this.qualificationDeleteIds.push({QualificationName: data.QualificationName,ClassId: data.ClassId});
					});
				}
			},
			rowCooperativeCaseSelect(datas) {
				var _this = this;
				_this.dooperativeCaseDeleteIds = [];
				if(datas.length > 0) {
					datas.forEach(function(data) {
						_this.dooperativeCaseDeleteIds.push(data.Index);
					})
				}
			},
			deleteContactItem(row,index) {
				this.tableContactData.splice(index);
			},
			deleteContactItems() {
				var _this= this;
			    var ids=this.contactDeleteIds;
				for(var i=_this.tableContactData.length-1;i>-1;i--)
				{
					var contactName=_this.tableContactData[i].ContactName;
					var index=ids.indexOf(contactName);
					if(index>-1) {
						this.tableContactData.splice(i,1);
						ids.splice(index,1);
					}
				}
			},
			deleteQualificationItems() {
				var _this= this;
			    var ids=this.qualificationDeleteIds;
				for(var i=_this.tableQualficationData.length-1;i>-1;i--)
				{
					let qualificationName = _this.tableQualficationData[i].QualificationName;
					let supClassId = _this.tableQualficationData[i].ClassId;
					ids.forEach(data => {
						if(data.QualificationName == qualificationName && data.ClassId == supClassId) {
							this.tableQualficationData.splice(i,1);
						}
					});
				}
            },
            deleteCaseItems() {
				var _this= this;
			    var ids=this.dooperativeCaseDeleteIds;
				for(var i=_this.tableCaseData.length-1;i>-1;i--)
				{
					var delIndex=_this.tableCaseData[i].Index;
					var index=ids.indexOf(delIndex);
					if(index>-1) {
						this.tableCaseData.splice(i,1);
						ids.splice(index,1);
					}
				}
            },
			openAddQualificationDialog() {
				if(this.editModel.SupplierClassRelats.length==0) {
					Vue.msg(this.$t("supplierManage.classNameNotBeEmpty"));
					return;
				}
				let classIds = "";
				this.editModel.SupplierClassRelats.forEach(function(data) {
						classIds = classIds + data.ClassId + ",";
				});
				this.contactOption=classIds;
				this.contactVisible=true;
				this.currentView="qualification-multi";
			},
			getSupplierClasses:function(statusId) {
                this.$get("/api/plat/supplierClasses/brief", {}, function(res) {
                    this.supplierClasses = res;
				});
            },
            submit() {
				//所在地区
				if(this.areaModel){
					this.editModel.ProvinceId=this.areaModel.provinceId;
					this.editModel.ProvinceName=this.areaModel.provinceName;
					this.editModel.CityId=this.areaModel.cityId;
					this.editModel.CityName=this.areaModel.cityName;
					this.editModel.AreaId=this.areaModel.areaId;
					this.editModel.AreaName=this.areaModel.areaName;
				}
				//原图地址
                if(this.businessLicenceUrlModel.length >0) {
                    this.editModel.BusinessLicence = this.businessLicenceUrlModel[0].FilePath;
				}
				else {
					this.editModel.BusinessLicence = null;
				}
				//联系人信息
				this.editModel.SupplierContacts=this.tableContactData;
				//重新构建资质文件
				this.qualificationFileModel=[];
				for(var i=0;i<this.tableQualficationData.length;i++)
				{
					var _this=this.tableQualficationData[i];
					let keyName=_this.Index;
					if(_this[keyName].length>0) {
						let qualificationName=_this.QualificationName;
						let classId=_this.ClassId;
						for(var j=0;j<_this[keyName].length;j++)
						{
							var supplierQualificationFile={};
							supplierQualificationFile.QualificationName=qualificationName;
							supplierQualificationFile.ClassId=classId;
							supplierQualificationFile.FileName=_this[keyName][j].FileName;
							supplierQualificationFile.OriginalFilePath=_this[keyName][j].FilePath;
							this.qualificationFileModel.push(supplierQualificationFile);
						} 
					}
					else {
						Vue.msg(this.$t("supplierManage.qualificationFileNotBeEmpty"));
                    	return;
					}
				}
				this.editModel.SupplierQualificationFiles=this.qualificationFileModel;
				//合作案例
				this.editModel.SupplierCooperativeCases=this.tableCaseData;
				
                if (!this.validate()) {
                    return;
				}
                this.disabled = true;
                this.$put("/api/plat/suppliers/", this.editModel, function (res) {
					this.$parent.loadData();
					this.disabled=false;
					this.close();
					Vue.successMsg(this.$t('supplierManage.editSupplierSuccess'));
                });
            },
            validate() {
                this.$closeWaringTips(".form-error-tips");
                if(!this.editModel.SupName) {
                    this.$errorTips(this.$t('supplierManage.supNameNotBeEmpty'),"#txtSupName");
                    return false;
				}
				if(!this.editModel.ProvinceId) {
					Vue.msg(this.$t("supplierManage.provinceNotBeEmpty"));
                	return false;
				}
				if(!this.editModel.CityId) {
					Vue.msg(this.$t("supplierManage.cityNotBeEmpty"));
                	return false;
				}
				if(!this.editModel.AreaId) {
					Vue.msg(this.$t("supplierManage.areaNotBeEmpty"));
                	return false;
				}
				var msgASCIIContent = this.$t("inputASCIIContentPlease");
				if(this.editModel.CreditCode && !this.$checkedASCII(this.editModel.CreditCode)) {
					this.$errorTips(msgASCIIContent, "#txtCreditCode");
					return false;
				}
				if(this.editModel.SupplierClassRelats.length==0) {
					Vue.msg(this.$t("supplierManage.classNameNotBeEmpty"));
					return false;
				}
				if(!this.editModel.BusinessLicence) {
					Vue.msg(this.$t("supplierManage.businessLicenceNotBeEmpty"));
					return false;
				}
				if(this.editModel.PostalCode && !this.$checkedASCII(this.editModel.PostalCode)) {
					this.$errorTips(msgASCIIContent, "#txtPostalCode");
					return false;
				}
				if(this.editModel.OfficePhone && !this.$checkedASCII(this.editModel.OfficePhone)) {
					this.$errorTips(msgASCIIContent, "#txtOfficePhone");
					return false;
				}
				if(this.editModel.FaxNumber && !this.$checkedASCII(this.editModel.FaxNumber)) {
					this.$errorTips(msgASCIIContent, "#txtFaxNumber");
					return false;
				}
				if(this.editModel.Email && !this.$checkedASCII(this.editModel.Email)) {
					this.$errorTips(msgASCIIContent, "#txtEmail");
					return false;
				}
				var bValue=true;
				//校验联系人是否为空
				if(this.tableContactData.length>0) {
					for(var i=0;i<this.tableContactData.length;i++)
					{
						let contactName=this.tableContactData[i].ContactName;
						if(!contactName) {
							Vue.msg("第"+(i+1)+"行"+this.$t("supplierManage.contactNameNotBeEmpty"));
							bValue=false;
							break;
						}
						if(this.tableContactData[i].OfficePhone && !this.$checkedASCII(this.tableContactData[i].OfficePhone)) {
							Vue.msg("第"+(i+1)+"行"+this.$t("supplierManage.contactOfficePhoneASCIIContentPlease"), this.errorTipsOption);
							return false;
						}
						if(this.tableContactData[i].MobileTelephone && !this.$checkedASCII(this.tableContactData[i].MobileTelephone)) {
							Vue.msg("第"+(i+1)+"行"+this.$t("supplierManage.contactMobileTelephoneASCIIContentPlease"), this.errorTipsOption);
							return false;
						}
						if(this.tableContactData[i].Email && !this.$checkedASCII(this.tableContactData[i].Email)) {
							Vue.msg("第"+(i+1)+"行"+this.$t("supplierManage.contactEmailASCIIContentPlease"), this.errorTipsOption);
							return false;
						}
					}		
				}
				if(!bValue) {
					return false;
				}
                return true;
            }
        },
        components: {
            "sapi-dialog": dialog,
			"sapi-select": select,
			"sapi-select-btn":selectBtn,
			"sapi-upload":upload,
			"sapi-area":area,
			"contact-add": (resolve) => {
                require(['./contact-add.vue'], resolve);
			 },
			 "contact-edit": (resolve) => {
                require(['./contact-edit.vue'], resolve);
			 },
			 "qualification-multi": (resolve) => {
                require(['../class/qualification-multi.vue'], resolve);
			 },
			 "class-multi": (resolve) => {
                require(['../class/class-multi.vue'], resolve);
			 },
			 "import-cooperativeCase": cooperativeCaseImport,
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
<style>
	.cursor i{
	cursor: pointer;
}
.btn-outer .btn-wrap {
		list-style: none;
		border: 1px solid #bfbfbf;
		font-size: 0;
		border-radius: 2px;
		display: inline-block;
		height: 28px;
		position: absolute;
		right: 0;
		overflow: hidden;
	}
	
	.btn-outer .btn-wrap>li {
		display: inline-block;
		width: 28px;
		height: 28px;
		font-size: 16px;
		text-align: center;
		line-height: 28px;
		cursor: pointer;
	}
	
	.btn-outer .btn-wrap>li:first-child {
		border-right: 1px solid #bfbfbf;
	}
	.btn-outer .btn-wrap>li:last-child{
		border-right: none;
	}
	.btn-outer {
		position: relative;
	}
</style>

