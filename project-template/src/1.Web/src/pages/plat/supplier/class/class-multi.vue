<template>
	<sapi-dialog v-model="visible" width="500px" top="25%" class="add" @on-open="open" @on-close="close">
		<span slot="title" v-text="$t('supplierClass.choiceClassTitle')"></span>
		<div class="form-error-tips"></div>
		<div class="form-content">
			<el-table border ref="multipleTable" :data="classData" @selection-change="selectionChange">
				<el-table-column type="selection">
				</el-table-column>
				<el-table-column :label="$t('supplierClass.className')" show-overflow-tooltip prop="ClassName">
				</el-table-column>
                <el-table-column :label="$t('supplierClass.baseClassName')" show-overflow-tooltip prop="BaseClassName">
				</el-table-column>
			</el-table>
		</div>

		<div class="footer">
            <el-button size="small" class="cancel" @click="close" v-text="$t('cancel')"></el-button>
			<el-button class="blue-button" size="small" :disabled="disabled" @click="confirm" v-text="$t('confirm')"></el-button>
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
				classData: [],
				selectClasses: []
			}
		},
		props: ["value","option"],
		methods: {
			open() {
                //防止每次打开重新赋值后值重复，在这里进行清空
				this.classData = [];
				this.$get('/api/plat/supplierClasses/brief', {}, function(res) {
					if(res && res.length > 0) {
						for(var i = 0; i < res.length; i++) {
							let obj={
								"ClassId": res[i].ClassId,
                                "ClassName": res[i].ClassName,
                                "BaseClassName": res[i].BaseClassName
							}
							this.classData.push(obj);
                        }
                        
                        if(this.option){
                            let table=this.$refs.multipleTable;
                            this.option.forEach(row => {
                                let currentRow=this.classData.find(current=>{
                                    return current.ClassId===row.ClassId;
                                });

                                if(currentRow){
                                    table.toggleRowSelection(currentRow,true);
                                }
                            });
                        }
					}
                });
                this.selectClasses = [];
			},
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input", false);
			},
			confirm() {
                let classDatas=[];
                if(this.option.length > 0) {
                    classDatas = [].concat(this.option);
                    let isAdd = true;
                    for(var i=0;i<this.selectClasses.length;i++)
                    {
                        for(var j=0;j<this.option.length;j++)
                        {
                            if(this.option[j].ClassId == this.selectClasses[i].ClassId) {
                                isAdd = false;
                            }
                        }
                        if(isAdd) {
                            classDatas.push(this.selectClasses[i]);
                        }
                        isAdd = true;
                    }
                }
                else {
                    classDatas = this.selectClasses;
                }
                if(classDatas.length > 3) {
                    Vue.msg(this.$t("supplierManage.classCannotExceed"));
					return;
                }
                this.$emit("call-back",[classDatas,"class"]);
				this.close();
			},
			selectionChange(datas) {
                this.selectClasses = datas;
			}
		},
		components: {
			"sapi-dialog": dialog
		},
		watch: {
			value(val) {
				this.visible = this.value;
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
