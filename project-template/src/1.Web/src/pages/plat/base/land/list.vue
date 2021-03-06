<template>
	<div class="main">
		<div class="main-header">
			<div class="main-header-map">
				<span class="main-header-map-text"></span>
			</div>
			<div class="main-header-search">
				<div class="func-btns">
					<sapi-search v-model="params.keyword" :placeholder="$t('land.search')" @on-search="loadData"></sapi-search>
					<span v-if="permissions.Add" class="icon-btn" @click="openAddDialog" :title="$t('add')">
						<i class="icon-build"></i>
					</span>
					<span class="icon-btn icon-filter" :title="$t('filter')"></span>
				</div>
			</div>
		</div>

		<div class="main-table table-no-border width-p100">
			<el-table border :data="tableData" ref="bodyTable" @sort-change="sortChange" :height="maxBodyHeight">
				<el-table-column prop="LandName" :label="$t('land.landName')" show-overflow-tooltip sortable>
					<template slot-scope="props">
						<a href="javascript:void(0)" @click="openViewDialog(props.row)">{{props.row.LandName}}</a>
					</template>
				</el-table-column>
				<el-table-column prop="LandNo" :label="$t('land.landNo')" width="120" sortable show-overflow-tooltip>
				</el-table-column>
				<el-table-column :label="$t('land.area')" width="180" show-overflow-tooltip>
					<template slot-scope="props">
						{{ getProvinceCityAreaName(props.row) }}
					</template>
				</el-table-column>
				<el-table-column prop="LandAddress" :label="$t('land.landAddress')" width="300" show-overflow-tooltip>
				</el-table-column>
				<el-table-column prop="LandArea" :label="$t('land.landArea')" width="120" show-overflow-tooltip>
				</el-table-column>
				<el-table-column prop="GrantYear" :label="$t('land.grantYear')" width="100" show-overflow-tooltip>
				</el-table-column>
				<el-table-column :label="$t('handle')" fixed="right" width="120" v-if="permissions.Edit || permissions.Delete">
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

		<land-filter @on-confirm="loadData" :is-init="true">
			<filter-item :param.sync="params.areaModel" :default-value="{}" :data="params.areaModel" :format="areaFormat">
				<span class="w-65">{{$t('land.area')}}</span>
				<span class="right-auto-box">
					<sapi-area v-model="params.areaModel" clearable></sapi-area>
				</span>
			</filter-item>
		</land-filter>
	</div>
</template>

<script>
import select from "@/components/sapi-select.vue";
import confirm from "@/components/sapi-confirm.js";
import search from "@/components/sapi-search.vue";
import filter from "@/components/filter";
import address from "../../static/js/address.js";
import area from "@/components/sapi-area.vue";
export default {
    data() {
        return {
            tableData: [],
            option: {},
            currentView: "",
            visible: false,
            operateText: {
                edit: this.$t("edit"),
                delete: this.$t("delete")
            },
            params: {
                areaModel: {
                    provinceId: null,
                    provinceName: null,
                    cityId: null,
                    cityName: null,
                    areaId: null,
                    areaName: null
                }
            }
        };
    },
    components: {
        "land-add": resolve => {
            require(["./add.vue"], resolve);
        },
        "land-edit": resolve => {
            require(["./edit.vue"], resolve);
        },
        "land-view": resolve => {
            require(["./view.vue"], resolve);
        },
        "sapi-search": search,
        "sapi-select": select,
        "land-filter": filter,
        "sapi-area": area
    },
    mixins: [getPagerMixin(), getTabMixin()],
    methods: {
        loadData() {
            var params = this.params;

            this.$get(
                "/api/plat/lands",
                {
                    pageIndex: params.pageIndex,
                    pageSize: params.pageSize,
                    sortName: params.sortName,
                    sortType: params.sortType,
                    provinceId: params.areaModel.provinceId,
                    cityId: params.areaModel.cityId,
                    areaId: params.areaModel.areaId,
                    keyword: params.keyword
                },
                function(res) {
                    this.tableData = res.Rows;
                    this.pageTotal = res.Total;
                }
            );
        },
        openAddDialog() {
            this.currentView = "land-add";
            this.visible = true;
        },
        openEditDialog(row, index) {
            this.currentView = "land-edit";
            this.option = row;
            this.visible = true;
        },
        deleteItem(row, index) {
            var _this = this;
            this.$deleteTips(function() {
                this.$delete("/api/plat/lands/" + row.LandId, [], function(
                    res
                ) {
                    _this.loadData();
                    Vue.successMsg(this.$t("land.delLandSuccess"));
                });
            });
        },
        openViewDialog(row, index) {
            this.currentView = "land-view";
            this.option = row;
            this.visible = true;
        },
        sortChange(obj) {
            this.params.sortName = obj.prop;
            this.params.sortType = obj.order;
            this.pageCurrentChange(1);
        },
        getProvinceCityAreaName(row) {
            return address.getAddress(
                row.ProvinceName,
                row.CityName,
                row.AreaName,
                "/"
            );
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
    created() {
        Vue.use(confirm);
        //pager改变时将要执行的函数，对该值进行初始化
        this.pageFunc = this.loadData;
        this.loadData();
        //初始化权限等
        this.$init();
    },
    watch: {
        /*
			"params.provinceId"(val){
				if(!val&&this.citys.length>0){
					setTimeout(()=>{
						this.params.cityId=null;
						this.params.areaId=null;
						this.citys=[];
						this.areas=[];
					});
				}
			},
			"params.cityId"(val){
				if(!val&&this.areas.length>0){
					setTimeout(()=>{
						this.params.areaId=null;
						this.areas=[];
					});
				}
			}
			*/
    }
};
</script>
