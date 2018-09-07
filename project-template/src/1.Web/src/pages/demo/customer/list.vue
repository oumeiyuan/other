<template>
	<div class="main">
		<div class="main-header">
			<div class="main-header-map"><span class="main-header-map-text"></span></div>
            <div class="main-header-search">
            	<div class="func-btns">
            		<sapi-search v-model="params.keyword" placeholder="按名称、编号进行搜索" @on-search="loadData"></sapi-search>
                    <span v-if="permissions.Add" class="icon-btn" @click="openAddDialog" title="新增"><i class="icon-build"></i></span>
                    <span v-if="permissions.Delete" class="icon-btn" @click="deleteItems" title="删除"><i class="icon-deleter"></i></span>
            	</div>
            </div>
		</div>
		
		<div class="main-table table-no-border width-p100">
			<el-table border :data="tableData" ref="bodyTable" @sort-change="sortChange" @selection-change="rowSelect" :height="maxBodyHeight">
			 	<el-table-column v-if="permissions.Delete" type="selection" width="45">
                </el-table-column>
			 	<el-table-column prop="CustomerName" label="客户名称" width="300" show-overflow-tooltip sortable>                	
                	<template slot-scope="props">
						<a href="javascript:void(0)" @click="openViewDialog(props.row)">{{props.row.CustomerName}}</a>
					</template>
			 	</el-table-column>
			 	<el-table-column prop="CustomerNo" label="客户编号" width="100" show-overflow-tooltip sortable>
                </el-table-column>
                <el-table-column label="客户级别" width="100" >
                	<template slot-scope="props">
                	 	{{getCustomerLevel(props.row.CustomerLevel)}}
                	</template>
                </el-table-column>
                <el-table-column prop="CustomerAddress" label="客户地址 " min-width="200" show-overflow-tooltip>
                </el-table-column>
                <el-table-column label="创建日期" width="120" show-overflow-tooltip>
                	<template slot-scope="props">
                	 	{{$dateFormat("yyyy-MM-dd",props.row.CreateDate)}}
                	</template>                	
                </el-table-column>
                <el-table-column prop="RowIndex" label="行号" width="100" sortable>
                </el-table-column>
                <el-table-column label="操作" fixed="right" width="100" v-if="permissions.Edit || permissions.Delete"> 
                    <template slot-scope="props">
                        <a v-if="permissions.Edit" class="table-btn" href="javascript:void(0)" @click="openEditDialog(props.row,props.$index)">修改</a>
                        <a v-if="permissions.Delete" class="table-btn" href="javascript:void(0)" @click="deleteItem(props.row,props.$index)">删除</a>
                    </template>
                </el-table-column>
			</el-table>
		</div>
		
		<div class="main-pager">
            <el-pagination @size-change="pageSizeChange" @current-change="pageCurrentChange" :current-page="params.pageIndex" :page-sizes="pageArr" :page-size="params.pageSize" :layout="layout" :total="pageTotal">
			</el-pagination>
        </div>
        
        <!-- 新增、修改组件 -->
        <component v-bind:is="currentView" v-model="visible" :option="option"></component>
        
        
	</div>
</template>

<script>
	import confirm from "@/components/sapi-confirm.js";
    import search from "@/components/sapi-search.vue";
    
    export default{
    	data(){
    		return {
    			tableData: [],          //列表数据
    			deleteIds: [],
    			params: {               //列表参数
                    sortName: "",
                    sortType: ""
                },
                currentView:null,
                visible:false,
                option:{}
    		}
    	},
    	mixins: [getPagerMixin()],
    	methods:{
    		loadData() {
    			var params = this.params;
                this.$loadingOpen();        //延迟加载打开
                this.$get("/api/ims/customers", params, function (res) {
                    this.tableData = res.Rows;
                    this.pageTotal = res.Total;
                });
    		},
    		openAddDialog() {
                this.currentView = "customer-add";
                this.visible = true;
            },
            openEditDialog(row, index){
                this.currentView = "customer-edit";
                this.visible = true;
                this.option.CustomerId = row.CustomerId;
            },
            deleteCustomers(apiAddress, itemIds, successFunc){
                if (itemIds == null || itemIds.length == 0){
                    Vue.msg("请最少选择一项，才能进行删除");
                    return false;
                }

                this.$deleteTips(function(){
                    this.$delete(apiAddress, JSON.stringify(itemIds),function(res){
                        successFunc(res);
                        Vue.successMsg("删除客户成功");
                    });
                });
            },
            deleteItem(row, index){
                var _this = this;
                var deleteIds = [];
                deleteIds.push(row.CustomerId);
                this.deleteCustomers(
                    "/api/ims/customers/",
                    deleteIds,
                    function(res){
                        _this.loadData();
                    });
            },
            deleteItems(){
                var _this = this;
                this.deleteCustomers(
                    "/api/ims/customers/",
                    _this.deleteIds,
                    function(res){
                        _this.loadData();
                    });                
            },
    		sortChange(obj){
                this.params.sortName = obj.prop;
                this.params.sortType = obj.order;
                this.pageCurrentChange(1);
            },
            rowSelect(datas){
                var _this = this;
				_this.deleteIds = [];
				if(datas.length > 0) {
					datas.forEach(function(data) {
						_this.deleteIds.push(data.CustomerId);
					});
				}
            }, 
            openViewDialog(row, index) {
				this.currentView = "customer-view";
				this.option = row;
				this.visible = true;
			},
            getCustomerLevel(val){
            	var customerLevelName = "";
            	switch(val){
            		case 1:
            			customerLevelName = "一级";
            			break;
            		case 2: 
            			customerLevelName = "二级";
            			break;
            		case 3: 
            			customerLevelName = "三级";
            			break;
            	}
            	return customerLevelName;
            }
    	},
    	components:{
    		"sapi-search": search,
    		"customer-add": (resolve) => {
    			require(['./add.vue'],resolve);
    		},
    		"customer-edit": (resolve) => {
    			require(['./edit.vue'],resolve);
    		},
    		"customer-view": (resolve) => {
    			require(['./view.vue'],resolve);
    		},
    	},
    	 created() {
            Vue.use(confirm);
            //pager改变时将要执行的函数，对该值进行初始化
            this.pageFunc = this.loadData;
            this.loadData();
            //初始化权限等信息
            this.$init();
        },
        mounted() {

        }
    }
</script>

<style>
</style>