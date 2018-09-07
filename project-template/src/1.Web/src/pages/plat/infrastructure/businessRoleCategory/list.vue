<template>
	<div class="main">
		<div class="main-header">
			<div class="main-header-map"><span class="main-header-map-text"></span></div>
			<div class="main-header-search">
				<div class="func-btns">
					<sapi-search v-model="params.keyword" :placeholder="$t('businessRoleCategory.search')" @on-search="getTableData"></sapi-search>
					<span v-if="permissions.Add" class="icon-btn" @click="openAddDialog" :title="$t('add')"><i class="icon-build"></i></span>
					<span v-if="permissions.Delete" class="icon-btn" @click="deleteItems" :title="$t('delete')"><i class="icon-deleter"></i></span>
				</div>			
			</div>
		</div>

		<div class="main-table table-no-border width-p100">
			<el-table :data="tableData" ref="bodyTable" @sort-change="sortChange" @selection-change="selectionChange" :height="maxBodyHeight">
				<el-table-column v-if="permissions.Delete" type="selection" width="45">
				</el-table-column>
				<el-table-column prop="CategoryName" :label="$t('businessRoleCategory.categoryName')" width="220" show-overflow-tooltip sortable>
				</el-table-column>
				<el-table-column prop="Description" :label="$t('businessRoleCategory.description')" show-overflow-tooltip>
				</el-table-column>
				<el-table-column prop="RowIndex" :label="$t('rowIndex')" width="100" sortable>
				</el-table-column>
				<el-table-column :label="$t('handle')" fixed="right" width="160" v-if="permissions.Edit || permissions.Delete">
					<template slot-scope="props">                     
                        <a v-if="permissions.Edit" class="table-btn" href="javascript:void(0)" @click.stop="openEditDialog(props.row,props.$index)" v-text="operateText.edit"></a>
                        <a v-if="permissions.Delete" class="table-btn" href="javascript:void(0)" @click.stop="deleteItem(props.row,props.$index)" v-text="operateText.delete"></a>
                    </template>
				</el-table-column>
			</el-table>
		</div>

		<div class="main-pager">
			<el-pagination @size-change="pageSizeChange" @current-change="pageCurrentChange" :current-page="params.pageIndex" :page-sizes="pageArr" :page-size="params.pageSize" :layout="layout" :total="pageTotal">
			</el-pagination>
		</div>

		<component v-bind:is="currentView" v-model="visible" :option="option"></component>
	</div>
</template>

<script>
	import confirm from "@/components/sapi-confirm.js";
	import search from "@/components/sapi-search.vue";
	import filter from "@/components/sapi-filter.vue";
	export default {
		data() {
			return {
				tableData: [],
				deleteIds: [],
				option: {},
				visible: false,
                currentView: "",
                type: null,
                params: {
					type: null
				},
				operateText: {
					edit: this.$t('edit'),
					delete: this.$t('delete')
				}
			}
		},
		mixins: [getPagerMixin(),getTabMixin()],
		methods: {
			getTableData() {
                var params = this.params;
				this.$loadingOpen();
				this.$get("/api/plat/businessRoles/categories", params, function(res) {
					this.tableData = res.Rows;
					this.pageTotal = res.Total;
				});
			},
			openAddDialog() {
                this.currentView = "category-add";
                this.option = this.type;
				this.visible = true;
			},
			openEditDialog(row, index) {
				this.currentView = "category-edit";
				this.option = row;
				this.visible = true;
			},
			deleteItem(row, index) {
				this.$deleteTips(function() {
					this.$delete("/api/plat/businessRoles/categories/" + row.CategoryId, function(res) {
						this.getTableData();
						Vue.successMsg(this.$t('businessRoleCategory.delCategorySuccess'));
					});
				});
			},
			deleteItems() {
				if(this.deleteIds.length == 0) {
					Vue.msg(this.$t('selectOneWhenDeleted'));
					return false;
				}

				this.$deleteTips(function() {
					this.$delete("/api/plat/businessRoles/categories/", JSON.stringify(this.deleteIds), function(res) {
						this.getTableData();
						Vue.successMsg(this.$t('businessRoleCategory.delCategorySuccess'));
					});
				});
			},
			sortChange(obj) {
				this.params.sortName = obj.prop;
                this.params.sortType = obj.order;
				this.pageCurrentChange(1);
			},
			selectionChange(datas) {
				var _this = this;
				_this.deleteIds = [];
				if(datas.length > 0) {
					datas.forEach(function(data) {
						_this.deleteIds.push(data.CategoryId);
					});
				}
            }
		},
		components: {
			"category-add": (resolve)=> {
				require(['./add.vue'], resolve);
			},
			"category-edit": (resolve)=> {
				require(['./edit.vue'], resolve);
			},
			"sapi-search": search,
			"filter-category": filter
		},
		created() {
			Vue.use(confirm);
			//pager改变时将要执行的函数，对该值进行初始化
            this.pageFunc = this.getTableData;
            this.params.type = this.type = this.$getHashParams("type");
			this.getTableData();
			//初始化权限等
			this.$init();
		},
		mounted() {

        },
        watch: {
			//监听路由中menuId
			"$route.query.menuId": function(val) {
				this.type = this.$route.query.type;
				this.params.type = this.type;
				this.getTableData();
			}
		}
	}
</script>
