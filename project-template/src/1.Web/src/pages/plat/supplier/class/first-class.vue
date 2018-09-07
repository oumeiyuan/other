<template>
	<div class="no-data-wrapper">
		<div class="supplierClass-logo">
			<img src="../../../../static/images/structure_flag.png" />
		</div>
		<p class="stru-msg">{{$t('supplierClass.listClassTitle')}}</p>
		<div class="fullline">
			<span class="w-65 must-star" v-text="$t('supplierClass.className')"></span>
			<div class="right-auto-box">
				<el-input id="txtClassName" v-model.trim="createModel.ClassName"  :maxlength="100"></el-input>
			</div>
		</div>

        <div class="fullline">
			<span class="w-65 must-star" v-text="$t('supplierClass.baseClassName')"></span>
			<div class="right-auto-box">
					<sapi-select v-model="createModel.BaseClassId" :data="supplierBaseClasses" :props="{label:'ClassName',value:'ClassId'}"></sapi-select>
			</div>
        </div>

		<div class="fullline">
			<span class="w-65" v-text="$t('supplierClass.remark')"></span>
			<div class="right-auto-box">
				<el-input :maxlength="200" type="textarea" :autosize="{ minRows: 2, maxRows: 4}" v-model="createModel.Remark">
				</el-input>
			</div>
		</div>
		<div class="stru-form-btn" @click="save" v-text="$t('supplierClass.addSupplierClass')"></div>
	</div>
</template>

<script>

    import select from "@/components/sapi-select.vue";

	export default {
		data() {
			return {
                supplierBaseClasses:{},
				createModel: {
                    ClassName:"",
                    ParentClassId:null,
                    BaseClassId:"",
                    Remark:""
				},
			}
		},
		methods: {
			getSupplierBaseClasses:function(){
				this.$get("/api/plat/supplierBaseClasses/brief", {}, function(res) {
					this.supplierBaseClasses = res;
				});
			},
			save() {
				if (!this.validate()) {
					return;
				}
				this.disabled = true;
				this.$post("/api/plat/supplierClasses/", this.createModel, function (res) {
					this.$parent.getSupplierClassTree();
					Vue.successMsg(this.$t('supplierClass.addSupplierClassSuccess'));
				});
            },
			validate() {
                this.$closeWaringTips(".form-error-tips");
                if(!this.createModel.ClassName) {
                    this.$errorTips(this.$t('supplierClass.classNameNotBeEmpty'),"#txtClassName");
                    return false;
                }
                if(!this.createModel.BaseClassId){
                   Vue.msg(this.$t("supplierClass.parentClassNameNotBeEmpty"));
                   return false;
                }
                return true;
            }
        },
        components: {
            "sapi-select": select
        },
        created() {
            
            this.getSupplierBaseClasses();
		}
	}
</script>

<style>
	.no-data-module {
		width: 100%;
		height: 100%;
	}
	
	.no-data-wrapper {
		position: absolute;
		left: 50%;
		margin-left: -210px;
		top: 60px;
		width: 420px;
		height: 412px;
	}
	
	.supplierClass-logo>img {
		display: block;
		margin: 0 auto;
		padding-left: 65px;
	}
	
	.no-data-wrapper .stru-msg {
		text-align: center;
		font-size: 14px;
		color: #999999;
		padding-left: 65px;
		margin: 50px 0 20px 0;
	}
	
	.no-data-wrapper .stru-form-btn {
		background-color: #6ecdfa;
		width: 350px;
		height: 38px;
		border-radius: 4px;
		text-align: center;
		color: #fff;
		font-size: 15px;
		line-height: 38px;
		margin: 56px 0 0 68px;
		cursor: pointer;
	}
</style>