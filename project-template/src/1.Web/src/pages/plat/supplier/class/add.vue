<template>
    <sapi-dialog class="class-add" v-model="visible" width="700px" top="13%" @on-open="open" @on-close="close">
        <span slot="title" v-text="title"></span>
        <div class="form-error-tips"></div>
        <div class="form-content">
            <div class="fullline">
                <span class="w-80 must-star" v-text="$t('supplierClass.className')"></span>
                <div class="right-box">
                    <el-input id="txtClassName"  v-model.trim="createModel.ClassName" :maxlength="100"></el-input>
                </div>
            </div>
            <div class="fullline">
                <span class="w-80 lh-30"  :class="{'must-star':!bChild}" v-text="$t('supplierClass.baseClassName')"></span>
                <div class="right-box" v-if="!bChild">
                     <sapi-select v-model="createModel.BaseClassId" :data="supplierBaseClasses"
                     :props="{label:'ClassName',value:'ClassId'}"></sapi-select>
                </div>
                <div class="right-box" v-else>
                    <el-input v-model="option.BaseClassName" readonly></el-input>
                </div>
            </div>
            <div class="fullline">
                <span class="w-80 lh-30" v-text="$t('supplierClass.remark')"></span>
                <div class="right-box">
                    <el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4}" v-model="createModel.Remark" :maxlength="200"></el-input>
                </div>
            </div>
            <!--供方资质-->
            <div class="fullline">
                <span class="w-80 line-height" v-text="$t('supplierClass.qualification')"></span>
                <div class="right-box width-p100">
                    <div class="mb-10">
						<el-button size="small" :plain="true" type="button" @click="openAddDialog" v-text="$t('supplierClass.addQualification')"></el-button>
					</div>
                    <el-table class="common-table" :data="createModel.SupplierQualifications">
                        <el-table-column prop="QualificationName" :label="$t('supplierClass.qualificationName')" width="150" show-overflow-tooltip>
                        </el-table-column>
                        <el-table-column prop="Remark" :label="$t('supplierClass.remark')" min-width="" show-overflow-tooltip>
                        </el-table-column>				
                        <el-table-column prop="RowIndex" :label="$t('rowIndex')" width="100" show-overflow-tooltip>
                        </el-table-column>
                        <el-table-column :label="$t('handle')" width="100">
                            <template slot-scope="scope">
                                <a class="table-btn" href="javascript:void(0)" @click.stop="openEditDialog(scope.row,scope.$index)" v-text="operateText.edit"></a>
                                <a class="table-btn" href="javascript:void(0)" @click.stop="deleteItem(scope.row,scope.$index)" v-text="operateText.delete"></a>
                            </template>
						</el-table-column>
                    </el-table>
                </div>
            </div>
        </div>

        <div class="footer">
            <el-button size="small" class="default-button" @click="close" v-text="$t('cancel')"></el-button>
            <el-button size="small" class="blue-button" :disabled="disabled" @click="submit" v-text="$t('submit')"></el-button>
        </div>

        <!--添加、修改处理路径-->
		<component slot="moreDialog" v-bind:is="currentView" :index="rowIndex" :title="currentTitle" v-model="currentVisible" :option="currentModel" :rowIndex="qualificationRowIndex" @callback="backModel"></component>
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
                supplierBaseClasses:[],
                bChild:false,
                rowIndex: 0,
                qualificationRowIndex: 10,
                currentModel: [],
                currentView: null,
                currentVisible: false,
                currentTitle: null,
                createModel: { 
                    ParentClassId:"",
                    BaseClassId:"",
                    ClassName: "",
                    Remark: "",
                    SupplierQualifications: []
                },
                operateText:{
                	edit:this.$t('edit'),
                	delete:this.$t('delete')
                }             
            }
        },
        props: ["option","value","isAddChild","title"],
        methods: {
            getSupplierBaseClasses:function(){
                this.$get("/api/plat/supplierBaseClasses/brief", {}, function(res) {
                    this.supplierBaseClasses = res;
				});
            },
            close() {
                this.$closeWaringTips(".form-error-tips");
                this.$emit("input", false); 
            },
            open() {
                this.bChild = this.isAddChild;
                this.getSupplierBaseClasses();
                this.createModel = this.option;
                this.createModel.SupplierQualifications = [];
            },
            openAddDialog() {
				this.currentTitle = this.$t('supplierClass.addQualification');
				if(this.createModel.SupplierQualifications.length > 0){
                    this.currentModel = this.createModel.SupplierQualifications;
                    this.qualificationRowIndex = this.createModel.SupplierQualifications[this.createModel.SupplierQualifications.length - 1].RowIndex + 10;
                }
				this.currentView = "qualification-add";
				this.currentVisible = true;
            },
            openEditDialog(row, index) {
				this.currentTitle = this.$t('supplierClass.editQualification');
				this.currentModel = this.createModel;
				this.currentView = "qualification-edit";
				this.currentVisible = true;
				this.rowIndex = index;
            },
            deleteItem(row,i){
				this.createModel.SupplierQualifications.splice(i, 1);
			},
            backModel(data, isEditUrl) {
				if(isEditUrl === true) {
                    this.$set(this.createModel.SupplierQualifications,this.rowIndex,data);
				} else {
					this.createModel.SupplierQualifications.push(data);
				}
			},
            submit() {
                if (!this.validate()) {
                    return;
                }
                this.disabled = true;
                this.$post("/api/plat/supplierClasses/", this.createModel, function (res) {
                    this.disabled=false;
                    this.$parent.getSupplierClassTree();
                    this.createModel.ParentClassId="";
                    this.createModel.BaseClassId="";
                    this.createModel.ClassName="";

                    this.close();
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
                   Vue.msg(this.$t("supplierClass.baseClassNameNotBeEmpty"));
                   return false;
                }
                return true;
            }
        },
        components: {
            "sapi-dialog": dialog,
            "sapi-select": select,
            "qualification-add": (resolve) => {
				require(['./qualification-add.vue'], resolve);
			},
			"qualification-edit": (resolve) => {
				require(['./qualification-edit.vue'], resolve);
			}
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

<style>
.class-add .right-auto-box{
	display: inline-block;
	width: calc(100% - 90px);
	vertical-align: top;
}
.class-add .line-height{
	line-height: 24px;
}
</style>
