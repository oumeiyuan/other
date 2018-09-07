<template>
    <div class="body-content structure" v-if="permissions.View">

        <div class="body-content-box" :class="{active:true}">
            <div class="left-side-drag drag-element-left drag-reset"></div>
            <div class="left-side tree-wrapper left-side-border">
                <!--树形结构-->
                <project-tree ref="treeNav" :lazy-load="corpProjectLazyLoad" :data="corpProjectTreeData" :props="defaultProps" :render-content="renderContent" :select-after="activeNode" :actived-id="activeNodeId" @on-click="corpProjectTreeNodeClick"></project-tree>

                <!--下拉选择框（项目新增、修改、删除、查看）-->
                <div class="selector-wrapper" @click="selWrapperClick" @mousewheel.stop="emptyFn" :class="selectorWrapper">
                    <div class="drop-down-selector" ref="selectorWrapper" :style="{left:selectorWrapperLeft,top:selectorWrapperTop}">
                        <p class="add-siblings" v-if="permissions.Add && showProjectObj.AddSame!==false" @click="changeHandleType(0)">
                            <img src="~@/static/images/add-same.png" />
                            <span v-text="$t('project.addProjectSiblingTitle')"></span>
                        </p>
                        <p class="add-children" v-if="permissions.Add  && showProjectObj.AddChild!==false" @click="changeHandleType(1)">
                            <img src="~@/static/images/add-next.png" />
                            <span v-text="$t('project.addProjectChildTitle')"></span>
                        </p>
                        <p class="edit-project" v-if="permissions.Edit && showProjectObj.Edit!==false" @click="changeHandleType(2)">
                            <img src="~@/static/images/stru-edit.png" />
                            <span v-text="$t('project.editProjectTitle')"></span>
                        </p>
                        <p class="delete-project" v-if="permissions.Delete && showProjectObj.Delete!==false" @click="changeHandleType(3)">
                            <img src="~@/static/images/stru-delete.png" />
                            <span v-text="$t('project.delProjectTitle')"></span>
                        </p>
                        <p class="browse-project" v-if="showProjectObj.Browse!==false" @click="changeHandleType(4)">
                            <img src="~@/static/images/browse.png" />
                            <span v-text="$t('project.browseProjectTitle')"></span>
                        </p>
                    </div>
                </div>
            </div>
            <div class="right-side">
                <!--楼栋列表组件-->
                <building-list :option="buildingOption"></building-list>
            </div>
        </div>

        <!--项目添加同级、子级-->
        <component v-bind:is="proOperateView" v-model="proOperateVisible" :option="proOperateOption" :title="proOperateTitle" @callback="getCorpProjectTree"></component>
    </div>
</template>

<script>
import tips from "@/components/sapi-tips.js";
import confirm from "@/components/sapi-confirm.js";
import projectTree from "@/components/tree";
import drag from "@/components/sapi-move-module.js";
import buildingList from "./list.vue";
import search from "@/components/sapi-search.vue";

export default {
    data() {
        return {
            //公司项目树
            corpProjectTreeData: [],
            activeNodeId: null,
            defaultParams: {
                ItemId: null
            },
            defaultProps: {
                children: "Children",
                label: "ItemName",
                value: "ItemId",
                hasChild: "HasChild"
            },
            //项目新增、修改、删除、查看
            showProjectObj: {
                AddSame: false,
                AddChild: false,
                Edit: false,
                Delete: false,
                Browse: false
            },
            proOperateView: "",
            proOperateVisible: false,
            proOperateOption: {},
            proOperateTitle: "",
            projectParentItemId: null, //用于项目增删改存放上级节点使用，可为公司Id或项目Id
            projectParentId: null, //项目的父级Id,如果没有，则是null，公司不算

            //搜索定位项目
            isSearch: false,
            //楼栋
            buildingOption: {
                ProjectId: null,
                ItemType: null
            },

            selectorWrapper: null,
            selectorWrapperLeft: 0,
            selectorWrapperTop: 0
        };
    },
    mixins: [getTabMixin()],
    computed: {},
    components: {
        "project-tree": projectTree,
        "project-add": resolve => {
            require(["../project/add.vue"], resolve);
        },
        "project-edit": resolve => {
            require(["../project/edit.vue"], resolve);
        },
        "project-view": resolve => {
            require(["../project/view.vue"], resolve);
        },
        "building-list": buildingList,
        "building-add": resolve => {
            require(["./add.vue"], resolve);
        },
        "sapi-search": search
    },
    methods: {
        emptyFn(){

        },
        //刷新页面调用
        getCorpProjectTree(type) {
            var nodeId = this.projectParentItemId || this.activeNodeId;
            var url =
                type == "C"
                    ? "/api/plat/projects/corpProjects"
                    : "/api/plat/projects/childProjects";
            var params =
                type == "C"
                    ? { parentCorpId: nodeId }
                    : { parentProjectId: nodeId };
            if (nodeId) {
                params = {};
                if (type == "Del") {
                    //移除项目
                    //当移除的项目是最顶级项目时，需要获取改项目所属公司的[前辈和下级]
                    //当移除的项目为分期项目，需要获取其父级项目的[前辈和下级]
                    url =
                        "/api/plat/projects/" +
                        this.projectParentItemId +
                        (!this.projectParentId
                            ? "/corpParentAndSiblings"
                            : "/projectParentAndSiblings");
                } else {
                    //addSame为true，表示公司下新增项目，否则为项目下新增分期
                    url =
                        "/api/plat/projects/" +
                        this.activeNodeId +
                        (this.showProjectObj.AddSame
                            ? "/corpParentAndSiblings"
                            : "/projectParentAndSiblings");
                }
            }

            this.$get(url, params, function(res) {
                this.corpProjectTreeData = res || [];

                //第一次加载默认选中首节点
                if (!this.activeNodeId && this.corpProjectTreeData.length > 0) {
                    this.$nextTick(() => {
                        this.$refs.treeNav.defaultExpandNode();
                        //初始化选中
                        this.activeNodeId = this.corpProjectTreeData[0].ItemId;
                    });
                }
            });
        },
        //点击下三角，加载公司下的公司/项目，获取项目下的项目
        corpProjectLazyLoad(item, callback) {
            let url =
                item.ItemType == "C"
                    ? "/api/plat/projects/corpProjects"
                    : "/api/plat/projects/childProjects";
            let params =
                item.ItemType == "C"
                    ? {
                          parentCorpId: item[this.defaultProps.value]
                      }
                    : {
                          parentProjectId: item[this.defaultProps.value]
                      };

            this.$get(url, params, function(res) {
                callback(res);
            });
        },
        //点击下三角，加载内容下
        renderContent(data, index) {
            var text = data[this.defaultProps.label];
            var iconHtml,
                className,
                iconNode = "";

            if (!data.ParentItemId && data.ItemType === "C") {
                //集团
                className = "treeNode treeRoot";
                iconHtml = "<font>G</font>";
            } else if (data.ItemType === "C") {
                //公司
                className = "treeNode treeCompany";
                iconHtml = "<font>C</font>";
            } else {
                //项目
                className = "treeNode treeProject";
                iconHtml = "<font>P</font>";
            }

            //项目可以进行新增、修改、删除、查看
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
                text +
                "' class='text'>" +
                text +
                "</span>" +
                iconNode +
                "</div>"
            );
        },
        //当前初始化节点
        activeNode(node) {
            this.defaultParams.ItemId = node.ItemId;
            this.defaultParams.ItemName = node.ItemName;
            this.defaultParams.ItemType = node.ItemType;
            this.defaultParams.ParentItemId = node.ParentItemId;
            this.defaultParams.CorpId = node.CorpId;

            //激活当前节点
            this.activeNodeId = node.ItemId;
        },
        //项目增删改查
        loadContextMenu(data, e) {
            switch (data.ItemType) {
                case "C": //公司
                    this.showProjectObj = {
                        AddSame: true,
                        AddChild: false,
                        Edit: false,
                        Delete: false,
                        Browse: false
                    };
                    break;
                case "P": //项目
                    if (!data.ParentItemId) {
                        //顶级项目
                        this.showProjectObj = {
                            AddSame: false,
                            AddChild: true,
                            Edit: true,
                            Delete: data.IsLeaf ? true : false,
                            Browse: true
                        };
                    } else {
                        //非顶级项目
                        this.showProjectObj = {
                            AddSame: false,
                            AddChild: false,
                            Edit: true,
                            Delete: true,
                            Browse: true
                        };
                    }
            }

            //初始化当前选中的节点信息
            this.activeNode(data);

            var bodyHeight = document.body.clientHeight - 160;

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
                y -= drop.clientHeight + 36;
                this.selectorWrapperTop = y + "px";
                let className = " upDropNode";
                this.selectorWrapper = "active" + className;
            });
        },
        selWrapperClick(e) {
            this.selectorWrapper = null;
        },
        changeHandleType(type) {
            this.proOperateVisible = true;
            this.projectParentItemId = null;
            this.showProjectObj.OperType = type;
            switch (type) {
                case 0: //新增同级
                case 1: //新增子级
                    this.proOperateView = "project-add";

                    if (type == 0) {
                        this.proOperateOption.AddChild = false;
                        this.proOperateOption.CorpId = this.defaultParams.CorpId;
                        this.proOperateTitle = this.$t(
                            "project.addProjectSiblingTitle"
                        );

                        this.projectParentItemId = !this.defaultParams
                            .ParentItemId
                            ? this.defaultParams.CorpId
                            : this.defaultParams.ParentItemId;
                    } else {
                        this.proOperateOption.AddChild = true;
                        this.proOperateOption.ProjectId = this.defaultParams.ItemId;
                        this.proOperateTitle = this.$t(
                            "project.addProjectChildTitle"
                        );
                    }

                    break;
                case 2: //修改
                    this.proOperateView = "project-edit";
                    this.proOperateOption.ProjectId = this.defaultParams.ItemId;
                    this.proOperateOption.ParentProjectId = this.defaultParams.ParentItemId;
                    this.proOperateTitle = this.$t("project.editProjectTitle");

                    break;
                case 3: //删除
                    this.proOperateVisible = false;
                    this.projectParentItemId = !this.defaultParams.ParentItemId
                        ? this.defaultParams.CorpId
                        : this.defaultParams.ParentItemId;
                    this.projectParentId = this.defaultParams.ParentItemId;
                    this.deleteProject(this.defaultParams.ItemId);

                    break;
                case 4: //查看
                    this.proOperateView = "project-view";
                    this.proOperateOption.ProjectId = this.defaultParams.ItemId;
                    this.proOperateOption.ParentProjectId = this.defaultParams.ParentItemId;
                    this.proOperateTitle = this.$t(
                        "project.browseProjectTitle"
                    );

                    break;
            }
        },
        //项目移除
        deleteProject(projectId) {
            var _this = this;
            this.deleteProjects("/api/plat/projects/" + projectId, {}, function(
                res
            ) {
                _this.getCorpProjectTree("Del");
            });
        },
        deleteProjects(apiAddress, itemIds, successFunc) {
            if (itemIds.length == 0) {
                Vue.msg(this.$t("selectOneWhenDeleted"));
                return false;
            }

            this.$deleteTips(function() {
                this.$delete(apiAddress, JSON.stringify(itemIds), function(
                    res
                ) {
                    this.activeNodeId = this.projectParentItemId;
                    successFunc(res);
                    Vue.successMsg(this.$t("project.delProjectSuccess"));
                });
            });
        },
        //加载项目下楼栋
        corpProjectTreeNodeClick(data) {
            this.buildingOption.ProjectId = data.ItemId;
            this.buildingOption.ItemType = data.ItemType;
            //初始化当前选中节点信息，后续需用到
            this.activeNode(data);
        },
        //控制树状和楼列表页分割线
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
    created() {
        Vue.use(tips);
        Vue.use(confirm);
        this.$init();
        this.activeNodeId = null;
        this.getCorpProjectTree("C");
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
    mounted() {}
};
</script>

<style lang="less">
@import "~@/static/css/sapi-global";
@import "../../static/css/structure-tree";
</style>
