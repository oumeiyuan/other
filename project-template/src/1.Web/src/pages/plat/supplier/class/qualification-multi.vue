<template>
	<sapi-dialog v-model="visible" width="500px" top="25%" class="add" @on-open="open" @on-close="close">
		<span slot="title" v-text="$t('supplierClass.choiceQualificationTitle')"></span>
		<div class="form-error-tips"></div>
		<div class="form-content">
			<el-table ref="multipleTable" :data="QualificationData" @selection-change="selectionChange">
				<el-table-column type="selection">
				</el-table-column>
				<el-table-column :label="$t('supplierClass.qualificationName')" show-overflow-tooltip prop="QualificationName">
				</el-table-column>
                <el-table-column :label="$t('supplierClass.className')" show-overflow-tooltip prop="ClassName">
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
				QualificationData: [],
				selectedQualifications: []
			}
		},
		props: ["value","option"],
		methods: {
			open() {
                //防止每次打开重新赋值后值重复，在这里进行清空
                this.QualificationData = [];
				this.$get("/api/plat/supplierClasses/brief/"+this.option, {}, function(res) {
					if(res && res.length > 0) {
						for(var i = 0; i < res.length; i++) {
							let obj={
								"Index":res[i].QualificationId,
								"QualificationId": res[i].QualificationId,
                                "QualificationName": res[i].QualificationName,
                                "ClassId": res[i].ClassId,
                                "ClassName": res[i].ClassName
							}
							obj[res[i].QualificationId]=[];
							this.QualificationData.push(obj);
						}
					}
				})
			},
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input", false);
			},
			confirm() {
                this.$emit("call-back",[this.selectedQualifications,"qualification"]);
				this.close();
			},
			selectionChange(datas) {
                this.selectedQualifications = datas;
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
