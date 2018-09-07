<template>
	<sapi-dialog v-model="visible" width="990px" top="12%" @on-open="open" @on-close="close">
		<span slot="title" v-text="title"></span>
        <div class="form-error-tips"></div>
        <div class="form-content">
            <div class="fullline">
                <div class="wp-50">
                    <div class="right-power-box relative" @keyup.enter="getTableData">
                        <el-input  v-model="params.keyword" :maxlength="200" :placeholder="$t('businessEntryRole.searchUser')">
                            <a slot="suffix" class="el-icon-search" @click="getTableData"></a>
                        </el-input>
                    </div>
                </div>
                <div class="wp-50 float-right btn-outer">
                    <ul class="btn-wrap">
                        <li class="icon-build" @click="userSetAdd"></li>
                        <li class="icon-deleter" @click="deleteItems"></li>
                    </ul>
                </div>
            </div>
            <div class="fullline width-p100">
                <el-table class="common-table" :data="tableData" ref="tableBody" @selection-change="selectionChange" style="width:100%;">
                    <el-table-column type="selection" width="45">
                    </el-table-column>
                    <el-table-column :key="item.id" v-for="item in headerData" :prop="item.prop" :label="item.label" show-overflow-tooltip width="width">
                    </el-table-column>
                    <el-table-column :label="$t('handle')" width="70">
                        <template slot-scope="props">
                            <a class="table-btn" href="javascript:void(0)" @click.stop="deleteItem(props.row,props.$index)" v-text="operateText.delete"></a>
                        </template>
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
        </div>
		<component slot="moreDialog" v-model="userSetVisible" :call-back="getUserData" v-bind:is="userSetView" :role-id="option.RoleId" :entry-id="option.EntryId"></component>
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
				editModel: {},
				tabIndex: 0,
				currentView: "",
				headerData: [{
					prop: "UserName",
					label: this.$t('businessEntryRole.userName'),
					sortable: false
				}, {
					prop: "AliasName",
					label: this.$t('businessEntryRole.aliasName'),
					sortable: false
				}],
				userSetVisible: false,
				userSetView: "",
				tableData: [],
				params: {
                    entryId: null,
					roleId: null,
					isRelated: true,
					pageSize:10
				},
				deleteIds: [],
				isLoading: false,
				maxHeight: 300,
				isIE11:false,
				operateText: {
					delete: this.$t('delete')
				}
			}
		},
		mixins: [getPagerMixin()],
		props: ["value", "option"],
		methods: {
			getTableData() {
                this.params.entryId = this.option.EntryId;
				this.params.roleId = this.option.RoleId;
				this.$get("/api/plat/businessEntryRoles/optionalUsers", this.params, function(res) {
					this.tableData = res.Rows;
					this.pageTotal = res.Total;
				});
            },
			open() {
				this.isLoading = true;
				this.params.keyword = '';
				this.params.pageIndex = 1;
				this.params.pageSize = 10;
				if(this.option && typeof this.option === "object") {
					this.editModel = JSON.parse(JSON.stringify(this.option));
				} else {
					this.editModel = this.option;
				}
				this.title = this.$t('businessEntryRole.setRoleTitle',{roleName:this.editModel.RoleName});
				this.tabIndex = 0;
                this.currentView = "role-set";
                this.getTableData();
			},
            close() {
				this.$closeWaringTips(".form-error-tips");
				this.$emit("input", false);

			},
			userSetAdd() {
				this.userSetView = "user-set";
				this.userSetVisible = true;
			},
			deleteItem(data, index) {
				this.$deleteTips(function() {
					this.$delete("/api/plat/businessEntryRoles/users", {
                        "EntryId": this.option.EntryId,
						"RoleId": this.option.RoleId,
						"UserIds": [
							data.UserId
						]
					}, function(res) {
						this.getTableData();
						Vue.successMsg(this.$t('delSuccess'));
					}, function(err) {
						Vue.msg(err.Message);
					});

				});
			},
			deleteItems() {
				if(this.deleteIds.length == 0) {
					Vue.msg(this.$t('selectOneWhenDeleted'));
					return false;
				}

				this.$deleteTips(function() {
					this.$delete("/api/plat/businessEntryRoles/users", {
                        "EntryId": this.option.EntryId,
						"RoleId": this.option.RoleId,
						"UserIds": this.deleteIds
					}, function(res) {
						this.getTableData();
						Vue.successMsg(this.$t('delSuccess'));
					}, function(err) {
						Vue.msg(err.Message);
					});
				});
			},
			selectionChange(datas) {
				var _this = this;
				_this.deleteIds = [];
				if(datas.length > 0) {
					datas.forEach(function(data) {
						_this.deleteIds.push(data.UserId);
					});
				}
			},
			getUserData(datas) {
				this.getTableData();
			},
			callback(boo) {
				this.$emit("input", false)
			}
		},
		components: {
			"sapi-dialog": dialog,
			"user-set": (resolve) => {
				require(['./userSet.vue'], resolve);
			}
		},
		created() {
			Vue.use(tips);
			//pager改变时将要执行的函数，对该值进行初始化
			this.pageFunc = this.getTableData;
			//this.getTableData();
			
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