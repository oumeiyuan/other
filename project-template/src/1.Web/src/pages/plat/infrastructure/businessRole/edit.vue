<template>
	<sapi-dialog v-model="visible" width="500px" top="25%" class="add" @on-open="open" @on-close="close">
		<span slot="title" v-text="$t('businessRole.editRoleTitle')"></span>
		<div class="form-error-tips"></div>
		<div class="form-content">
			<div class="fullline">
				<span class="w-65 must-star" v-text="$t('businessRole.roleName')"></span>
				<div class="right-auto-box">
					<el-input id="RoleName" v-model.trim="editModel.RoleName" :maxlength="100"></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-65" v-text="$t('businessRole.categoryName')"></span>
				<div class="right-auto-box">
					<el-input id="RoleName" v-model.trim="editModel.CategoryName" :maxlength="100" readonly></el-input>
				</div>
			</div>
			<div class="fullline">
				<span class="w-65" v-text="$t('rowIndex')"></span>
				<div class="right-auto-box">
					<el-input v-model="editModel.RowIndex" :min="0" :max="999999999" v-format.d="{default:0}"></el-input>
				</div>
			</div>
            <div class="fullline">
				<span class="w-65 lh-30" v-text="$t('businessRole.description')"></span>
				<div class="right-auto-box">
					<el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4}" v-model="editModel.Description" :maxlength="200"></el-input>
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
	export default {
		data() {
			return {
				disabled: false,
                visible: false,
				editModel: {
                    RoleId: null,
                    RoleName: null,
                    CategoryName: null,
                    Description: null,
                    RowIndex: null
                }
			}
		},
		props: ["value","option"],
		methods: {
            open() {
				this.$get("/api/plat/businessRoles/roles/"+this.option.RoleId, {}, function(res) {
                    this.editModel.RoleId = res.RoleId;
                    this.editModel.RoleName = res.RoleName;
                    this.editModel.CategoryName = res.CategoryName;
                    this.editModel.Description = res.Description;
                    this.editModel.RowIndex = res.RowIndex;
                });
                
			},
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input", false);
            },
			submit() {
				if(!this.validate()) {
					return;
				}

				this.disabled = true;
				this.$put("/api/plat/businessRoles/roles/", this.editModel, function(res) {
					this.disabled = false;
					this.$parent.getTableData();
					this.close();
					Vue.successMsg(this.$t('businessRole.editRoleSuccess'));
				});
			},
			validate() {
				this.$closeWaringTips(".form-error-tips");
				if(!this.editModel.RoleName) {
					this.$errorTips(this.$t('businessRole.roleNameNotBeEmpty'), "#RoleName");
					return false;
                }	
				return true;
			}
		},
		components: {
            "sapi-dialog": dialog,
            "sapi-select": select
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
