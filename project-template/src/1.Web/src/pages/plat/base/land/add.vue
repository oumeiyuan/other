<template>
	<sapi-dialog v-model="visible" width="800px" top="28%" class="add" @on-open="open" @on-close="close">
		<span slot="title" v-text="$t('land.addLandTitle')"></span>
		<div class="form-error-tips"></div>
		<div class="form-content">
            <div class="fullline">
				<div class="wp-50">
					<span class="w-65 must-star" v-text="$t('land.landName')"></span>
					<div class="right-auto-box">
						<el-input id="txtLandName" v-model.trim="createModel.LandName" :maxlength="100"></el-input>
					</div>
				</div>
				<div class="wp-50 float-right">
					<span class="w-65 must-star" v-text="$t('land.landNo')"></span>
					<div class="right-auto-box">
						<el-input id="txtLandCode" v-model.trim="createModel.LandNo" :maxlength="100"></el-input>
					</div>
				</div>
			</div>

            <div class="fullline">
                <div class="wp-50">
                    <span class="w-65 must-star" v-text="$t('land.area')"></span>
                    <div class="right-auto-box">
						<sapi-area v-model="areaModel" clearable ></sapi-area>
                    </div>
                </div>
            
				<div class="wp-50 float-right">
					<span class="w-65 must-star" v-text="$t('land.landAddress')"></span>
					<div class="right-auto-box">
						<el-input id="txtLandAddress" v-model.trim="createModel.LandAddress" :maxlength="200"></el-input>
					</div>
				</div>
			</div>

            <div class="fullline">
				<div class="wp-50">
                    <span class="w-65 must-star" v-text="$t('land.isBidInvitation')"></span>
					<div class="right-auto-box">
					    <el-radio-group v-model="createModel.IsBidInvitation">
                            <el-radio class="radio" :label="true">{{$t("land.isBidInvitationData.isTrue")}}</el-radio>
                            <el-radio class="radio" :label="false">{{$t("land.isBidInvitationData.isFalse")}}</el-radio>
					    </el-radio-group>
					</div>
				</div>
				<div class="wp-50 float-right">
					<span class="w-65" v-text="$t('land.landUsage')"></span>
					<div class="right-auto-box">
						<el-input v-model.trim="createModel.LandUsage" :maxlength="20"></el-input>
					</div>
				</div>
			</div>

            <div class="fullline">
				<div class="wp-50">
					<span class="w-65" v-text="$t('land.landArea')"></span>
					<div class="right-auto-box">
						<el-input id="txtLandArea" v-model.trim="createModel.LandArea" :maxlength="100"></el-input>
					</div>
				</div>
				<div class="wp-50 float-right">
					<span class="w-65" v-text="$t('land.grantYear')"></span>
					<div class="right-auto-box">
						<el-input v-model.trim="createModel.GrantYear" :maxlength="10"></el-input>
					</div>
				</div>
			</div>

            <div class="fullline">
				<span class="w-65 lh-30" v-text="$t('land.remark')"></span>
				<div class="right-auto-box">
					<el-input  v-model="createModel.Remark" :maxlength="200" type="textarea" :autosize="{ minRows: 2, maxRows: 4}">
					</el-input>
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
    import select from "@/components/sapi-select.vue";
	import area from "@/components/sapi-area.vue";

	export default {
		data() {
			return {
				disabled: false,
				visible: false,
				createModel: {
					LandName: null,
                    LandAddress: null,
					ProvinceId:null,
					ProvinceName:null,
					CityId:null,
					CityName:null,
					AreaId:null,
					AreaName:null,
                    LandNo:null,
                    LandMapPosition:"",
                    LandArea:null,
                    IsBidInvitation:null,
                    LandUsage:null,
                    GrantYear:null,
                    Remark:null
                },
				areaModel:{
					provinceId:null,
					provinceName:null,
					cityId:null,
					cityName:null,
					areaId:null,
					areaName:null
				}
			}
		},
		props: ["value"],
		methods: {
            open() {
				this.createModel= {
					LandName: null,
                    LandAddress: null,
					ProvinceId:null,
					ProvinceName:null,
					CityId:null,
					CityName:null,
					AreaId:null,
					AreaName:null,
                    LandNo:null,
                    LandMapPosition:"",
                    LandArea:null,
                    IsBidInvitation:null,
                    LandUsage:null,
                    GrantYear:null,
                    Remark:null
                };
				this.areaModel={
					provinceId:null,
					provinceName:null,
					cityId:null,
					cityName:null,
					areaId:null,
					areaName:null
				};
            },
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input", false);
			},
			submit() {

				if(this.areaModel){
					this.createModel.ProvinceId=this.areaModel.provinceId;
					this.createModel.ProvinceName=this.areaModel.provinceName;
					this.createModel.CityId=this.areaModel.cityId;
					this.createModel.CityName=this.areaModel.cityName;
					this.createModel.AreaId=this.areaModel.areaId;
					this.createModel.AreaName=this.areaModel.areaName;
				}

				if(!this.validate()) {
					return;
                }
                this.disabled = true;

				this.$post("/api/plat/lands/", this.createModel, function(res) {
					this.disabled = false;
					this.$parent.loadData();
					this.close();
					Vue.successMsg(this.$t("land.addLandSuccess"));
				});
			},
			validate() {	
                if(!this.createModel.LandName) {
					this.$errorTips(this.$t("land.landNameNotBeEmpty"), "#txtLandName");
					return false;
				}
				if(!this.createModel.LandNo){
					this.$errorTips(this.$t("land.landNoNotBeEmpty"), "#txtLandCode");
					return false;
                }						
				if(!this.createModel.ProvinceName) {
                    Vue.msg(this.$t("land.selectProvinceName"));
					return false;
                } 		
                if(!this.createModel.CityName) {
                    Vue.msg(this.$t("land.selectCityName"));
					return false;
				} 		
				if(!this.createModel.LandAddress) {
					this.$errorTips(this.$t("land.landAddressNotBeEmpty"), "#txtLandAddress");
					return false;
                }
                if (!this.$checkedASCII(this.createModel.LandMapPosition)){
					this.$errorTips(this.$t("land.landMapPositionCheckedASCII"), "#txtLandAddress");
					return false;
				}	
                if(this.createModel.IsBidInvitation === null || this.createModel.IsBidInvitation === undefined){
                    Vue.msg(this.$t("land.selectIsBidInvitationPlease"));
                    return false;
                }
                
				return true;
			}
		},
		components: {
            "sapi-dialog": dialog,
            "sapi-select": select,
			"sapi-area":area
		},
		watch: {
			value(val) {
				this.visible = this.value;
			}
		},
		created() {
			Vue.use(tips);
		},
		mounted(){
			this.visible=this.value;
		}
	}
</script>
