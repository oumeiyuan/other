<template>
    <sapi-dialog top="12%" width="1000px" ref="dialog" class="sapi-select-dialog" v-model="visible" @on-close="close" @on-open="open" :has-max="false">
        <span slot="title" v-text="title"></span>

        <div slot="todo" class="select-user-search" @click="topSpread">
            <input class="select-user-search-input" readonly="readonly" />
            <i class="icon-search select-user-search-icon"></i>
        </div>

        <div class="select-user-box">
            <ul>
                <li class="left">
                    <div class="tabs-list">
                        <span :class="{active:tabIndexs[0]}" @click="tabClick(0)">企业架构</span>
                        <!-- <span :class="{active:tabIndexs[1]}" @click="tabClick(1)">最近联系</span> -->
                        <span :class="{active:tabIndexs[1]}" @click="tabClick(1)">其他人员</span>
                    </div>
                    <stru-tree v-show="tabIndexs[0]===true" @on-click="treeNodeClick" :multiple="multiple" :load-tree-after="loadTableData" :is-fresh="loadTree" :props="listProp" :active-id="nodeId" :active-fn="activeNode" :loadStruData="loadCurrentStruData"></stru-tree>
                    <div class="tabs-contents list user-contact" :class="{'more-data':otherTableCount > otherTableData.length && otherTableData.length > 0}" v-show="tabIndexs[1]===true">
                        <ul>
                            <li :key="index" v-for="(item,index) in otherTableData" @click="itemClick(item, index, 1)">
                                <img :src="shwoImage(item)" width="30" height="30" />
                                <div class="list-text">
                                    <p v-text="showOtherUserText(item)" :title="showOtherUserText(item)"></p>
                                    <p></p>
                                </div>
                            </li>
                        </ul>
                        <div class="list-more">
                            <a href="javascript:void(0)" @click="moreOther">加载更多</a>
                        </div>
                    </div>

                </li>
                <li class="middle">
                    <div class="map">
                        <p class="map-text" v-text="defaultParams.struName"></p>
                        <span class="btn-handle" v-if="multiple===true && tableData.length>0" @click="selectAll">全选</span>
                    </div>
                    <div class="list middle-list" :class="{'more-data':tableDataCount>tableData.length && tableData.length > 0}">
                        <ul v-show="tableData.length>0">
                            <li :key="index" v-for="(item,index) in tableData" @click="itemClick(item, index)">
                                <img :src="shwoImage(item)" width="30" height="30" />
                                <div class="list-text">
                                    <p v-text="showText(item)" :title="showText(item)"></p>
                                    <p v-text="showContent(item)" :title="showContent(item)"></p>
                                </div>
                                <div class="list-checkbox" @click.stop="emptyFn">
                                    <el-checkbox v-if="multiple===true" v-model="item.__checked" @change="itemClick(item)"></el-checkbox>
                                </div>
                            </li>
                        </ul>
                        <div v-show="tableData.length === 0" class="list-nodata" @click.stop="emptyFn">暂无数据</div>
                        <div class="list-more" @click="moreData">
                            <a href="javascript:void(0)">加载更多</a>
                        </div>
                    </div>

                </li>
                <li class="right">
                    <div class="map">
                        <p class="map-text">本次已选择的用户数：{{selectData.length}}个</p>
                        <span class="btn-handle" v-if="multiple===true && selectData.length>0" @click="clearAll">清空</span>
                    </div>
                    <div class="list right-list">
                        <ul v-if="selectData.length>0">
                            <li :key="index" v-for="(item, index) in selectData">
                                <img :src=shwoImage(item) width="30" height="30" />
                                <div class="list-text">
                                    <p v-text="showText(item)" :title="showText(item)"></p>
                                    <p v-text="showContent(item)" :title="showContent(item)"></p>
                                </div>
                                <div class="list-checkbox">
                                    <i class="el-icon-circle-close" @click="cancelSelect(item)"></i>

                                </div>
                            </li>
                        </ul>
                        <div v-else class="list-nodata" @click.stop="emptyFn">暂无数据</div>
                    </div>
                </li>
            </ul>
            <div class="clearfix" style="height:0"></div>
        </div>

        <div class="footer">
            <el-button size="small" class="default-button" @click="close">取消</el-button>
            <el-button class="blue-button" size="small" :disabled="disabled" @click="submit">提交</el-button>
        </div>

        <div class="top-search" slot="dialogBox" :class="{active:topSearch}" @click="topSearchClose(true)">
            <div class="top-search-box">
                <div class="top-search-header" @click.stop="emptyFn">
                    <input class="select-user-search-input" :maxlength="40" placeholder="按用户实名、用户帐号进行搜索" @keydown.enter="searchTableData" ref="topInput" v-model="topSearchParam.keyword" />
                    <i class="el-icon-circle-close" @click.stop="topSearchClose"></i>
                </div>
                <div class="top-search-content">
                    <div class="map">
                        <p class="map-text" v-text="topMapText"></p>
                        <span class="btn-handle" v-if="topMapText==='搜索历史' && historyData.length>0" @click.stop="saveHistory(historyData,false)">清空</span>
                    </div>
                    <div class="list">
                        <ul v-if="topTableData.length">
                            <li :key="item.StruId" v-for="(item,index) in topTableData" @click.stop="itemClick(item, index, 2)">
                                <img :src="shwoImage(item)" width="30" height="30" />
                                <div class="list-text">
                                    <p v-html="topSearchText(item)" :title="showText(item)"></p>
                                    <p v-text="showContent(item)" :title="showContent(item)"></p>
                                </div>
                                <div class="list-checkbox" v-if="topMapText==='搜索历史'">
                                    <i class="el-icon-circle-close" @click.stop="saveHistory(item,false)"></i>
                                </div>
                            </li>
                        </ul>
                        <div v-else class="list-nodata" @click.stop="emptyFn">暂无数据</div>
                    </div>
                </div>
            </div>

        </div>
    </sapi-dialog>
</template>

<script>
import dialog from "../sapi-dialog.vue";
import struTree from "./stru-tree.vue";
export default {
    data() {
        return {
            visible: false,
            disabled: false,
            searchActive: false,
            defaultImage: require("../../static/images/photo-default.png"),

            nodeId: null,
            treeData: [],

            defaultParams: {
                struId: null,
                struName: null,
                struType: null,
                pageSize: 20,
                pageIndex: 1,
                hasChildren: true
            },
            otherParams: {
                pageSize: 20,
                pageIndex: 1
            },
            topSearchParam: {
                keyword: null,
                pageSize: 20,
                pageIndex: 1
            },
            tabIndexs: {
                0: true,
                1: false
            },
            tableData: [],
            tableDataCount: 0,
            otherTableData: [],
            otherTableCount: 0,
            selectData: [],
            selectIds: {},
            isSearch: false,
            filterText: null,
            filterReg: null,
            treeSearchData: [],
            timeout: null,
            loadTree: false,
            listProp: {
                //定义用户选择页用户信息的展示格式
                title: "AliasName", //标题默认字段
                content: "CorpName", //内容默认字段
                img: "HeadIconPath",
                id: "UserId", //主键Id
                titleFn(item) {
                    //标题格式
                    return (
                        item.AliasName +
                        (item.StationName ? "（" + item.StationName + "）" : "")
                    );
                },
                contentFn(item) {
                    //内容格式
                    if (!item.CorpName && !item.DeptName) {
                        return "未分配公司";
                    }
                    return item.CorpName + "/" + item.DeptName;
                }
            },
            topTableData: [],
            topSearch: false,
            topMapText: "搜索历史",
            historyData: [],
            clickType: null
        };
    },
    props: {
        value: Boolean,
        title: {
            type: String,
            default: "选择用户"
        },
        props: Object,
        multiple: Boolean,
        data: Array | Object,
        cookieName: String, //缓存名称
        hasImg: Boolean //是否展示图片
    },
    components: {
        "sapi-dialog": dialog,
        "stru-tree": struTree
    },
    methods: {
        emptyFn() {},
        close() {
            this.loadTree = false;
            this.$emit("input", false);
        },
        open() {
            this.tabIndexs = {
                0: true,
                1: false
            };
            this.selectData = [];
            this.selectIds = {};
            //初始化已选岗位
            if (this.data) {
                let key = this.listProp.id;
                let datas = [].concat(this.data);
                datas.forEach(item => {
                    item.__checked = true;
                    this.selectIds[item[key]] = true;
                });
                this.selectData = datas;
            }
            this.tableData = [];
            this.treeData = [];
            this.defaultParams.pageIndex = 1;
            this.defaultParams.struName = null;
            this.defaultParams.struId = null;

            this.nodeId = null;
            this.loadTree = true;
            this.otherTableData = [];
            this.otherParams = {
                pageSize: 20,
                pageIndex: 1
            };
            //this.loadTreeData();
        },
        submit() {
            if (this.selectData.length === 0) {
                Vue.msg("请最少选取一项！");
                return;
            }

            var selectedData;
            if (this.multiple === true) {
                this.$emit("update:data", this.selectData);
                selectedData = this.selectData;
            } else {
                this.$emit("update:data", this.selectData[0]);
                selectedData = this.selectData[0];
            }

            this.$emit("callback", selectedData);

            this.close();
            this.saveHistory(this.selectData, true);
        },
        //清空选中
        clearAll() {
            if (this.selectData.length === 0) {
                return;
            }

            let key = this.listProp.id;
            let tableData = this.tableData;
            this.selectData.forEach(item => {
                this.selectIds[item[key]] = null;
                let data = tableData.find(row => {
                    return row[key] === item[key];
                });
                if (data) {
                    data.__checked = false;
                }
                item.__checked = false;
            });
            this.selectData = [];
        },
        //删除选中
        cancelSelect(item) {
            let key = this.listProp.id;
            let id = item[key];
            let datas = this.selectData;
            this.selectIds[id] = null;
            item.__checked = false;
            for (let i = 0, ii = datas.length; i < ii; i++) {
                if (datas[i][key] === id) {
                    let data = this.tableData.find(row => {
                        return row[key] === item[key];
                    });
                    if (data) {
                        data.__checked = false;
                    }
                    datas.splice(i, 1);
                    return;
                }
            }
        },
        //全选
        selectAll() {
            let selectIds = this.selectIds;
            let key = this.listProp.id;
            let datas = this.selectData;
            this.tableData.forEach(item => {
                item.__checked = true;
                let id = item[key];
                if (selectIds[id] === true) {
                    return;
                }
                selectIds[id] = true;
                datas.push(item);
            });
        },
        topChecked(item, index) {
            if (this.multiple === true) {
                this.change(item);
                return;
            }
            item.__checked = true;
            this.radioChange(item, index);
        },
        topSearchText(item) {
            let text = this.showText(item);
            if (this.topMapText === "搜索历史") {
                return text;
            }

            //let text = item.StationNo + " " + (item.EmployeeName || "") + " " + (item.PositionName || "");
            return text.replace(this.filterReg, function(arg) {
                return "<font class='key-font'>" + arg + "</font>";
            });
        },
        itemClick(item, index, type) {
            let key = this.listProp.id;
            if (type) {
                this.defaultParams.struName = null;
                if (this.clickType !== type) {
                    this.tableData = [];
                    this.clickType = type;
                } else {
                    let filterData = this.tableData.find(data => {
                        return data[key] === item[key];
                    });

                    if (filterData) {
                        item.__checked = true;
                        return;
                    }
                    this.tableData = [];
                }
                this.tableData.push(item);
                //锁定选中
                item.__checked = true;
                this.tableDataCount = 1;
            } else {
                this.clickType = null;
                if (index !== undefined) {
                    item.__checked = !item.__checked;
                }
            }

            let id = item[key];
            if (this.multiple !== true) {
                let data = this.selectData[0];
                if (data && data[key] !== id) {
                    data.__checked = false;
                }
                this.selectData = [item];
                return;
            }

            this.change(item);
        },
        //单个选择
        change(item) {
            let key = this.listProp.id;
            let id = item[key];

            if (item.__checked === true) {
                if (this.selectIds[id] === true) {
                    return;
                }
                this.selectData.push(item);
                this.selectIds[id] = true;
            } else {
                this.selectIds[id] = null;
                let datas = this.selectData;
                for (let i = 0, ii = datas.length; i < ii; i++) {
                    if (datas[i][key] === id) {
                        datas.splice(i, 1);
                        break;
                    }
                }
            }
        },
        shwoImage(item) {
            let path = item[this.listProp.img];
            if (path) {
                path = globalConfig.baseUrl + "/" + path;
            } else {
                path = this.defaultImage; //"../../static/images/photo-default.png"
            }

            return path;
        },
        //岗位列表标题显示格式的文本
        showText(item) {
            let fn = this.listProp.titleFn;
            if (typeof fn === "function") {
                return fn(item);
            }

            return item[this.listProp.title];
        },
        showContent(item) {
            let fn = this.listProp.contentFn;
            if (typeof fn === "function") {
                return fn(item);
            }

            return item[this.listProp.content];
        },
        //其他用户列表标题显示格式的文本
        showOtherUserText(item) {
            return item.AliasName + "（" + item.UserName + "）";
        },
        //顶部搜索展开
        topSpread() {
            this.topSearch = true;
            this.topSearchParam.keyword = null;
            this.loadHistoryData();
            this.$nextTick(function() {
                this.$refs.topInput.focus();
            });
        },
        topSearchClose(flag) {
            if (flag !== true && this.topSearchParam.keyword) {
                this.topSearchParam.keyword = "";
                this.loadHistoryData();
                return;
            }

            this.topSearchParam.keyword = null;
            this.topSearch = false;
            this.topTableData = [];
        },
        tabClick(index) {
            var indexs = this.tabIndexs;
            if (indexs[index] === true) {
                return;
            }
            switch (index) {
                case 0:
                    indexs[1] = false;
                    break;
                case 1:
                    indexs[0] = false;
            }
            indexs[index] = true;

            if (index === 1 && this.otherTableData.length === 0) {
                this.loadOtherTableData();
            }
        },
        //flag:true为保存，false为删除
        saveHistory(datas, flag) {
            let key = this.listProp.id;
            let historyData = this.historyData;
            let currentDatas = [].concat(datas);

            if (flag === false) {
                currentDatas.forEach(data => {
                    for (let i = 0, ii = historyData.length; i < ii; i++) {
                        if (data[key] === historyData[i][key]) {
                            historyData.splice(i, 1);
                            break;
                        }
                    }
                });
                this.topTableData = [].concat(historyData);
            } else {
                currentDatas.forEach(data => {
                    let isActive = false;
                    for (let i = 0, ii = historyData.length; i < ii; i++) {
                        if (data[key] === historyData[i][key]) {
                            isActive = true;
                            break;
                        }
                    }
                    if (isActive === false) {
                        //在前面添加一条数据
                        historyData.unshift(data);
                    }
                });
                //保存前二十个
                if (historyData.length > 20) {
                    historyData.slice(0, 20);
                }
            }

            localStorage[
                this.cookieName || "historyCookieStation"
            ] = JSON.stringify(historyData);
        },
        loadHistoryData() {
            this.topMapText = "搜索历史";

            this.topTableData = [].concat(this.historyData);
        },
        searchTableData() {
            if (!this.topSearchParam.keyword) {
                return;
            }

            this.topMapText = "搜索内容";

            this.$get("/api/plat/users/briefs", this.topSearchParam, function(
                res
            ) {
                this.filterReg = new RegExp(this.topSearchParam.keyword, "ig");
                let datas = res.Rows;
                datas.forEach(item => {
                    item.__checked = false;
                });
                this.topTableData = datas;
            });
        },
        //批量增加
        loadCurrentStruData(item) {
            const pageSize = this.defaultParams.pageSize;
            const pageIndex = this.defaultParams.pageIndex;
            this.defaultParams.pageSize = 0;
            this.defaultParams.pageIndex = 1;
            this.activeNode(item);
            this.tableData = [];
            this.clickType = null;
            this.loadTableData(() => {
                this.defaultParams.pageSize = pageSize;
                this.defaultParams.pageIndex = pageIndex;
                this.selectAll();
            });
        },
        moreData() {
            this.defaultParams.pageIndex += 1;
            this.loadTableData();
        },
        //获取岗位数据
        loadTableData(callback) {
            if (!this.defaultParams.struId) {
                return;
            }
            //				this.$get("/api/plat/stations/", this.defaultParams, function(res) {
            this.$get(
                "/api/plat/users/briefs/{struId}",
                this.defaultParams,
                function(res) {
                    let datas = res.Rows;
                    datas.forEach(item => {
                        //item.__checked = true;
                        this.$set(item, "__checked", false);
                        this.tableData.push(item);
                    });
                    this.tableDataCount = res.Total;
                    if (typeof callback === "function") {
                        callback();
                    }
                }
            );
        },
        moreOther() {
            this.otherParams.pageIndex += 1;
            this.loadOtherTableData();
        },
        loadOtherTableData() {
            this.$get(
                "/api/plat/users/briefs/withoutStru",
                this.otherParams,
                function(res) {
                    let datas = res.Rows;
                    let tableData = this.otherTableData;
                    datas.forEach(item => {
                        item[this.listProp.title] = item.AliasName;
                        item[this.listProp.id] = item.UserId;
                        item.__checked = false;
                        tableData.push(item);
                    });
                    this.otherTableCount = res.Total;
                }
            );
        },
        //树节点点击事件
        treeNodeClick(node) {
            this.activeNode(node);
            this.defaultParams.pageIndex = 1;
            this.tableData = [];
            this.loadTableData();
            this.clickType = null;
        },
        //当前初始化节点
        activeNode(node) {
            this.defaultParams.struId = node.StruId;
            this.defaultParams.struName = node.StruName;
            this.defaultParams.struType = node.StruType;
        }
    },
    watch: {
        value(val) {
            this.visible = val;
        }
    },
    created() {
        this.visible = this.value;
        this.$nextTick(() => {
            //获取历史数据
            let datas = localStorage[this.cookieName || "historyCookieStation"];
            this.historyData = datas ? JSON.parse(datas) : [];
            this.historyData.forEach(item => {
                item.__checked = false;
            });
        });

        let props = this.props;
        if (props && this.$typeof(props) === "object") {
            for (let key in props) {
                this.listProp[key] = props[key];
            }
        }
    }
};
</script>

<style lang="less">
@import "~@/static/css/sapi-global";
@import "~@/static/css/sapi-select-user";
</style>