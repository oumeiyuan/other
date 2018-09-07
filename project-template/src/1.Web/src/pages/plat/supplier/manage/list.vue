<template>
	<div class="main">
       <div class="main-header">
          <div class="main-header-map"><span class="main-header-map-text"></span></div>
          <div class="main-header-search">
                <div class="func-btns">
                    <sapi-search v-model="params.keyword" :placeholder="$t('supplierManage.search')" @on-search="loadData"></sapi-search>
                    <span v-if="permissions.Add" class="icon-btn" @click="openAddDialog" :title="$t('add')"><i class="icon-build"></i></span>
                    <span v-if="permissions.Delete" class="icon-btn" @click="deleteItems" :title="$t('delete')"><i class="icon-deleter"></i></span> 
                     <span class="icon-btn icon-filter" :title="$t('filter')"></span>
                </div>
            </div>
        </div>
		<div class="main-table table-no-border width-p100">
			<el-table border :data="tableData" ref="bodyTable" @selection-change="rowSelect" :height="maxBodyHeight">				
				<el-table-column v-if="permissions.Delete" type="selection" width="45"></el-table-column>
                <el-table-column prop="SupName" :label="$t('supplierManage.supName')" width="200" show-overflow-tooltip>
                    <template slot-scope="props">
						<a href="javascript:void(0)" @click="openViewDialog(props.row)">{{props.row.SupName}}</a>
					</template>
				</el-table-column>
				<el-table-column prop="SupNo" :label="$t('supplierManage.supNo')" width="100" show-overflow-tooltip>
				</el-table-column>
                <el-table-column prop="supplierClasses" :label="$t('supplierManage.className')" width="300" show-overflow-tooltip>
                    <template slot-scope="props">
                        {{showText(props.row.supplierClasses)}}
                    </template>
				</el-table-column>
                <el-table-column :label="$t('supplierManage.area')" width="180"  show-overflow-tooltip>
                    <template slot-scope="props">
                        {{ getProvinceCityAreaName(props.row) }}
                    </template>
				</el-table-column>		
				<el-table-column prop="TaxPayerId" :label="$t('supplierManage.taxPayerId')" width="100" show-overflow-tooltip>
                    <template slot-scope="props">
						{{taxPayerValue[props.row.TaxPayerId]}}
					</template>
				</el-table-column>
                <el-table-column prop="EnterpriseForm" :label="$t('supplierManage.enterpriseForm')" width="100" show-overflow-tooltip>
                      <template slot-scope="props">
                           {{enterpriseFormValue[props.row.EnterpriseForm]}}    
                      </template>   
                </el-table-column>
                <el-table-column prop="RowIndex" :label="$t('rowIndex')" show-overflow-tooltip>
				</el-table-column>	
				<el-table-column :label="$t('handle')" fixed="right" width="100">
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

        <!-- 新增、修改组件 -->
        <component v-bind:is="currentView" v-model="visible" :option="option"></component>
        <supplierManager-filter @on-confirm="loadData" :is-init="filterControlIsInit">
            <filter-item :param.sync="params.classId" :data="supplierClasses" :props="{label:'ClassName',value:'ClassId'}" type="list">
                <span class="w-65">{{$t('supplierManage.className')}}</span>
                <span class="right-auto-box">
                    <sapi-select v-model="params.classId" :data="supplierClasses" :props="{label:'ClassName',value:'ClassId'}"></sapi-select>
                </span>
            </filter-item>
            <filter-item :param.sync="params.areaModel" :default-value="{}" :data="params.areaModel" :format="areaFormat">
                <span class="w-65">{{$t('supplierManage.area')}}</span>
                <span class="right-auto-box">
                    <sapi-area v-model="params.areaModel" clearable></sapi-area>
                </span>
            </filter-item>
        </supplierManager-filter>
	</div>
</template>

<script>
    import supplier from "../../static/js/supplier.js";
    import confirm from "@/components/sapi-confirm.js";
    import search from "@/components/sapi-search.vue";
    import filter from "@/components/filter";
    import select from "@/components/sapi-select.vue";
    import address from '../../static/js/address.js';
    import area from "@/components/sapi-area.vue";
    
	export default {
		data() {
			return {
				tableData: [],
				option: {},
				currentView: "",
                visible: false,
                deleteIds:[],
                operateText:{
                	edit:this.$t('edit'),
                	delete:this.$t('delete')
                },
                taxPayerValue: supplier.TaxPayerValue,
                enterpriseFormValue:supplier.EnterpriseFormValue,
                filterControlIsInit:false,
                supplierClasses:[],
                params:{
                    classId:null,
                    areaModel:{
						provinceId:null,
						provinceName:null,
						cityId:null,
						cityName:null,
						areaId:null,
						areaName:null
					}
                }
			}
		},		
        mixins: [getPagerMixin(), getTabMixin()],
		methods: {
            getSupplierClasses:function(statusId){
                this.$get("/api/plat/supplierClasses/brief", {}, function(res) {
                    this.supplierClasses = res || [];
				});
            },
            getProvinceCityAreaName(row){
                return address.getAddress(row.ProvinceName,row.CityName,row.AreaName,"/");
            },
            showText(row){
                var className = "";
                row.forEach(data => {
                    className += data.ClassName + ","
                });

                if(className) {
                    className = className.substr(0, className.length - 1);
                }
                return className
            },
			loadData() {
                var params = this.params;
				this.$get("/api/plat/suppliers", {
                    pageIndex:params.pageIndex,
					pageSize:params.pageSize,
                    provinceId:params.areaModel.provinceId,
					cityId:params.areaModel.cityId,
                    areaId:params.areaModel.areaId,
                    keyword:params.keyword,
                    classId:params.classId
                    },
                    function(res) {
                    this.tableData = res.Rows;
                    this.pageTotal = res.Total;
                });
                
            },
            openAddDialog()
            {
                this.currentView="supplierManage-add";
                this.visible=true;
            },
			openEditDialog(row, index) {
                 this.currentView = "supplierManage-edit";
                 this.option.SupId=row.SupId;
				 this.visible = true;
            },
            deleteSupplierQualifications(apiAddress, itemids, successFunc) 
            {
                if(itemids==null||itemids.length==0)
                {
                    Vue.msg(this.$t('selectOneWhenDeleted'));
                    return false;
                }

                this.$deleteTips(function(){
                    this.$delete(apiAddress, JSON.stringify(itemids),function(res){
                        successFunc(res);
                        Vue.successMsg(this.$t('supplierManage.delSupplierSuccess'));
                    });
                });
            },
            deleteItems()
            {
                var _this = this;
                this.deleteSupplierQualifications(
                    "/api/plat/suppliers/",
                    _this.deleteIds,
                    function(res){
                        _this.loadData();
                    });  
            },
            deleteItem(row,index)
            {
                var _this=this;
                var deleteIds=[];
                deleteIds.push(row.SupId);
                this.deleteSupplierQualifications("/api/plat/suppliers/",
                    deleteIds,
                    function(res){
                        _this.loadData();
                    });
            },
            rowSelect(datas) 
            {
               var _this=this;
               _this.deleteIds = [];
                if(datas.length > 0) {
                    datas.forEach(function(data) {
                        _this.deleteIds.push(data.SupId);
                    });
                }
            },
            openViewDialog(row)
            {
                this.currentView = "supplierManage-view";
				this.option = row;
				this.visible = true;
            },
            areaFormat(data,index){
                if(!data.provinceName){
                    return null;
                }

                let text = data.provinceName;
                
                if(data.cityName){
                    text += "/" + data.cityName;
                }

                if(data.areaName){
                    text +="/" + data.areaName;
                }

                return text;
            }
        },
        components: {
             "supplierManage-add": (resolve) => {
                require(['./add.vue'], resolve);
             },
             "supplierManage-edit": (resolve) => {
                require(['./edit.vue'], resolve);
             },
             "supplierManage-view": (resolve) => {
                require(['./view.vue'], resolve);
             },
             "sapi-search": search,
             "supplierManager-filter": filter,
             "sapi-select": select,
             "sapi-area":area
        },
		created() {
            Vue.use(confirm);
            //pager改变时将要执行的函数，对该值进行初始化
            this.pageFunc = this.loadData;
            this.getSupplierClasses();
            this.loadData();
            //初始化权限等信息
            this.$init();
		}
	}
</script>