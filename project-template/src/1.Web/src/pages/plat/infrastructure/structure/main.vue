<template>
	<div class="body-content structure" v-cloak>
		<div class="main-header" v-if="treeData.length===0">
			<div class="main-header-map">
				<span class="main-header-map-text"></span>
			</div>
		</div>
		<div class="body-content-box" :class="{active:true}">
			<div class="left-side-drag drag-element-left drag-reset"></div>
			<div class="left-side tree-wrapper left-side-border">
				<!--树形结构-->
				<stru-tree ref="treeNav" :lazy-load="struChidLazyLoad" :data="treeData" :props="struProps" :render-content="renderContent" :select-after="activeNode" :actived-id="activeNodeId" @on-click="treeNodeClick"></stru-tree>

				<!--上下文菜单（架构增删改查）-->
				<div class="selector-wrapper" @click="selWrapperClick" @mousewheel.stop="emptyFn" :class="selectorWrapper">
					<div class="drop-down-selector" ref="selectorWrapper" :style="{left:selectorWrapperLeft,top:selectorWrapperTop}">
						<p class="add-siblings" v-if="permissions.Add && struOperatorObj.AddSame!==false" @click="changeHandleType(0)">
							<img src="~@/static/images/add-same.png" />
							<span v-text="$t('structure.addStruSiblingTitle')"></span>
						</p>
						<p class="add-children" v-if="permissions.Add  && struOperatorObj.AddChild!==false" @click="changeHandleType(1)">
							<img src="~@/static/images/add-next.png" />
							<span v-text="$t('structure.addStruChildTitle')"></span>
						</p>
						<p class="edit-stru" v-if="permissions.Edit && struOperatorObj.Edit!==false" @click="changeHandleType(2)">
							<img src="~@/static/images/stru-edit.png" />
							<span v-text="$t('structure.editStruTitle')"></span>
						</p>
						<p class="delete-stru" v-if="permissions.Delete && struOperatorObj.Delete!==false" @click="changeHandleType(3)">
							<img src="~@/static/images/stru-delete.png" />
							<span v-text="$t('structure.delStruTitle')"></span>
						</p>
						<p class="delete-stru" v-if="permissions.Import && struOperatorObj.Import!==false" @click="changeHandleType(5)">
							<img src="~@/static/images/download.png" />
							<span v-text="$t('structure.importStruTitle')"></span>
						</p>
						<p class="browse-stru" v-if="permissions.View && struOperatorObj.Browse!==false" @click="changeHandleType(4)">
							<img src="~@/static/images/browse.png" />
							<span v-text="$t('structure.browseStruTitle')"></span>
						</p>
					</div>
				</div>
			</div>
			<div class="right-side">
				<station-list :option="stationOption"></station-list>
			</div>
		</div>

		<!--架构添加同级、子级-->
		<component v-bind:is="struOperateView" v-model="struOperateVisible" :option="struOperateOption" :title="struOperateTitle" @callback="loadData"></component>

		<!--架构导入组件-->
		<import-structrue width="660px" v-model="struImportVisible" type=".xlsx" :title="$t('structure.importStructureTitle')" :confirm-api="getStruImportUrl" @callback="loadData">
			<div class="checkbox-pos">
				<el-checkbox v-model="isCover" :label="true" v-if="!activeStru.StruName">
					<span class="f-12">{{$t('structure.importConfirm.0')}}</span>
				</el-checkbox>
				<el-checkbox v-model="isCover" :label="true" v-else>
					<span class="f-12">{{$t('structure.importConfirm.1')}}
						<span class="struName" :title="activeStru.StruName">{{activeStru.StruName}}</span>{{$t('structure.importConfirm.2')}}</span>
				</el-checkbox>
			</div>
			<div>
				<div class="text-gray">
					<div class="mb-5">
						{{$t('structure.importDesc.0')}}
						<a class="text-info" :href="getStruTemplateUrl">&lt;{{$t('structure.importDesc.1')}}&gt;</a>
						{{$t('structure.importDesc.2')}}
					</div>
					<span class="text-warning">{{$t('structure.importDesc.3')}}</span><br/>
					<span v-if="!activeStru.StruName">
						{{$t('structure.importDesc.4')}}<br /> {{$t('structure.importDesc.5')}}
					</span>
					<span v-else>
						{{$t('structure.importDesc.6')}}
						<span class="struName">{{activeStru.StruName}}</span>{{$t('structure.importDesc.7')}}<br /> {{$t('structure.importDesc.8')}}
						<span class="struName">{{activeStru.StruName}}</span>{{$t('structure.importDesc.9')}}
						<span class="struName">{{activeStru.StruName}}</span>{{$t('structure.importDesc.10')}}
					</span>
				</div>
			</div>
		</import-structrue>
	</div>
</template>
<script>
import tree from "@/components/tree";
import tips from "@/components/sapi-tips.js";
import drag from "@/components/sapi-move-module.js";
import stationList from "./station/list.vue";
import struImport from "@/components/base/base-import.vue";

export default {
    data() {
        return {
            currentView: "",
            stationOption: {},
            treeId: null,
            treeData: [],
            struProps: {
                children: "Children",
                label: "StruName",
                parentId: "ParentStruId",
                value: "StruId",
                hasChild: "HasChild"
            },
            activeNodeId: null,
            activeStru: {
                StruId: "",
                StruName: "",
                StruType: "",
                ParentStruId: "",
                ParentStruType: "",
                ParentStruName: ""
            },
            struOperatorObj: {
                AddSame: false,
                AddChild: false,
                Edit: false,
                Delete: false,
                Browse: false,
                Import: false
            },
            struOperateView: "",
            struOperateVisible: false,
            struOperateOption: {},
            struOperateTitle: "",
            parentActiveNodeId: "",
            struImportVisible: false,
            struExexportVisible: false,
            isCover: false, //导入配置，是否覆盖当前数据

            selectorWrapper: null,
            selectorWrapperLeft: 0,
            selectorWrapperTop: 0
        };
    },
    computed: {
        getStruTemplateUrl() {
            return (
                globalConfig.baseUrl +
                "/Templates/Excel/Import/企业架构导入模板.xlsx"
            );
        },
        getStruImportUrl() {
            var struId = this.activeStru.StruId || "";
            return (
                "/api/plat/structures/import?struId=" +
                struId +
                "&isCover=" +
                this.isCover
            );
        }
    },
    methods: {
        emptyFn() {},
        loadData() {
            var url = "/api/plat/structures/brief";
            var params = {
                withDept: true,
                nodeIdKey: "parentStruId"
            };
            var nodeId = this.parentActiveNodeId || this.activeNodeId;
            if (nodeId) {
                url = "/api/plat/structures/" + nodeId + "/parentAndSiblings";
                params = { withDept: true };

                this.activeNodeId = nodeId;
            }

            this.$get(url, params, function(res) {
                this.treeData = res;

                //第一次加载默认选中首节点
                if (!this.activeNodeId && this.treeData.length > 0) {
                    this.$nextTick(() => {
                        this.$refs.treeNav.defaultExpandNode();
                        //初始化选中
                        this.activeNodeId = this.treeData[0].StruId;
                        this.stationOption = this.treeData[0];
                    });
                }
            });
        },
        //点击下三角，加载公司下的公司/部门，获取部门下的岗位
        struChidLazyLoad(item, callback) {
            let url = "/api/plat/structures/brief",
                params = {
                    withDept: true,
                    parentStruId: item["StruId"]
                };
            this.$get(url, params, function(res) {
                callback(res);
            });
        },
        //点击下三角，渲染内容如下
        renderContent(data) {
            var struName = data[this.struProps.label];
            var iconHtml,
                className,
                iconNode = "";

            if (!data.ParentStruId && data.StruType === 0) {
                //集团
                className = "treeNode treeRoot";
                iconHtml = "<font>G</font>";
            } else if (data.StruType === 0) {
                //公司
                className = "treeNode treeCompany";
                iconHtml = "<font>C</font>";
            } else {
                //部门
                className = "treeNode treeDepart";
                iconHtml = "<font>D</font>";
            }

            //架构可以进行新增、修改、删除、查看
            iconNode =
                "<span class='nodeIcon add-btn-span' @click.stop='loadContextMenu'></span>";

            //这里有两种返回方式，第一种就是直接返回html字符串，另外一种是返回一个对象，比如{html:'<div></div>',vm:this}
            // 这里vm需要返回的原因是：renderContent距离sapi-tree太远，难以定位，（假如renderContent定义跟sapi-tree引入不在同一个组件，必须使用该方式）
            return (
                "<div class='" +
                className +
                "'>" +
                iconHtml +
                "<span title='" +
                struName +
                "' class='text'>" +
                struName +
                "</span>" +
                iconNode +
                "</div>"
            );
        },
        //架构操作按钮
        loadContextMenu(data, e) {
            if (!data.ParentStruId) {
                //顶级架构
                this.struOperatorObj = {
                    AddSame: false,
                    AddChild: true,
                    Edit: true,
                    Delete: data.IsLeaf ? true : false,
                    Browse: true,
                    Import: data.StruType == 0 ? true : false
                };
            } else {
                //非顶级
                this.struOperatorObj = {
                    AddSame: true,
                    AddChild: true,
                    Edit: true,
                    Delete: data.IsLeaf ? true : false,
                    Browse: true,
                    Import: data.StruType == 0 ? true : false
                };
            }

            //初始化当前选中的节点信息
            this.activeNode(data);

            var bodyHeight = document.body.clientHeight - 217;

            var x = e.clientX - 52;
            var y = e.clientY + 26;

			this.selectorWrapper = "active";
            this.selectorWrapperLeft = x + "px";
            this.selectorWrapperTop = y + "px";
            if (y < bodyHeight) {
                return;
            }

            this.$nextTick(function() {
                var drop = this.$refs.selectorWrapper;
                y -= drop.clientHeight + 46;
                this.selectorWrapperTop = y + "px";
                let className = " upDropNode";
                this.selectorWrapper = "active" + className;
            });
        },
        selWrapperClick(e) {
            this.selectorWrapper = null;
        },
        //点击架构，加载岗位
        treeNodeClick(data, e) {
            this.stationOption = data;

            //初始化当前选中节点信息，后续需用到
            this.activeNode(data);
        },
        //当前初始化节点
        activeNode(node) {
            this.activeStru.StruId = node.StruId;
            this.activeStru.StruName = node.StruName;
            this.activeStru.StruType = node.StruType;
            this.activeStru.ParentStruId = node.ParentStruId;
            this.activeStru.ParentStruType = node.ParentStruType;
            this.activeStru.ParentStruName = node.ParentStruName;

            //激活当前节点
            this.activeNodeId = node.StruId;
        },
        changeHandleType(type) {
            this.struOperateVisible = true;
            this.parentActiveNodeId = null; //用于新增、修改后架构的刷新
            this.struOperateOption = {};
            switch (type) {
                case 0: //新增同级
                case 1: //新增子级
                    this.struOperateView = "stru-add";

                    if (type == 0) {
                        this.struOperateOption.ParentStruId = this.activeStru.ParentStruId;
                        this.struOperateOption.ParentStruType = this.activeStru.ParentStruType;
                        this.struOperateOption.ParentStruName = this.activeStru.ParentStruName;
                        this.struOperateTitle = this.$t(
                            "structure.addStructureSameLevelTitle"
                        );

                        this.parentActiveNodeId = this.activeStru.ParentStruId;
                    } else {
                        this.struOperateOption.ParentStruId = this.activeStru.StruId;
                        this.struOperateOption.ParentStruType = this.activeStru.StruType;
                        this.struOperateOption.ParentStruName = this.activeStru.StruName;
                        this.struOperateTitle = this.$t(
                            "structure.addStructureChildTitle"
                        );
                    }
                    break;
                case 2: //修改
                    this.struOperateView = "stru-edit";
                    this.struOperateOption = this.activeStru;
                    this.struOperateTitle =
                        this.activeStru.StruType === 0
                            ? this.$t("structure.editStruCorpTitle")
                            : this.$t("structure.editStruDeptTitle");
                    break;
                case 3: //删除
                    this.struOperateVisible = false;
                    this.deleteStru();
                    this.parentActiveNodeId = this.activeStru.ParentStruId;
                    break;
                case 4: //查看
                    this.struOperateView = "stru-view";
                    this.struOperateOption = this.activeStru;
                    this.struOperateTitle =
                        this.activeStru.StruType === 0
                            ? this.$t("structure.browseStruCorpTitle")
                            : this.$t("structure.browseStruDeptTitle");
                    break;
                case 5: //导入
                    this.struOperateVisible = false;
                    this.struImportVisible = true;
                    this.importStru();
            }
        },
        //删除架构
        deleteStru() {
            this.$deleteTips(function() {
                var struType = this.activeStru.StruType;
                this.$delete(
                    "/api/plat/structures/" +
                        this.activeStru.StruId +
                        "?struType=" +
                        this.activeStru.StruType,
                    function(res) {
                        this.parentStruId = this.activeStru.ParentStruId;
                        this.activeStru = {
                            StruId: "",
                            StruName: "",
                            StruType: "",
                            ParentStruId: "",
                            ParentStruType: "",
                            ParentStruName: ""
                        };
                        this.loadData();
                        Vue.successMsg(
                            struType != 1
                                ? this.$t("structure.deleteCorpSuccess")
                                : this.$t("structure.deleteDeptSuccess")
                        );
                    }
                );
            });
        },
        //导入架构
        importStru() {
            this.isCover = false;
            this.struImportVisible = true;
        },
        setMapOffsetPosition(width, boxWidth) {
            var dom = this.$el.querySelector(
                ".right-side .main-header-offset-position"
            );
            if (!dom) {
                return;
            }

            dom.style.left = "-" + width + "px";
            dom.style.width = "calc(100% + " + width + "px)";
        }
    },
    components: {
        "station-list": stationList,
        "stru-tree": tree,
        "stru-add": resolve => {
            require(["./add.vue"], resolve);
        },
        "stru-edit": resolve => {
            require(["./edit.vue"], resolve);
        },
        "stru-view": resolve => {
            require(["./view.vue"], resolve);
        },
        "import-structrue": struImport
    },
    created() {
        Vue.use(tips);
        this.$init();
        this.activeNodeId = null;
        this.loadData();
    },
    mounted() {
        this.$nextTick(function() {
            var _this = this;
            drag.move(this, ".left-side", ".right-side", ".left-side-drag", {
                type: 2,
                offsetHeight: 102,
                callback(leftWidth, boxWidth) {
                    _this.setMapOffsetPosition(leftWidth, boxWidth);
                }
            });
        });
    },
    watch: {}
};
</script>
<style>
/* .pr-6{
	padding-right: 6px;
} */
</style>

<style lang="less">
@import "~@/static/css/sapi-global";
@import "../../static/css/structure-tree";
</style>