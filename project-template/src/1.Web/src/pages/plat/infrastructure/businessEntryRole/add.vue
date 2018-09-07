<template>
	<sapi-dialog v-model="visible" width="700px" top="15%" @on-open="open" @on-close="close">
		<span slot="title" v-text="title"></span>
        <div class="form-error-tips"></div>
        <div class="form-content">
            <div class="fullline">
                <div class="wp-50">
                    <div class="right-power-box relative" @keyup.enter="getTableData">
                        <el-input  v-model="params.keyword" :maxlength="100" :placeholder="$t('businessEntryRole.search')">
                            <a slot="suffix" class="el-icon-search" @click="getTableData"></a>
                        </el-input>
                    </div>
                </div>
            </div>
            <div class="fullline width-p100">
                <el-table class="common-table" :data="tableData" ref="tableBody" @selection-change="selectionChange" style="width:100%;">
                    <el-table-column type="selection" width="45">
                    </el-table-column>
                    <el-table-column :key="item.id" v-for="item in headerData" :prop="item.prop" :label="item.label" show-overflow-tooltip width="width">
                    </el-table-column>
                </el-table>
            </div>
            <div class="fullline">
                <el-pagination v-show="(pageTotal/params.pageSize)>1" @size-change="pageSizeChange" @current-change="pageCurrentChange" :current-page="params.pageIndex" :page-sizes="pageArr" :page-size="params.pageSize" :layout="layout" :total="pageTotal">
                </el-pagination>
            </div>
        </div>

        <div class="footer">
            <el-button size="small" class="default-button" @click="close" v-text="$t('cancel')"></el-button>
            <el-button size="small" class="blue-button" :disabled="disabled" @click="submit" v-text="$t('confirm')"></el-button>
        </div>
	</sapi-dialog>
</template>

<script>
	import tips from "@/components/sapi-tips.js";
	import dialog from "@/components/sapi-dialog.vue";

	export default {
		data() {
			return {
				title: "",
				disabled: false,
				visible: false,
				createModel: {
                    RoleIds: []
                },
				tabIndex: 0,
				headerData: [{
					prop: "RoleName",
					label: this.$t('businessEntryRole.roleName'),
					sortable: true
				}, {
					prop: "Description",
					label: this.$t('businessEntryRole.description'),
					sortable: false
				}],
				tableData: [],
				params: {
                    type: null,
                    entryId: null,
                    categoryId: null,
                    pageIndex: 1,
                    pageSize: 10,
                    sortName: null,
                    sortType: null,
					keyword: null
				},
				roleIds: [],
				maxHeight: 300,
				isIE11:false
			}
		},
		mixins: [getPagerMixin()],
		props: ["value", "option"],
		methods: {
			getTableData() {
                this.params.type = this.option.type;
                this.params.entryId = this.option.entryId;
				this.params.categoryId = this.option.categoryId;
				if (!this.params.entryId || !this.params.categoryId){
					this.tableData = [];
					this.pageTotal = 0;
					return;
				}
				this.$get("/api/plat/businessEntryRoles/optionalRoles", this.params, function(res) {
					this.tableData = res.Rows;
					this.pageTotal = res.Total;
				});
            },
			open() {
				this.params.keyword = '';
				this.params.pageIndex = 1;
				this.params.pageSize = 10;
				if(this.option && typeof this.option === "object") {
					this.createModel = JSON.parse(JSON.stringify(this.option));
				} else {
					this.createModel = this.option;
				}
				this.title = this.$t('businessEntryRole.chooseRoleTitle',{roleName:this.createModel.RoleName});
				this.tabIndex = 0;
                this.getTableData();
			},
            close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input", false);
			},
			selectionChange(datas) {
				var _this = this;
				_this.createModel.RoleIds = [];
				if(datas.length > 0) {
					datas.forEach(function(data) {
						_this.createModel.RoleIds.push(data.RoleId);
					});
				}
			},
			submit() {
				if(!this.validate()) {
					return;
				}

				this.disabled = true;
				this.$post("/api/plat/businessEntryRoles/", this.createModel, function(res) {
					this.disabled = false;
					this.$parent.getTableData();
					this.close();
					Vue.successMsg(this.$t('businessEntryRole.chooseRoleSuccess'));
				});
			},
			validate() {
				if(!this.createModel.RoleIds || this.createModel.RoleIds.length == 0) {
                    Vue.msg(this.$t('businessEntryRole.selectOneWhenAdd'));
					return false;
				}				
				return true;
			}
		},
		components: {
			"sapi-dialog": dialog
		},
		created() {
			Vue.use(tips);
			//pager改变时将要执行的函数，对该值进行初始化
			this.pageFunc = this.getTableData;
			
			var userAgent = navigator.userAgent;
			this.isIE11 = userAgent.indexOf('Trident') > -1 && userAgent.indexOf("rv:11.0") > -1;
		},
		watch: {
			value(val) {
				this.visible = val;
			}
		},
		mounted() {
			this.visible = this.value;
		}
	}
</script>