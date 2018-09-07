<template>
	<sapi-dialog v-model="visible" width="1000px" top="10%" class="add" @on-open="open" @on-close="close">
		<span slot="title">{{$t('project.editProjectTitle')+tipField}}</span>
		<div class="form-error-tips"></div>
		<div class="form-content">
            <div class="form-collapses">
                <div class="form-collapses-item" :class="{'item-hide' : expand[0]===false}">
                    <div class="form-collapses-title" @click="expandClick(0)">
                        {{$t('project.group1')}}
                        <i class="el-icon-arrow-down"></i>
                    </div>
                    <div class="form-collapses-content">
                        <div class="fullline">
                            <div class="wp-50">
                                <span class="w-65 must-star" v-text="$t('project.projectName')"></span>
                                <div class="right-auto-box">
                                    <el-input id="txtProjectName" v-model.trim="editModel.ProjectName" :maxlength="100"></el-input>
                                </div>
                            </div>
                            <div class="wp-50 float-right">
                                <span class="w-65 must-star" v-text="$t('project.projectNo')"></span>
                                <div class="right-auto-box">
                                    <el-input id="txtProjectNo" v-model.trim="editModel.ProjectNo" :maxlength="100"></el-input>
                                </div>
                            </div>  
                        </div>

                        <div class="fullline">
                            <div class="wp-50">
                                <span class="w-65" v-text="$t('project.corpName')"></span>
                                <div class="right-auto-box">
                                    <el-input v-model.trim="editModel.CorpName" readonly></el-input>
                                </div>
                            </div>
                            <div class="wp-50 float-right">
                                <span class="w-65 must-star" v-text="$t('project.status')"></span>
                                <div class="right-auto-box">
                                    <sapi-select v-model="editModel.StatusId" :data="ProjectStatuss" :props="{label:'StatusName',value:'StatusId'}"></sapi-select>
                                </div>
                            </div>
                        </div>

                        <div class="fullline">
                            <div class="wp-50">
                                <span class="w-65" v-text="$t('project.type')"></span>
                                <div class="right-auto-box">
                                    <sapi-select v-model="editModel.TypeId" :data="ProjectTypes" :props="{label:'TypeName',value:'TypeId'}" @change="typeChange"></sapi-select>
                                </div>
                                
                            </div>
                            <div class="wp-50 float-right">
                                <span class="w-65" v-text="$t('project.area')"></span>
                                <div class="right-auto-box">
                                    <sapi-area v-model="areaModel" clearable ></sapi-area>
                                </div>
                            </div>
                        </div>

                        <div class="fullline">
                            <div class="wp-50">
                                <span class="w-65" v-text="$t('project.isPurchased')"></span>
                                <div class="right-auto-box">
                                    <el-radio-group v-model="editModel.IsPurchased">
                                        <el-radio class="radio" :label="true">{{$t("project.isPurchasedData.isTrue")}}</el-radio>
                                        <el-radio class="radio" :label="false">{{$t("project.isPurchasedData.isFalse")}}</el-radio>
                                    </el-radio-group>
                                </div>
                            </div>
                            <div class="wp-50 float-right">
                                <span class="w-65" v-text="$t('rowIndex')"></span>
                                <div class="right-auto-box">
                                    <el-input v-model="editModel.RowIndex" :min="0" :max="999999999" :controls="false" v-format.d="{default:0}"></el-input>
                                </div>
                            </div>
                        </div>

                        <div class="fullline" v-show="isShowParentProject" >
                            <div class="wp-50">
                                <span class="w-65" v-text="$t('project.parentProjectName')"></span>
                                <div class="right-auto-box">
                                    <el-input v-model.trim="parentProjectName" readonly></el-input>
                                </div>
                            </div>
                        </div>

                        <div class="fullline">
                            <span class="w-65 lh-30" v-text="$t('project.projectLands')"></span>
                            <div class="right-auto-box">
                                <sapi-select-btn v-model="editModel.ProjectLands" :props="landProps" height="56px" :has-more="true" @select="selectLands"></sapi-select-btn>
                            </div>
                        </div>

                        <div class="fullline">
                            <span class="w-65 lh-30" v-text="$t('project.projectAddress')"></span>
                            <div class="right-auto-box">
                                <el-input id="txtLandAddress" v-model.trim="editModel.ProjectAddress" :maxlength="200"></el-input>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-collapses-item" :class="{'item-hide' : expand[1]===false}">
                    <div class="form-collapses-title" @click="expandClick(1)">
                        {{$t('project.group2')}}
                        <i class="el-icon-arrow-down"></i>
                    </div>
                    <div class="form-collapses-content">
                        <div class="fullline">
                            <span class="w-65 lh-30" v-text="$t('project.imageModel')"></span>
                            <div class="right-auto-box">
                                <sapi-upload :count="1" type=".jpg,.gif,.png,.jpeg,.svg" :has-load="false" :has-date="false" 
                                v-model="imageModel" :has-size="false"></sapi-upload>
                            </div>
                        </div>

                        <div class="fullline">
                            <span class="w-65 lh-30" v-text="$t('project.remark')"></span>
                            <div class="right-auto-box">
                                <el-input :maxlength="200" type="textarea" :autosize="{ minRows: 2, maxRows: 4}" v-model="editModel.Remark">
                                </el-input>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
		</div>

		<div class="footer">			
			<el-button size="small" class="default-button" @click="close" v-text="$t('cancel')"></el-button>
			<el-button class="blue-button" size="small" :disabled="disabled" @click="submit" v-text="$t('submit')"></el-button>
		</div>

        <component :is="currentView" slot="moreDialog"  v-model="landVisible" :option="landOption" @call-back="selectedLands"></component>
	</sapi-dialog>
</template>

<script>
	import tips from "@/components/sapi-tips.js";
    import dialog from "@/components/sapi-dialog.vue";
    import select from "@/components/sapi-select.vue";
    import upload from "@/components/sapi-upload.vue";
    import selectBtn from "@/components/sapi-select-btn.vue";
    import formatMixin from "@/components/sapi-directive-input.js"
    import area from "@/components/sapi-area.vue";

    import '@/static/css/sapi-form-tab.css';

	export default {
		data() {
			return {
                tipField: this.$t('project.tipField'),
				disabled: false,
                visible: false,
                Corps:[],          //公司
                ProjectStatuss:[], //项目状态
                ProjectTypes:[],   //项目类别
                imageModel:[{
                    Extension:"",
                    FileName:"",
                    FilePath:"",
                    FileSize:"",
                    UploadDate:"",
                    Uploader:"",
                    UploaderId:""
                }],
                landProps:{
                    label:"LandName"
                },
                parentProjectName:"",
                isShowParentProject:false,
				editModel: {
                    ProjectName: null,
                    ProjectNo:null,
					StatusId: null,
                    ParentProjectId:null,
                    CorpId: null,
                    CorpName:null,
                    ProvinceId:null,
                    ProvinceName:null,
                    CityId:null,
                    CityName:null,
                    AreaId:null,
                    AreaName:null,
                    IsPurchased:null,
                    TypeId:null,
                    TypeName:null,
                    ProjectAddress:null,
                    ProjectMapPosition:null,
                    ProjectImgUrl1:null,
                    ProjectImgUrl2:null,
                    ProjectImgThumbnail:null,
                    Remark:null,
                    ProjectLands:[]
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
                currentView:"",
                landVisible:false,
                companys: [],
                landOption:{},
                lastSelectedLandIds:[]
			}
		},
        props: ["option","value"],
        mixins: [formatMixin],
		methods: {
            open() {
                this.tipField = this.option.ParentProjectId?this.$t('project.tipFieldChild'):this.$t('project.tipField');
                 this.isShowParentProject = !!this.option.ParentProjectId;
                this.getProject();
                this.getProjectStatuss();
                this.getProjectTypes();
            },
            close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input", false);
			},
			submit() {
                if(this.areaModel){
					this.editModel.ProvinceId=this.areaModel.provinceId;
					this.editModel.ProvinceName=this.areaModel.provinceName;
					this.editModel.CityId=this.areaModel.cityId;
					this.editModel.CityName=this.areaModel.cityName;
					this.editModel.AreaId=this.areaModel.areaId;
					this.editModel.AreaName=this.areaModel.areaName;
				}

				if(!this.validate()) {
					return;
                }
                this.disabled = true;
                //原图地址
                this.editModel.ProjectImgUrl1 = this.imageModel && this.imageModel.length>0 ? this.imageModel[0].FilePath : null;
                //当类别选择“请选择”，提交时清空值
                if(!this.editModel.TypeId)
                {
                    this.editModel.TypeName = null;
                    this.editModel.TypeId = null;
                }
				
				this.$put("/api/plat/projects/", this.editModel, function(res) {
					this.disabled = false;
					this.$emit("callback",this.option.OperType);
					this.close();
					Vue.successMsg(this.$t("project.editProjectSuccess"));
				});
			},
			validate() {							
				if(!this.editModel.ProjectName) {
					this.$errorTips(this.$t("project.projectNameNotBeEmpty"), "#txtProjectName");
					return false;
				} 				
				if(!this.editModel.ProjectNo) {
					this.$errorTips(this.$t("project.projectNoNotBeEmpty"), "#txtProjectNo");
					return false;
                }
                if(!this.editModel.CorpId) {
					Vue.msg(this.$t("project.selectCorpPlease"));
					return false;
                }
                if(!this.editModel.StatusId) {
					Vue.msg(this.$t("project.selectStatusPlease"));
					return false;
                }
				return true;
			},
            getProject:function(){
                this.$get("/api/plat/projects/"+this.option.ProjectId, {}, function(res) {
                    this.editModel = res;
                    this.parentProjectName = res.ParentProjectName;
                    this.areaModel.provinceId=this.editModel.ProvinceId;
					this.areaModel.provinceName=this.editModel.ProvinceName;
					this.areaModel.cityId=this.editModel.CityId;
					this.areaModel.cityName=this.editModel.CityName;
					this.areaModel.areaId=this.editModel.AreaId;
					this.areaModel.areaName=this.editModel.AreaName;
                    if(!res.ProjectImgUrl1)
                    {
                        this.imageModel = null;
                    }
                    else
                    {
                        this.imageModel = [{
                            Extension:"."+res.ProjectImgUrl1.split(".")[1],
                            FileName:"封面图",
                            FilePath:res.ProjectImgUrl1,
                            Uploader:res.LastEditByName,
                            UploaderId:res.LastEditBy,
                            UploadDate:res.LastEditDate
                        }]
                    }
                    
                   this.getCorps(this.editModel.CorpId);
                });
            },
            getCorps:function(corpId){
                this.$get("/api/plat/structures/"+corpId+"/parentAndSiblings", {}, function(res) {
                    this.companys = res;
				});
            },
            getProjectStatuss:function(){
                this.$get("/api/plat/projectStatuses/brief", {}, function(res) {
                    this.ProjectStatuss = res;
				});
            },
            getProjectTypes:function(){
                this.$get("/api/plat/projectTypes/brief", {}, function(res) {
                    this.ProjectTypes = res;
                    var projectType =  { TypeId:"", TypeName:"请选择" };
                    this.ProjectTypes.splice(0,0,projectType);
				});
            },
            expandClick(index){
				this.expand[index]=!this.expand[index];
            },
            //打开选择地块窗口
            selectLands(){
                this.landVisible = true;
                this.landOption.ProvinceId = this.areaModel.provinceId;
                this.landOption.CityId = this.areaModel.cityId;
                this.landOption.AreaId = this.areaModel.areaId;
                var lands = this.editModel.ProjectLands;
                this.lastSelectedLandIds = [];
                for(var i=0;i<lands.length;i++)
                {
                    this.lastSelectedLandIds.push(lands[i].LandId);
                }
                this.landOption.LastSelectedLandIds = this.lastSelectedLandIds;
                this.landOption.SelectedLands = lands;
                this.currentView="land-select";
            },
            selectedLands(res){
                for(var i=0;i<res.length;i++)
                {
                    var row = res[i];
                    if(this.lastSelectedLandIds.indexOf(row.LandId) == -1)
                    {
                        this.editModel.ProjectLands.push(row);
                    }
                }
            },
             //切换项目类别
            typeChange(res){
                if(res)
                {
                    this.editModel.TypeName = res.TypeName;
                }
            }
		},
		components: {
            "sapi-upload": upload,
            "sapi-dialog": dialog,
            "sapi-select": select,
            "sapi-select-btn":selectBtn,
            "sapi-area":area,
            "land-select": (resolve) => {
				require(['../land/land-multi.vue'], resolve);
			}
		},
		watch: {
			value(val) {
				this.visible = this.value;
			}
		},
		created() {
            for(var i = 0; i < 2; i++) {
				this.$set(this.expand, i, true);
			}
			Vue.use(tips);
		},
		mounted(){
			this.visible=this.value;
		}
	}
</script>
