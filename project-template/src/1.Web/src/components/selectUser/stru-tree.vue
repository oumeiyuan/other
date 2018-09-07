<template>
    <div class="tabs-contents search-stru-tree" ref="list" :class="{'overflow-hide':isSearch && treeSearchData.length>0}">
        <div class="position-search" :class="{active:isSearch}" :style="{height:maxHeight}">
            <div class="position-search-text">
                <i class="el-icon-location"></i>
                <input class="position-search-input" ref="input" :maxlength="40" v-model="filterText" @keydown.enter="search" @click.stop="searchActive=!searchActive" />
                <i class="el-icon-circle-close" @click.stop="searchCloseClick"></i>
            </div>
            <div class="position-search-list" :class="{active:treeSearchData.length>0}">
                <span class="up-arrow set-position"></span>
                <div class="position-search-list-ul" v-if="nodata===false">
                    <ul>
                        <li :key="index" v-for="(item, index) in treeSearchData" @click.stop="itemClick(item)">
                            <p v-html="searchText(item)" :title="item.StruName"></p>
                            <p v-text="item.StruType !==0 ? item.CorpName : ''" :title="item.StruType !==0 ? item.CorpName : ''"></p>
                        </li>
                    </ul>
                </div>

                <div v-else class="position-search-list-nodata" @click.stop="emptyFn">暂无数据</div>
            </div>
        </div>
        <sapi-tree class="stru-tree" ref="treeNav" :lazy-load="lazyLoad" :data="treeData" :render-content="renderContent" :select-after="activeFn" :props="defaultProps" :actived-id="nodeId" @on-click="nodeClick">
        </sapi-tree>
    </div>
</template>

<script>
let _windowFn;
import tree from "../tree/";
export default {
    components: {
        "sapi-tree": tree
    },
    props: {
        isFresh: false,
        props: Object,
        activeFn: Function,
        activeId: String,
        loadStruData: Function,
        loadTreeAfter: Function,
        multiple: Boolean
    },
    data() {
        return {
            nodeId: null,
            nodata: false,
            filterText: null,
            isSearch: false,
            searchDelay: false,
            searchActive: false,
            searchOpen:false,
            treeSearchData: [],
            filterReg: null,
            treeData: [],
            defaultProps: {
                children: "Children",
                label: "StruName",
                value: "StruId",
                hasChild: "HasChild"
            },
            maxHeight:0
        };
    },
    methods: {
        emptyFn() {},
        //搜索关闭事件
        searchCloseClick(flag) {
            if (flag !== true && this.filterText) {
                this.filterText = "";
                return;
            }
            if (this.searchDelay === true) {
                return;
            }
            this.searchOpen=false;
            this.filterText = "";
            this.isSearch = false;
            this.nodata=true;
            this.treeSearchData = [];
        },
        addWindowClick() {
            document.addEventListener("click", _windowFn, false);
        },
        removeWindowClick() {
            if (_windowFn) {
                _windowFn();
            }
        },
        //岗位列表标题显示格式的文本
        showText(item) {
            let fn = this.props.titleFn;
            if (typeof fn === "function") {
                return fn(item);
            }

            return item[this.props.title];
        },
        showContent(item) {
            let fn = this.props.contentFn;
            if (typeof fn === "function") {
                return fn(item);
            }

            return item[this.props.content];
        },
        //搜索时，显示的格式文本
        searchText(item) {
            if (!item.StruName) {
                return "";
            }

            return item.StruName.replace(this.filterReg, function(arg) {
                return "<font class='key-font'>" + arg + "</font>";
            });
        },

        //懒加载子节点数据
        lazyLoad(item, callback) {
            let params = {
                withDept: true,
                parentStruId: item[this.defaultProps.value]
            };
            this.$get("/api/plat/structures/brief", params, function(res) {
                callback(res);
            });
        },
        //获取企业架构数据
        loadTreeData() {
            this.nodeId = this.activeId;
            this.nodata = false;
            this.filterText = null;
            this.isSearch = false;

            var url = "/api/plat/structures/brief";
            if (this.nodeId) {
                url = "/api/plat/structures/{struId}/parentAndSiblings";
            }

            this.$get(
                url,
                {
                    withDept: true,
                    struId: this.nodeId
                },
                function(res) {
                    this.treeData = res || [];

                    if (!this.nodeId && this.treeData.length > 0) {
                        this.$nextTick(() => {
                            this.$refs.treeNav.defaultExpandNode();
                            //this.nodeId = this.treeData[0].StruId;
                            this.$nextTick(function() {
                                if (typeof this.loadTreeAfter === "function") {
                                    this.loadTreeAfter();
                                }
                            });
                        });
                    }
                }
            );
        },
        loadCurrentTree(id) {
            if (!id) {
                return;
            }
            this.$get(
                "/api/plat/structures/" + id + "/parentAndSiblings",
                {
                    withDept: true
                },
                function(res) {
                    this.treeData = res || [];

                    this.$nextTick(() => {
                        this.nodeId = id;
                    });
                }
            );
        },
        itemClick(item) {
            this.$emit("on-click", item);
            this.loadCurrentTree(item.StruId);
            this.removeWindowClick();
        },
        nodeClick(item) {
            this.$emit("on-click", item);
        },
        searchClick(data, e) {
            if(!this.maxHeight){
                this.maxHeight = this.$refs.list.clientHeight + "px";
            }
            this.treeSearchData = [];
            
            //定位查找事件
            this.isSearch = true;
            this.listHeight = null;
            this.searchOpen=false;
            this.filterText = null;
            this.searchDelay = true;
            setTimeout(()=>{
                this.searchDelay=false;
            }, 300);

            if (!_windowFn) {
                let _this = this;
                _windowFn = function(e) {
                    if (_this.isSearch === false && _this.searchOpen === true) {
                        return;
                    }

                    _this.isSearch= false;
                    document.removeEventListener("click", _windowFn);
                };
            }

            this.$nextTick(function() {
                this.$refs.input.focus();
                this.addWindowClick();
            });
        },
        //定义一个搜索时间控制器
        //向后台搜索数据
        search() {
            if (!this.filterText || !this.filterText.trim()) {
                this.treeSearchData = [];
                return;
            }

            this.searchOpen=true;

            this.$get(
                "/api/plat/structures/filters",
                {
                    keyWord: this.filterText,
                    withDept: true,
                    topCount: 20
                },
                function(res) {
                    this.filterReg = new RegExp(this.filterText, "ig");
                    this.isSearch = true;
                    if (!res || res.length === 0) {
                        this.nodata = true;
                        this.treeSearchData = [{}];
                        return;
                    }
                    this.nodata = false;

                    this.treeSearchData = res;
                    this.listHeight = "100%";
                }
            );
        },
        loadAll(item,index){
            this.nodeId=item[this.defaultProps.value];
            this.loadStruData(item);
        },
        //企业架构自定义内容格式
        renderContent(data, index) {
            var text = data[this.defaultProps.label];
            var iconHtml,
                className,
                iconNode = "";

            if (!data.ParentStruId) {
                className = "treeNode treeRoot";
                iconHtml = "<font>G</font>";
            } else if (data.StruType !== 1) {
                className = "treeNode treeCompany";
                iconHtml = "<font>C</font>";
            } else {
                className = "treeNode treeDepart";
                iconHtml = "<font>D</font>";
            }

            let child = this.defaultProps.children;
            let hasChild = this.defaultProps.hasChild;

            if (!data.ParentStruId) {
                if (index === 0) {
                    //添加事件跟vue的一样，但是这里只能添加click事件，并且不能添加参数，如果需要停止冒泡，请在后面加上.stop
                    iconNode =
                        "<p class='nodeIcon' @click.stop='searchClick'><span>定位到</span><i class='el-icon-location'></i></p>";
                }
            } else if (this.multiple === true) {
                iconNode =
                    "<i class='nodeIcon el-icon-circle-plus-outline' @click.stop='loadAll'></i>";
            }

            //这里有两种返回方式，第一种就是直接返回html字符串，另外一种是返回一个对象，比如{html:'<div></div>',vm:this}  这里vm需要返回的原因是：renderContent距离sapi-tree太远，难以定位，（假如renderContent定义跟sapi-tree引入不在同一个组件，必须使用该方式）
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
        }
    },
    watch: {
        isFresh(val) {
            if (val === true) {
                this.loadTreeData();
            }
        },
        activeId(val) {
            this.nodeId = val;
        }
    }
};
</script>

<style lang="less">
.search-stru-tree {
    .position-search + .stru-tree {
        transition: padding 0.5s 0.5s;
    }
    .position-search.active + .stru-tree {
        padding-top: 32px;
        .tree-node .treeRoot > .nodeIcon {
            display: none;
        }
    }

    &.overflow-hide {
        overflow: hidden;
    }
}
</style>

