<template>
	<div class="edit-model clearfix">
		<div class="edit-model-content">
			<div class="fullline">
                <span class="w-80 must-star" v-text="$t('supplierClass.className')"></span>
                <div class="right-box">
                    <el-input id="txtClassName" v-model.trim="editModel.ClassName" :maxlength="100"></el-input>
                </div>
            </div>
            <div class="fullline">
                <span class="w-80" :class="{'must-star':!isChild}" v-text="$t('supplierClass.baseClassName')"></span>
                <div class="right-box" v-if="!isChild">
                     <sapi-select v-model="editModel.BaseClassId" :data="supplierBaseClasses"
                     :props="{label:'ClassName',value:'ClassId'}"></sapi-select>
                </div>                
                <div class="right-box" v-else>
                    <el-input v-model="editModel.BaseClassName" readonly></el-input>
                </div>
            </div>
            <div class="fullline" v-show="editModel.Level > 1">
                <span class="w-80" v-text="$t('supplierClass.parentClassName')"></span>
                <div class="right-box">
                    <el-input v-model="editModel.ParentClassName" readonly></el-input>
                </div>
            </div>
            <div class="fullline">
                <span class="w-80" v-text="$t('rowIndex')"></span>
                <div class="right-box">
                    <el-input v-model="editModel.RowIndex" :min="0" :max="999999999" :controls="false" v-format.d="{default:0}"></el-input>
                </div>
            </div>
            <div class="fullline">
                <span class="w-80" v-text="$t('supplierClass.remark')"></span>
                <div class="right-box">
                    <el-input :maxlength="200" type="textarea" :autosize="{ minRows: 2, maxRows: 4}" v-model="editModel.Remark">
                    </el-input>
                </div>
            </div>
            <!--供方资质-->
            <div class="fullline">
                <span class="w-80 line-height" v-text="$t('supplierClass.qualification')"></span>
                <div class="right-box width-p100">
                    <div class="mb-10">
						<el-button size="small" :plain="true" type="button" @click="openAddDialog" v-text="$t('supplierClass.addQualification')"></el-button>
					</div>
                    <el-table class="common-table" :data="editModel.SupplierQualifications">
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

		<div class="edit-footer">
			<el-button size="small" @click="cancel" class="default-button padding-button" v-text="$t('cancel')"></el-button>
			<el-button class="blue-button padding-button" :disabled="disabled" size="small" @click="save" v-text="$t('submit')"></el-button>			
		</div>

        <!--添加、修改处理路径-->
		<component slot="moreDialog" v-bind:is="currentView" :index="rowIndex" :title="currentTitle" v-model="currentVisible" :option="currentModel" :rowIndex="qualificationRowIndex" @callback="backModel"></component>
	</div>
</template>

<script>
    import select from "@/components/sapi-select.vue";
    import formatMixin from "@/components/sapi-directive-input.js"

	export default {
		data() {
			return {
				editModel: {
                    ClassId: "",
					ClassName: "",
					ParentClassId: "",
                    BaseClassId: "",
                    RowIndex:"",
                    Remark: "",
                    SupplierQualifications: []
                },
                rowIndex: 0,
                qualificationRowIndex: 10,
                currentModel: {},
                currentView: null,
                currentVisible: false,
                currentTitle: null,
                operateText:{
                	edit:this.$t('edit'),
                	delete:this.$t('delete')
                },
                supplierBaseClasses:[],
                disabled:false,
                isChild:false
			}
		},
        props: ["option"],
        methods: {
 			getSupplierBaseClasses:function(){
                this.$get("/api/plat/supplierBaseClasses/brief", {}, function(res) {
                    this.supplierBaseClasses = res;
				});
            },
            openAddDialog() {
				this.currentTitle = this.$t('supplierClass.addQualification');
                if(this.editModel.SupplierQualifications.length > 0){
                    this.currentModel = this.editModel.SupplierQualifications;
                    this.qualificationRowIndex = this.editModel.SupplierQualifications[this.editModel.SupplierQualifications.length - 1].RowIndex + 10;
                }
				this.currentView = "qualification-add";
				this.currentVisible = true;
            },
            openEditDialog(row, index) {
				this.currentTitle = this.$t('supplierClass.editQualification');
				this.currentModel = this.editModel;
				this.currentView = "qualification-edit";
				this.currentVisible = true;
				this.rowIndex = index;
            },
            deleteItem(row,i){
				this.editModel.SupplierQualifications.splice(i, 1);
			},
            backModel(data, isEdit) {
				if(isEdit === true) {
                    this.$set(this.editModel.SupplierQualifications,this.rowIndex,data);
				} else {
					this.editModel.SupplierQualifications.push(data);
				}
			},
			save() {
                if(this.validate()) {
                    this.disabled = false;
                    this.$put("/api/plat/supplierClasses/", this.editModel, function(res) {
                        this.disabled = false;
                        this.$parent.getSupplierClassTree();
                        this.editModel = {
                            ClassId: "",
							ClassName: "",
							ParentClassId: "",
							BaseClassId: "",
							RowIndex: "",
							Remark: ""
                        };

                        Vue.successMsg(this.$t('supplierClass.editSupplierClassSuccess'));
				    });
                }
			},
			validate() {
				if(!this.editModel.ClassName) {
					this.$errorTips(this.$t('supplierClass.classNameNotBeEmpty'), "#txtClassName",{isDown:true});
					return false;
                } 
                if(!this.editModel.BaseClassId) {
                    Vue.msg(this.$t('supplierClass.baseClassNameNotBeEmpty'));
					return false;
                }                 
				return true;
            },	
            cancel() {
				this.$emit('viewBack');
			},
            //初始化模型		
			initEditModel(val){
				this.getSupplierBaseClasses();
				this.editModel = val;
                if(val.ParentClassId){
                    this.isChild = true;
                }
                else{
                    this.isChild = false;
                }
			}
		},
        mixins: [formatMixin],
		components: {
            "sapi-select":select,
            "qualification-add": (resolve) => {
				require(['./qualification-add.vue'], resolve);
			},
			"qualification-edit": (resolve) => {
				require(['./qualification-edit.vue'], resolve);
			}
		},
		watch: {
			option(val) {
				this.changeFlag = false;
				if(val && typeof val === "object") {
					this.initEditModel(val);
				} else {
					this.editModel = {};
				}
			}
		},
		mounted() {
			if(this.option && typeof this.option === "object") {
				this.initEditModel(this.option);
			}
		}
	}
</script>

<style>
	.edit-model {
		height: 100%;
		position: relative;
	}
	
	.edit-model .edit-model-content {
		height: calc(100% - 58px);
		overflow: auto;
		padding: 30px 15px 15px 15px;
	}
	
	.edit-model .edit-footer {
		position: absolute;
		bottom: 0;
		width: 100%;
		height: 58px;
		text-align: center;
		padding-top: 15px;
		box-shadow: 5px 1px 5px 5px #eee;
	}
</style>