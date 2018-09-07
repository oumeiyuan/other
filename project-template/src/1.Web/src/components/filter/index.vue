<template>
    <div class="filter" @click.stop="emptyFn" :class="{active:isOpen===true?true:isActive}">
        <div class="filter-box">
            <ul ref="filter-box-ul">
                <slot></slot>
            </ul>

            <div class="footer">
                <el-button size="small" class="default-button" @click="cancel" v-text="$t('cancel')"></el-button>
                <el-button class="blue-button" size="small" @click="confirm" v-text="$t('determine')"></el-button>
            </div>
        </div>

        <div class="main-search-filter-tabs" ref="filter-tabs" v-show="activeList && slots.length>0">
            <ul class="active">
                <li v-for="(item,index) in slots" v-if="item.value" v-show="item.active !==false" :key="index">
                    <span v-text="showText(item,index)" :title="showText(item,index)"></span>
                    <i class="close-btn" @click="closeItem(item,index)" v-if="item.deleted !== false"></i>
                </li>
            </ul>
            <a v-show="slots.length>0" v-text="$t('cleanUp')" @click="closeAllItems"></a>
        </div>
    </div>
</template>

<script>
import item from "./filter-item.js";
export default {
    data() {
        return {
            isActive: false,
            activeList: false,
            slots: [],
            firstInit: false,
            maxHeight: 0
        };
    },
    props: {
        isInit: Boolean, //开始默认初始化tabs卡
        isOpen: Boolean //过滤区是否显示
    },
    methods: {
        emptyFn() {},
        close() {
            this.isActive = false;
        },
        open() {
            if (this.isActive === false) {
                this.isActive = true;
                //this.$el.style.right = 0 + "px";
            } else {
                this.close();
            }
        },
        closeAllItems() {
            this.deleteItems(this.slots, true);
        },
        closeItem(item, index) {
            let items = [];
            //查找相关联项
            if (item.related) {
                let slots = this.slots;
                let relateds = item.related;
                relateds.forEach((current, currentIndex) => {
                    for (let i = 0, ii = slots.length; i < ii; i++) {
                        let slot = slots[i];
                        if (slot.prop === current) {
                            slot.deleteIndex = i;
                            items.push(slot);
                            break;
                        }
                    }
                });
            }
            item.deleteIndex = index;
            items.push(item);
            this.deleteItems(items);
        },
        deleteItems(items, isAll) {
            for (let index = items.length - 1; index > -1; index--) {
                let item = items[index];
                let val = item.defaultValue;
                if (val === undefined) {
                    val = "";
                }
                //更新调用层参数param
                this.$slots.default[item._index].componentInstance.$emit(
                    "update:param",
                    val
                );
                this.slots.splice(isAll === true ? index : item.deleteIndex, 1);
            }
            this.setTableHeight();
            this.$emit("on-confirm");
            let flag = false;
            let slots = this.slots;
            for (let i = 0, ii = slots.length; i < ii; i++) {
                if (slots[i].active === true) {
                    flag = true;
                    break;
                }
            }
            this.activeList = flag;
        },
        showText(item, index) {
            let res, label;
            if (typeof item.format === "function") {
                res = item.format.call(this.$parent, item.data, index, item);
            } else {
                res = this.dataFormat(item);
            }

            if (!res) {
                this.$set(item, "active", false);
                this.activeList = this.activeList || false;
            } else {
                this.activeList = this.activeList || true;
                label = item._lable;
                label = label ? label + "：" : "";
            }

            return label + res;
        },
        dataFormat(item) {
            switch (item.type) {
                case "date":
                    return this.$dateFormat("yyyy-MM-dd", item.value);
                case "datetime":
                    return this.$dateFormat("yyyy-MM-dd hh:mm:ss", item.value);
                case "dateRange":
                    let val = item.value;
                    if (!val || val.length === 0) {
                        break;
                    }

                    var start = this.$dateFormat("yyyy-MM-dd", val[0]);
                    var end = this.$dateFormat("yyyy-MM-dd", val[1]);
                    return start + "-" + end;
                case "object":
                    if (!item.data) {
                        break;
                    }

                    let obj;
                    if (Array.isArray(item.data)) {
                        obj = item.data[0];
                    } else {
                        obj = item.data;
                    }

                    if (item.props.label) {
                        return obj[item.props.label];
                    }

                    return obj[item.value];
                case "list":
                    if (!item.data || !item.props) {
                        break;
                    }

                    let value = item.props.value;
                    for (let i = 0, ii = item.data.length; i < ii; i++) {
                        let obj = item.data[i];
                        if (value) {
                            if (obj[value] === item.value) {
                                return obj[item.props.label];
                            }
                        } else {
                            if (i === item.value) {
                                return obj;
                            }
                        }
                    }
            }

            return item.value;
        },
        cancel() {
            this.$emit("on-cancel");
            this.close();
        },
        confirm() {
            this.initTabs();
            this.$emit("on-confirm");
            this.close();
            this.setTableHeight();
        },
        setTableHeight() {
            this.$nextTick(() => {
                var parent = this.$parent;
                let parentNode = parent.$el;
                let el = parentNode.querySelector(".main-search-filter");
                let maxHeight = el.clientHeight;
                let height = this.maxHeight - maxHeight;
                this.maxHeight = maxHeight;
                parent.maxBodyHeight = parent.maxBodyHeight + height;
            });
        },
        initTabs() {
            let slots = this.$slots.default;
            if (!slots || slots.length === 0) {
                return;
            }

            let data = [];

            let liArrs = [];
            //从过滤区获取label标签名称
            let lis = this.$refs["filter-box-ul"].querySelectorAll("li");
            for (let i = 0, ii = lis.length; i < ii; i++) {
                liArrs.push(lis[i].firstChild.innerText);
            }

            //获取过滤区里面的参数
            slots.forEach((slot, index) => {
                if (!slot.tag || !slot.data) {
                    return;
                }
                //参数集合
                let propsData = slot.componentOptions.propsData;
                let child;
                let obj = {
                    _index: index,
                    _lable: liArrs.shift(),
                    value: propsData.param,
                    props: propsData.props,
                    type: propsData.type,
                    prop: propsData.prop,
                    data: propsData.data,
                    deleted: propsData.deleted,
                    related: propsData.related,
                    defaultValue: propsData.defaultValue,
                    format: propsData.format
                };
                data.push(obj);

                this.slots = data;
            });

            if (this.firstInit === true) {
                return;
            }

            this.firstInit = true;
            let parentNode = this.$parent.$el;
            let el = parentNode.querySelector(".main-search-filter");
            if (el) {
                el.appendChild(this.$refs["filter-tabs"]);
            } else {
                let table = parentNode.querySelector(".main-table");
                if (!table) {
                    return;
                }
                //创建容器节点
                let div = document.createElement("div");
                div.className = "main-search-filter";
                //在表格前插入容器节点，再在容器节点添加列表
                parentNode.insertBefore(div, table);
                div.appendChild(this.$refs["filter-tabs"]);
            }
            this.setTableHeight();
        }
    },
    mounted() {
        if (this.isInit === true) {
            this.initTabs();
        }

        this.$nextTick(function() {
            var filterBtn = this.$parent.$el.querySelector(
                ".func-btns>.icon-filter"
            );
            if (filterBtn) {
                var _this = this;
                filterBtn.addEventListener(
                    "click",
                    function(e) {
                        e.stopPropagation();
                        _this.open();
                    },
                    false
                );
                filterBtn = null;

                document.addEventListener(
                    "click",
                    function(e) {
                        if (_this.isActive === true) {
                            _this.close();
                        }
                    },
                    false
                );
            }
        });
    },
    watch: {
        isInit(val) {
            if (val === true) {
                this.initTabs();
            }
        }
    }
};

Vue.component("filter-item", item);
</script>

<style lang="less">
@import url(~@/static/css/sapi-global);
@import url(~@/static/css/sapi-filter);
</style>