<template>
	<sapi-dialog v-model="visible" width="800px" top="15%" class="add" @on-open="open" @on-close="close">
		<span slot="title" v-text="$t('land.choiceLandTitle')"></span>
		<div class="form-error-tips"></div>
		<div class="form-content">
            <div class="fullline">
                <div class="wp-50">
                <div class="right-power-box relative">
                        <sapi-area v-model="params.areaModel" clearable @change="getTableData"></sapi-area>
                    </div>
                </div>
                <div class="wp-50 float-right btn-outer relative"  @keyup.enter="getTableData">
                    <el-input  v-model="params.keyword" :maxlength="200" :placeholder="$t('land.search')">
                        <a slot="suffix" class="el-icon-search" @click="getTableData"></a>
                    </el-input>
                </div>
            </div>
            <div class="fullline width-p100">
                <el-table ref="multipleTable" :data="tableData" @selection-change="selectionChange">
                    <el-table-column type="selection" :selectable="colSelectable">
                    </el-table-column>
                    <el-table-column :label="$t('land.landName')" show-overflow-tooltip prop="LandName">
                    </el-table-column>
                    <el-table-column prop="LandNo" :label="$t('land.landNo')" width="120" sortable show-overflow-tooltip>
				    </el-table-column>
                    <el-table-column :label="$t('land.area')" width="180" show-overflow-tooltip>
                        <template slot-scope="props">
                            {{ getProvinceCityAreaName(props.row) }}
                        </template>
                    </el-table-column>
                </el-table>
            </div>
            <div class="fullline">
                <el-pagination @size-change="pageSizeChange" @current-change="pageCurrentChange" :current-page="params.pageIndex" 
                :page-sizes="pageArr" :page-size="params.pageSize" :layout="layout" :total="pageTotal">
			    </el-pagination>
            </div>
		</div>

		<div class="footer">
            <el-button size="small" class="cancel" @click="close" v-text="$t('cancel')"></el-button>
			<el-button class="blue-button" size="small" :disabled="disabled" @click="confirm" v-text="$t('determine')"></el-button>
		</div>
	</sapi-dialog>
</template>

<script>
	import tips from "@/components/sapi-tips.js";
    import dialog from "@/components/sapi-dialog.vue";
    import address from '../../static/js/address.js';
    import select from "@/components/sapi-select.vue";
    import area from "@/components/sapi-area.vue";
	export default {
		data() {
			return {
				disabled: false,
				visible: false,
				params:{
                    areaModel: {
                        provinceId: null,
                        provinceName: null,
                        cityId: null,
                        cityName: null,
                        areaId: null,
                        areaName: null
                    }
				},
                tableData: [],
                lastSelectedLands: [],  //上次选中
                lastSelectedLandIds:[], //上次选中的Id值
                currentSelectedLands: []  //当前已选中
			}
		},
        props: ["option","value","callBack"],
        mixins: [getPagerMixin()],
		methods: {
            open() {
                //防止每次打开重新赋值后值重复，在这里进行清空
                this.tableData = [];
                this.params.keyword = "";
                this.params.pageIndex = 1;
                this.params.pageSize = 10;
                this.params.areaModel.provinceId = this.option.ProvinceId;
                this.params.areaModel.areaId = this.option.AreaId;
                this.params.areaModel.cityId = this.option.CityId;
                //获取上次选中的值
                this.lastSelectedLands = [].concat(this.option.SelectedLands);
                this.lastSelectedLandIds = [].concat(this.option.LastSelectedLandIds);
                this.getTableData();
            },
			close() {
				this.$closeWaringTips(".form-error-tips");
                this.$emit("input", false);
            },
            confirm() {
                var result = this.selectedLandRemoveRepeat(this.currentSelectedLands.concat(this.lastSelectedLands));
                this.$emit("call-back",result);
				this.close();
            },
            getTableData() {
            	var params=this.params;
                this.$get("/api/plat/lands", 
                    {
                        pageIndex: params.pageIndex,
                        pageSize: params.pageSize,
                        provinceId: params.areaModel.provinceId,
                        cityId: params.areaModel.cityId,
                        areaId: params.areaModel.areaId,
                        keyword: params.keyword
                    }, 
                    function(res) {
                    this.tableData = res.Rows;
                    this.pageTotal = res.Total;
                
                    if(this.lastSelectedLandIds)
                    {
                        this.$nextTick(function () {
                            //遍历列表页中的行对选中的Id行进行勾选
                            for(var i=0;i<this.tableData.length;i++)
                            {
                                var row = this.tableData[i];
                                var bSelect = this.lastSelectedLandIds.indexOf(row.LandId)>-1;
                                this.$refs.multipleTable.toggleRowSelection(row,bSelect);
                            }
                        })                        
                    }
                });
            },
            //设置行是否可以勾选
            colSelectable(row,index){
                if(this.lastSelectedLandIds.indexOf(row.LandId) > -1)
                {
                    return false;
                }
                return true;
            },
            getProvinceCityAreaName(row)
            {
                return address.getAddress(row.ProvinceName,row.CityName,row.AreaName,"/");
            },
			selectionChange(datas) {
                this.currentSelectedLands = datas;
            },
            //数组去重复值
            selectedLandRemoveRepeat:function(array)
            {
                var result = [];
                for(var i = 0; i < array.length; i ++) {
                    var flag = true;
                    var temp = array[i];
                    for(var j = 0; j < result.length; j ++) {
                        if(temp.LandId === result[j].LandId) {
                            flag = false;
                            break;
                        }
                    }
                    if(flag) {
                        result.push(temp);
                    }
                }
                return result;
            }
		},
		components: {
            "sapi-dialog": dialog,
            "sapi-select": select,
            "sapi-area": area
		},
		watch: {
			value(val) {
				this.visible = this.value;
			}
		},
		created() {
            Vue.use(tips);
            this.pageFunc = this.getTableData;
		},
		mounted() {
			this.visible = this.value;
		}
	}
</script>

<style scoped="scoped">
    .wp-33{
    display: inline-block;
        width: calc(33% - 6px);
        padding-right: 5px;
    }
</style>

