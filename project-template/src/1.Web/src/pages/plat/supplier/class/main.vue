<template>
    <div class="body-content" v-cloak>
        <div class="main-header">
			<div class="main-header-map"><span class="main-header-map-text"></span></div>
			<div class="main-header-search">
			</div>
		</div>

        <div class="body-content-box" :class="{active:hasData}">
            <div class="left-side-drag drag-element-left drag-reset"></div>
            <div class="left-side tree-wrapper">
                <!-- 树状结构 -->
                <class-tree ref="supplierClassTree" :node-id="nodeId" node-key="ClassId" :tree-data="treeData" 
                :tree-prop="supplierClassProps" @change-handle="changeHandleType" @on-click="showSupplierClass"></class-tree>
            </div>
            <div class="right-side">
                <!-- 修改、查看组件 -->
                <component v-bind:is="currentView" :option="supplierClassDetail" @viewBack="getViewBack"></component>
            </div>
        </div>

        <!--无数据页面-->
		<div class="no-data-module">
			<component v-bind:is="firstView"></component>
		</div>

        <!--添加同级、子级-->
		<component v-bind:is="addView" v-model="addVisible" :option="addOption" :isAddChild="isAddChild" :title="addTitle"></component>
    </div>
</template>

<script>
    import classTree from "@/components/sapi-tree-left-side.vue";
    import tips from "@/components/sapi-tips.js";
    import confirm from "@/components/sapi-confirm.js";
    import drag from "@/components/sapi-move-module.js";

    export default {
		data() {
			return {
                firstView:"",
                addView:"",
                addVisible:false,
                addOption:{},
                addTitle:"",
                isAddChild:false,
                treeData:[],
                supplierClassProps:{
                    children: 'ChildrenClass',
					label: 'ClassName',
					parentId: "ParentClassId",
					nodeKey: "ClassId",
					hasChild: "HasChild"
                },
                hasData:false,
                //供方分类详细信息,用于查看页
                supplierClassDetail:{
                    ClassName:"",
                    BaseClassName:"",
                    ParentClassName:"",
                    RowIndex:"",
                    Remark:""
                },
                nodeId: null,
                currentView:"",
            }
        },
        mixins: [getTabMixin()],
        components: {
			"class-add": (resolve) => {
				require(['./add.vue'], resolve);
			},
			 "class-edit": (resolve) => {
			 	require(['./edit.vue'], resolve);
			 },
			"class-view": (resolve) => {
				require(['./view.vue'], resolve);
            },
            "class-first": (resolve) => {
				require(['./first-class.vue'], resolve);
			},
			"class-tree": classTree
        },
        methods:{
            //获取左侧树状列表
            getSupplierClassTree(){
                this.$get("/api/plat/supplierClasses/tree", {}, function(res) {
                    this.treeData = res;
                    //但没有数据时，显示新增页面
                    if(!this.treeData || this.treeData.length ===0)
                    {
                        this.firstView = "class-first";
                        this.hasData = false;
                        return;
                    }
                    this.firstView = "";
                    this.hasData = true;
                    this.nodeId =this.nodeId || this.treeData[0].ClassId;
                    
					if(this.nodeId) {
                        this.getSupplierClassDetail();
                        this.currentView = "class-view";
                    }
                });
            },
            //查看明细
            getSupplierClassDetail(){
                this.$get("api/plat/supplierClasses/" + this.nodeId, {}, function(res) {
                    this.supplierClassDetail = res;
                });
            },
            //点击树状节点查看明细
            showSupplierClass(data,node)
            {
                this.nodeId = data.ClassId;
				this.getSupplierClassDetail();
				this.currentView = "class-view";
            },
            //修改页取消修改回调
            getViewBack(){
                this.currentView = "class-view";
            },
            //删除供方分类
            deleteSupplierClass(){
                this.$deleteTips(function() {
					this.$delete("/api/plat/supplierClasses/" + this.nodeId, function(res) {
                        //删除后，将父级节点赋值给noedId
                        this.nodeId = this.supplierClassDetail.ParentClassId;
						this.getSupplierClassTree();
						Vue.successMsg(this.$t('supplierClass.delSupplierClassSuccess'));
                    });
                });
            },
            //左侧树状结构可操作按钮
            changeHandleType(i)
            {
                //修改
				if(i == 0) {
					this.getSupplierClassDetail();
					this.currentView = "class-edit";
				}
				//删除
				else if(i === 3) {
					this.deleteSupplierClass();
				} else { //新增下级、同级
					this.addOption = {};
					if(i == 1) {
                        if(this.supplierClassDetail.ParentClassId) {
                            this.isAddChild = true;
                            this.addOption.ParentClassId = this.supplierClassDetail.ParentClassId;
                            this.addOption.BaseClassId=this.supplierClassDetail.BaseClassId;
                            this.addOption.BaseClassName=this.supplierClassDetail.BaseClassName;
                        }
                        else {
                            this.isAddChild = false;
                        }
                        this.addTitle = this.$t('addSiblingTitle');
					} else {
                        this.addOption.ParentClassId = this.nodeId;
                        this.addOption.BaseClassId=this.supplierClassDetail.BaseClassId;
                        this.addOption.BaseClassName=this.supplierClassDetail.BaseClassName;
                        this.isAddChild = true;
						this.addTitle = this.$t('addChildTitle');
					}
					this.addView = "class-add";
					this.addVisible = true;
				}
            }
        },
        created() {
            Vue.use(tips);
            Vue.use(confirm);
            this.$init();
			this.getSupplierClassTree();
        },
        mounted() {
			this.$nextTick(function() {
				drag.move(this, ".left-side", ".right-side", ".left-side-drag", {
					class: 2,
					offsetHeight: 102
				});
			});
		}
    }
</script>

<style>
    .body-content-box {
		display: none;
	}
	
	.body-content-box.active {
		display: block;
	}
</style>