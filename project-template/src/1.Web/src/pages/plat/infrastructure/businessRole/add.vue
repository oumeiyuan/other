<template>
	<sapi-dialog v-model="visible" width="500px" top="25%" class="add" @on-open="open" @on-close="close">
		<span slot="title" v-text="$t('businessRole.addRoleTitle')"></span>
		<div class="form-error-tips"></div>
		<div class="form-content">
			<div class="fullline">
				<span class="w-65 must-star" v-text="$t('businessRole.roleName')"></span>
				<div class="right-auto-box">
					<el-input id="RoleName" v-model.trim="createModel.RoleName" :maxlength="100"></el-input>
				</div>
			</div>
            <div class="fullline">
				<span class="w-65 must-star" v-text="$t('businessRole.categoryName')"></span>
                <div class="right-auto-box">
                    <sapi-select id="Category" clearable v-model="createModel.CategoryId" :data="categories" :props="{label:'CategoryName',value:'CategoryId'}"></sapi-select>
                </div>
			</div>
            <div class="fullline">
				<span class="w-65 lh-30" v-text="$t('businessRole.description')"></span>
				<div class="right-auto-box">
					<el-input :maxlength="200" type="textarea" :autosize="{ minRows: 2, maxRows: 4}" v-model="createModel.Description"></el-input>
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
                categories: [],
				createModel: {
                    RoleName: null,
                    Type: null,
                    CategoryId: null,
                    Description: null
                }
			}
		},
		props: ["value","option"],
		methods: {
            open() {
                this.createModel = {
                    RoleName: null,
                    Type: this.option,
                    CategoryId: null,
                    Description: null
                };
                this.getCategories();
			},
			close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input", false);
            },
            getCategories() {
                this.$get("/api/plat/businessRoles/categories/brief", {type: this.option}, function(res) {
                    this.categories = res;
				});
            },
			submit() {
				if(!this.validate()) {
					return;
				}

				this.disabled = true;
				this.$post("/api/plat/businessRoles/roles", this.createModel, function(res) {
					this.disabled = false;
					this.$parent.getTableData();
					this.close();
					Vue.successMsg(this.$t('businessRole.addRoleSuccess'));
				});
			},
			validate() {
				if(!this.createModel.RoleName) {
					this.$errorTips(this.$t('businessRole.roleNameNotBeEmpty'), "#RoleName");
					return false;
                }
                if(!this.createModel.CategoryId) {
					this.$errorTips(this.$t('businessRole.selectCategoryPlease'), "#Category");
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

<style>

</style>