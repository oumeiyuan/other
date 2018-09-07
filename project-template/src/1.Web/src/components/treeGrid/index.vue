<template>
    <div class="sapi-table" @mouseleave="closeTips">
        <table-header ref="tableHeader" @callback="initTalble" :resizable="resizable" @select-all="selectAll"></table-header>
        <div class="table-body" :class="{overHide:hasShow===false}" :style="{height:height,'max-height':maxHeight}">
            <table-columns @on-expand="expand" :cols="cols" :lazyLoad="lazyLoad" :indent="indent" :style="{width:bodyWidth+'px'}" @on-change="selection" :data="data" v-if="hasShow" :defaultExpandAll="defaultExpandAll" :props="props" parent-index=""></table-columns>
            <div class="table-body-nodata" :style="{width:tableWidth+'px'}" v-if="!hasShow">暂无数据</div>
        </div>
    </div>
</template>

<script>
import header from "./table-header.vue";
import column from "./table-column.vue";
//注册全局组件
import tableColumn from "./table-column.js";
import tips from "./table-column-tips";
export default {
    mixins: [tips],
    components: {
        "table-header": header,
        "table-columns": column
    },
    provide() {
        return {
            tableGrid: this
        };
    },
    props: {
        data: Array, //数据源
        props: {
            type: Object,
            default: function() {
                return {
                    expandNode: null, //展开节点绑定字段，选填，为空默认第一个或者第二个（第一个为checkbox选第二个）
                    children: null, //节点的子节点绑定字段，必填
                    hasChild: null // 节点是否包含子节点，选填，假如为懒加载数据为必填
                };
            }
        },
        height: {
            //表格高度
            type: String,
            default: ""
        },
        maxHeight: {
            //表格最高高度
            type: String,
            default: ""
        },
        defaultExpandAll: {
            //是否默认展开所有的
            default: false,
            type: Boolean
        },
        resizable: {
            //列大小是否可以调整大小
            default: false,
            type: Boolean
        },
        indent: {
            //树节点缩进距离
            default: 16,
            type: Number
        },
        lazyLoad: Function //懒加载数据
    },
    data() {
        return {
            cols: [],
            tableWidth: 0,
            scrollWidth: 0,
            tableHeight: null,
            bodyWidth: null,
            isInit: false,
            isInitScroll: false,
            selectAllFlag: null,
            toolTip: false,
            timeout: null //子孙类专用
        };
    },
    computed: {
        hasShow() {
            return this.isInit && this.data.length > 0;
        }
    },
    methods: {
        selectAll(flag) {
            this.selectAllFlag = flag;
        },
        selection(item, parentIndexs) {
            console.log(parentIndexs);
        },
        expand(item, flag) {
            this.$emit("on-expand", item, flag);
        },
        initScroll() {
            let elm = this.$el;

            let body = elm.querySelector(".table-body");
            const header = elm.querySelector(".table-header>table");
            let scrollLeft = 0;

            body.addEventListener(
                "scroll",
                function(e) {
                    const left = this.scrollLeft;
                    if (scrollLeft === left) {
                        return;
                    } else {
                        scrollLeft = left;
                    }

                    header.style.marginLeft = -left + "px";
                },
                false
            );

            elm = null;
            body = null;
        },
        initScrollWidth() {
            if (this.scrollWidth !== 0) {
                this.bodyWidth = this.tableWidth - this.scrollWidth;

                return;
            }

            this.$nextTick(() => {
                if (!this.$el || !this.cols || !this.data) {
                    return;
                }

                const el = this.$el;
                let body = el.querySelector(".table-body");
                const tableBody = body.querySelector(".table-rows");
                if (!tableBody) {
                    return;
                }

                if (tableBody.clientHeight > body.clientHeight) {
                    const subWidth = (this.scrollWidth =
                        el.clientWidth - body.clientWidth);
                    if (tableBody.clientWidth > body.clientWidth + subWidth) {
                        return;
                    }

                    this.bodyWidth = this.tableWidth - subWidth;
                }
            });
        },
        initTips() {
            let toolTip = false;
            for (let i = 0, ii = this.cols.length; i < ii; i++) {
                let col = this.cols[i];
                if (col.showTip === true) {
                    toolTip = true;
                    break;
                }
            }

            if (!toolTip) {
                return;
            }

            this.toolTip = true;
            this.$initTips();
        },
        closeTips() {
            if (this.toolTip === true) {
                this.$closeTips();
            }
        },
        initTalble(cols, width) {
            this.cols = cols;
            this.tableWidth = width;
            this.isInit = true;
            this.initScrollWidth();
        }
    },
    watch: {
        data(val) {
            this.initScrollWidth();
        }
    },
    mounted() {
        this.$nextTick(() => {
            this.initScroll();
            this.initTips();
        });
    }
};

Vue.component(tableColumn.name, tableColumn);
</script>

<style lang="less">
@import "~@/static/css/sapi-global";

.sapi-table {
    width: 100%;
    box-sizing: content-box;
    border: #eee solid 1px;
    .table-header {
        overflow: hidden;
    }
    .table-header > table {
        border-collapse: collapse;
        table-layout: fixed;
    }
    .table-header th {
        height: 48px;
        text-align: left;
        overflow: hidden;
        background: #f8f8f8;
    }
    .table-body {
        overflow: auto;
    }
    .table-body.overHide {
        overflow: hidden;
    }
    .col-cell-tree {
        width: 100%;
        overflow: hidden;
    }
    .col-cell-tree > span {
        display: block;
        float: left;
    }
    .col-cell-tree-icon {
        width: 14px;
        margin-top: 2px;
        margin-right: 4px;
        font-size: 20px;
        color: #999;
        cursor: pointer;
        transform: rotate(0deg);
        transition: transform 0.3s;
    }
    .col-cell-tree-icon.is-expanded {
        transform: rotate(90deg) translateX(-3px);
    }
    .col-cell-tree-icon.is-noChild {
        visibility: hidden;
        cursor: default;
    }
    .col-cell-tree-label {
        width: calc(100% - 24px);
        text-overflow: ellipsis;
        white-space: nowrap;
        overflow: hidden;
    }
    .table-rows {
        width: 100%;
        overflow: hidden;
    }
    .table-row {
        display: table;
        width: 100%;
        height: 40px;
        line-height: 40px;
        border-bottom: 1px solid #eee;
        table-layout: fixed;
        &:hover {
            background: @table-hover-color;
        }
    }
    .table-body > .table-rows > .table-row:last-child {
        border-bottom-width: 0;
    }
    .table-col {
        display: table-cell;
        vertical-align: top;
    }
    .col-cell {
        padding-left: 10px;
        padding-right: 10px;
        color: inherit;
        text-overflow: ellipsis;
        white-space: nowrap;
        overflow: hidden;
    }
    .table-body-nodata {
        width: 100%;
        min-height: 40px;
        line-height: 40px;
        text-align: center;
        overflow: hidden;
    }
}

.table-th-drag {
    position: absolute;
    left: 0;
    top: 0;
    z-index: 99;
    height: 48px;
    width: 2px;
    background: #ccc;
}

.table-th-drag:hover {
    cursor: col-resize;
}

.sapi-title-tips {
    position: fixed;
    z-index: 999;
    left: 0;
    top: 200px;
    max-width: 100%;
    padding: 8px 24px;
    line-height: 20px;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0px 0px 10px 5px rgba(0, 0, 0, 0.07);

    .text {
        display: block;
    }

    &.visibiHide {
        visibility: hidden;
        z-index: -1;
    }

    #arrow-fn();
}

</style>