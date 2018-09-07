<template>
	<div class="table-rows">
		<template v-for="(item,index) in data">
			<div class="table-row" :key="index + 'rows'">
				<div class="table-col" v-for="(col,colIndex) in cols" :key="colIndex" :class="'table-col-'+colIndex" :style="{width:col.width+'px'}">
					<column-slot v-if="col.slot" :col="col" :item="item"></column-slot>
					<div v-else-if="col.type==='selection'" class="col-cell">
						<el-checkbox v-model="item.__checked" @change="change(item)"></el-checkbox>
					</div>
					<div v-else-if="col.prop===props.expandNode" class="col-cell">
						<div class="col-cell-tree" :style="{'padding-left' : indexs.length > 0 ? (indexs.length * indent + 'px') : false}">
							<span class='col-cell-tree-icon icon-arrow-right' @click="expandHandler(item)" :class="getIconClass(item)"></span>
							<span class='col-cell-tree-label' v-text="format(item,col)"></span>
						</div>
					</div>
					<div v-else class="col-cell" @mouseleave="mouseleave(col, $event)" @mouseenter="mouseenter(col, $event)" v-text="format(item,col)">
					</div>
				</div>
			</div>

			<table-columns @on-change="selection" :lazyLoad="lazyLoad" :key="index + 'cmp'" @on-expand="onExpand(item, !item.__expandActiveFlag)" :indent="indent" :defaultExpandAll="defaultExpandAll" :data="item[props.children]" :parent-index="parentIndex ? (parentIndex + ',' + index) : index.toString()" :cols="cols" :props="props" v-show="setShow(item,true)" v-if="hasChild(item)"></table-columns>
		</template>
	</div>
</template>

<script>
// 行列渲染
import slot from "./table-column-slot.js";
export default {
    components: {
        "column-slot": slot
    },
    inject: ["tableGrid"],
    data() {
        return {
            indexs: []
        };
    },
    props: {
        cols: Array, //列的数据源
        data: Array, //数据源
        props: {
            default: function() {
                return {
                    expandNode: null,
                    children: null,
                    hasChild: null
                };
            },
            type: Object
        },
        defaultExpandAll: {
            //是否默认展开所有的
            default: false,
            type: Boolean
        },
        parentIndex: String, //父节点，使用,拼接
        indent: {
            //树节点缩进距离
            default: 16,
            type: Number
        },
        lazyLoad: Function //懒加载数据
    },
    computed: {},
    methods: {
        getIconClass(item) {
            let children = this.props.children;
            let hasChild = this.props.hasChild;
            if (!item[children] || item[children].length === 0) {
                if (item[hasChild] !== true) {
                    return "is-noChild";
                }
            }

            if (
                item.__expandActiveFlag === undefined
                    ? this.defaultExpandAll === true
                    : item.__expandActiveFlag
            ) {
                return "is-expanded";
            }

            return "";
        },
        mouseenter(col, e) {
            if (col.showTip !== true) {
                return;
            }

            const target = e.target;
            const text = target.innerText || "";
            const parent = this.tableGrid;
            parent.$showTips(text, e);
            clearTimeout(parent.timeout);
        },
        mouseleave(col, e) {
            if (col.showTip !== true) {
                return;
            }

            this.tableGrid.timeout = setTimeout(() => {
                this.tableGrid.$closeTips();
            }, 100);
        },
        selection(item, parentIndexs) {
            this.$emit("on-change", item, parentIndexs);
        },
        change(item) {
            this.$emit("on-change", item, this.indexs);
        },
        format(row, col) {
            if (typeof col.format === "function") {
                return col.format.call(this.tableGrid.$parent, row, col);
            }

            return row[col.prop];
        },
        onExpand(item, flag) {
            this.$set(item, "__expandActiveFlag", flag);
            //直接调用主组件方法，这里有可能会嵌套n多层
            this.tableGrid.expand(item, flag);
        },
        expandHandler(item) {
            let children = this.props.children;
            let hasChild = this.props.hasChild;
            if (!item[children] || item[children].length === 0) {
                if (item[hasChild] !== true) {
                    return "is-noChild";
                } else if (typeof this.lazyLoad === "function") {
                    this.loadChild(item);
                    return;
                }
            }

            this.onExpand(item, !item.__expandActiveFlag);
        },
        loadChild(item) {
            const _this = this;
            this.lazyLoad(item, function(res) {
                if (!res || res.length === 0) {
                    return;
                }
                _this.$set(item, _this.props.children, res);
                _this.onExpand(item, !item.__expandActiveFlag);
            });
        },
        hasChild(item) {
            if (item.__expandActiveFlag !== undefined) {
                return true;
            }

            let child = this.props.children;
            if (this.defaultExpandAll) {
                if (item.__expandActiveFlag === undefined) {
                    this.expand(item);
                }
                return item[child] && item[child].length > 0;
            }

            return false;

            //return item[child] && item[child].length > 0;
        },
        setShow(item) {
            let child = this.props.children;

            return (
                item.__expandActiveFlag && item[child] && item[child].length > 0
            );
        }
    },
    beforeCreate() {
        //递归使用同一个组件的注册方法
        this.$options.components.TableColumns = () =>
            import("./table-column.vue");
    },
    created() {
        if (this.parentIndex) {
            this.indexs = this.parentIndex.split(",");
        }
    }
};
</script>