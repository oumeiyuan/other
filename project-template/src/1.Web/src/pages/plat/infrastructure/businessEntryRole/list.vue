<template>
	<div class="role main">
		<div class="main-header">
			<div class="main-header-map"><span class="main-header-map-text"></span></div>
			<div class="main-header-search">
				<div class="func-btns">
					<sapi-search v-model="params.keyword" :placeholder="$t('businessEntryRole.search')" @on-search="getTableData"></sapi-search>
                    <span v-if="permissions.Add" class="icon-btn" @click="openAddDialog" :title="$t('add')"><i class="icon-build"></i></span>
				</div>			
			</div>
		</div>

        <div class="main-search-filter">
			<ul class="main-search-filter-items">
				<li>
					<span class="w-65">{{entryTitle}}</span>
					<span class="right-auto-box">
                        <sapi-select :lazy-load="loadChild" prop="entryId" v-model="params.entryId" :expand-on-click-node="false" 
                                :is-tree="true" :data="companys" :props="struProps" :except-id="option.StruId"
                                    options="data:seletedCompany,label:StruName,value:StruId" @change="changeCompany"></sapi-select>
                    </span>
				</li>
				<li><span class="w-65">{{$t('businessEntryRole.categoryName')}}</span>
					<span class="right-auto-box">
						<sapi-select v-model="params.categoryId" prop="categoryId" :data="categories" options="data:seletedCategory,label:CategoryName,value:CategoryId" :props="{label:'CategoryName',value:'CategoryId'}" @change="changeCategory"></sapi-select>
					</span>
				</li>
			</ul>
		</div>

		<div class="main-table table-no-border width-p100">
			<el-table :data="tableData" ref="bodyTable" @sort-change="sortChange" :height="maxBodyHeight">
				<el-table-column prop="RoleName" :label="$t('businessEntryRole.roleName')" width="220" show-overflow-tooltip sortable>
				</el-table-column>
				<el-table-column prop="Description" :label="$t('businessEntryRole.description')" show-overflow-tooltip>
				</el-table-column>
				<el-table-column :label="$t('handle')" fixed="right" width="160" v-if="permissions.Edit || permissions.Delete">
					<template slot-scope="props">       
                        <a v-if="permissions.Setting" class="table-btn" href="javascript:void(0)" @click.stop="openSetDialog(props.row,props.$index)" v-text="operateText.set"></a>
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
    import select from "@/components/sapi-select.vue";  
	import confirm from "@/components/sapi-confirm.js";
	import search from "@/components/sapi-search.vue";
	import "../../static/css/permission.css";
	export default {
		data() {
			return {
                entryTitle: null,
				tableData: [],
				option: {},
				visible: false,
                currentView: "",
                companys: [],
                seletedCompany:[],
                struProps:{
					children: 'Children',
					label: 'StruName',
                    value:'StruId',
                    hasChild:"HasChild"
                },
                type: null,
                categories: [],
                seletedCategory: [],
                params: {
                    entryId: null,
                    type: null,
                    categoryId: null
				},
				operateText: {
					set: this.$t('businessEntryRole.member')
				}
			}
		},
		mixins: [getPagerMixin(),getTabMixin()],
		methods: {
			getTableData() {
                var params = this.params;
				this.$loadingOpen();
				this.$get("/api/plat/businessEntryRoles", params, function(res) {
					this.tableData = res.Rows;
                    this.pageTotal = res.Total;
                    
                    //重新设置permissions的值
					var str = sessionStorage["permissions"];
					this.permissions = JSON.parse(str || "{}");
				});
            },
            openAddDialog() {
                this.currentView = "role-add";
                this.option = this.params;
				this.visible = true;
			},
            openSetDialog(row, index) {
				this.currentView = "role-set";
				this.option = row;
				this.visible = true;
			},
			sortChange(obj) {
				this.params.sortName = obj.prop;
                this.params.sortType = obj.order;
				this.pageCurrentChange(1);
            },
            getCompanys() {
                this.$get("/api/plat/structures/brief", {}, function(res) {
                    this.companys = res;
                    if(res.length > 0)
                    {
                        this.params.entryId = res[0].CorpId;
                        this.seletedCompany=[res[0]];
                    }
                    this.getCategories();
                });
            },
            changeCompany(company){
                this.seletedCompany=[company];
                this.tableData=[];
                this.params.entryId = company.CorpId;

				if(this.params.entryId && this.params.categoryId) {
                    this.getTableData();
                }
            },
            getCategories() {
                this.$get("/api/plat/businessRoles/categories/brief", {type: this.type}, function(res) {
                    this.categories = res;
                    if(res.length > 0)
                    {
                        this.params.categoryId = res[0].CategoryId;
                        this.seletedCategory=[res[0]];
                        this.getTableData();
                    }
				});
            },
            loadChild(item,callback){
				let url= "/api/plat/structures/brief",
				params={
					"withDept": false,
					parentStruId: item["StruId"]
				};
				this.$get(url,params,function(res){
					callback(res);
				})
			},
            changeCategory(category){
                this.seletedCategory=[category];
                this.tableData=[];
                this.params.categoryId = category.CategoryId;

				if(this.params.entryId && this.params.categoryId) {
                    this.getTableData();
                }
            }
		},
		components: {
            "role-add": (resolve)=> {
				require(['./add.vue'], resolve);
			},
			"role-set": (resolve)=> {
				require(['./set.vue'], resolve);
			},
            "sapi-search": search,
            "sapi-select": select
		},
		created() {
			Vue.use(confirm);
			//pager改变时将要执行的函数，对该值进行初始化
            this.pageFunc = this.getTableData;
            this.params.type = this.type = this.$getHashParams("type");
            switch(this.type) {
                case "1" : this.entryTitle = this.$t('businessEntryRole.corpTitle'); break;
                case "2" : this.entryTitle = this.$t('businessEntryRole.projectTitle'); break;
            }
            this.getCompanys();
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
                this.getCompanys();
			}
		}
	}
</script>

<style>
.role .main-filter{
    padding-top:15px;
    padding-left:15px;
    padding-right:15px;
}
.right-entry-box {
	display: inline-block;
	width: calc(100% - 85px);
}
</style>