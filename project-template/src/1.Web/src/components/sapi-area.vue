<template>
	<div class="sapi-area" :class="{'readonly':readonly===''||readonly===true}">
		<div @click.stop="handleClick" class="sapi-area-input" :class="{'delete-icon':clearIconFlag}">
			<i class="el-icon-arrow-down sapi-area-icon" :class="{'active':visible}"></i>
			<i class="icon-closer sapi-area-icon" @click.stop="clear"></i>
			<el-input readonly :placeholder="placeholderText" :value="inputText"></el-input>
		</div>
		<div class="sapi-area-box" ref="area-box" :class="{active:visible}" @click.stop="close()" @mousewheel="mousewheel($event)" v-if="!(readonly===''||readonly===true)">
			<div class="sapi-area-box-wrap" @click.stop="" :style="{left:sLeft,top:sTop,width:width}" :class="{'is-province':type==='province','is-city':type==='city'}">
				<div class="sapi-area-box-list" :class="{'is-up-arrow':upArrow===false}">
					<i v-if="upArrow" class="up-arrow"></i>
					<ul class="sapi-area-tab">
						<li :class="{active:tabIndex[0]===true}" @click="tapClick(0)">省份</li>
						<li :class="{active:tabIndex[1]===true,'cursor-default':!currentNode.province || citys.length===0}" @click="tapClick(1)">城市</li>
						<li :class="{active:tabIndex[2]===true,'cursor-default':!currentNode.city || areas.length===0}" @click="tapClick(2)">县区</li>
					</ul>
					<div class="sapi-area-content">
						<component ref="provinces" :style="{'max-height':maxHeight,height:upArrow===false?maxHeight:''}" :resizeable="false" :is="currentView" class="provinces-box" v-show="tabIndex[0]===true">
							<dl>
								<template v-for="(item,index) in provinces">
									<dt v-text="item.label"></dt>
									<dd>
										<span class="sapi-area-label" :class="{active:data.__active}" @click="provincesClick(data,index,i)" v-for="(data,i) in item.provinces" v-text="data.AliasName"></span>
									</dd>
								</template>
							</dl>
						</component>
						<component ref="citys" :style="{'max-height':maxHeight,height:upArrow===false?maxHeight:''}" :resizeable="false" :is="currentView" class="area-box" v-show="tabIndex[1]===true">
							<span class="sapi-area-label" :class="{active:data.__active}" @click="citysClick(data,index)" v-for="(data,index) in citys" v-text="data.AliasName"></span>
						</component>
						<component ref="areas" :style="{'max-height':maxHeight,height:upArrow===false?maxHeight:''}" :resizeable="false" :is="currentView" class="area-box" v-show="tabIndex[2]===true">
							<span class="sapi-area-label" :class="{active:data.__active}" @click="areasClick(data,index)" v-for="(data,index) in areas" v-text="data.AliasName"></span>
						</component>
					</div>
					<i v-if="upArrow===false" class="down-arrow"></i>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	//import scrollbar from "@/components/sapi-scrollbar.vue";
	export default {
		data() {
			return {
				text:null,
				datas: [],
				provinces: [],
				citys: [],
				areas: [],
				visible: false,
				tabIndex: {

				},
				currentNode: {
					province: null,
					city: null,
					area: null
				},

				nodeId: null,
				changeFlag: false, //是否有选择
				label: "label",
				val: "value",
				disable: "",
				emitInput: false, //是否是$emit引起的修改
				data: [],
				currentView: null,
				sLeft: 0,
				sTop: 0,
				maxHeight: 0,
				upArrow: true //是否向下展示列表
			}
		},
		props: {
			value: Object,
			readonly: [Boolean , String], //只读
			placeholder: { //空白提示
				type: String,
				default: "请选择省市区"
			},
			clearable: [Boolean, String], //是否显示删除按钮
			width: String,
			left: Number,
			top: Number,
			type: String, //province，city，area
			format: Function
		},
		components: {
			"sapi-scrollbar": () =>
				import("@/components/sapi-scrollbar.vue")
		},
		computed: {
			clearIconFlag() {
				if(!this.inputText) {
					return false;
				}

				if((this.clearable === "" || this.clearable === true) && this.visible === false) {
					return true;
				}

				return false;
			},
			placeholderText() {
				if(this.readonly === '' || this.readonly === true) {
					return "";
				}

				return this.placeholder;
			},
			inputText(){
				if(this.format) {
					return this.format(this.currentNode);
				}

				if(!this.currentNode.province) {
					return "";
				}

				let input = this.currentNode.province.Name;

				if(this.currentNode.city && input.indexOf(this.currentNode.city.AliasName) < 0) {
					input += "/" + this.currentNode.city.Name;
				}

				if(this.currentNode.area && input.indexOf(this.currentNode.area.AliasName) < 0) {
					input += "/" + this.currentNode.area.Name;
				}

				return input;
			}
		},
		methods: {
			close(flag) {
				this.visible = false;
				
				if(this.changeFlag === true) {
					let currentNode = this.currentNode;
					this.emitInput = flag === undefined ? true : flag;
					this.$emit("input", {
						provinceId: currentNode.province ? currentNode.province.Id : null,
						provinceName: currentNode.province ? currentNode.province.Name : null,
						cityId: currentNode.city ? currentNode.city.Id : null,
						cityName: currentNode.city ? currentNode.city.Name : null,
						areaId: currentNode.area ? currentNode.area.Id : null,
						areaName: currentNode.area ? currentNode.area.Name : null
					});
					this.$emit("change", currentNode);
				}
			},
			clear() {
				this.currentNode.province.__active = false;
				this.currentNode = {
					province: null,
					city: null,
					area: null
				}
				this.changeFlag = true;
				this.close(false);
			},
			tapClick(index) {
				switch(index) {
					case 0:
						//数据清空时返回原位
						if(!this.currentNode.province) {
							this.$refs.provinces.scrollToY(0);
						}

						break;
					case 1:
						if(!this.currentNode.province || this.citys.length === 0) {
							return;
						}

						//数据清空时返回原位
						if(!this.currentNode.city) {
							this.$refs.citys.scrollToY(0);
						}

						break;
					default:
						if(!this.currentNode.city || this.areas.length === 0) {
							return;
						}

						//数据清空时返回原位
						if(!this.currentNode.area) {
							this.$refs.areas.scrollToY(0);
						}

				}

				let tabIndex = this.tabIndex;
				for(let key in tabIndex) {
					tabIndex[key] = false;
				}

				tabIndex[index] = true;
			},
			handleClick(e) {
				if(this.readonly === '' || this.readonly === true) {
					return;
				}

				document.body.appendChild(this.$refs["area-box"]);

				if(this.currentView === null) {
					this.currentView = "sapi-scrollbar";
				}

				this.emitInput = false;
				//this.changeFlag = false;
				this.visible = true; //显示省市区

				let x = e.clientX - e.offsetX; //input节点的左边界线
				let y = e.clientY - e.offsetY; //input节点的上边界线

				let target = e.target;
				let parentNode;

				let className = target.className;
				if(className.indexOf("sapi-area-input") > -1) {
					parentNode = target;
				} else {
					parentNode = target.parentNode;
					//假如当前节点不是input节点，是图标节点
					if(className.indexOf("sapi-area-icon") > -1) {
						x -= target.offsetLeft;
						y -= target.offsetTop;
					}
				}

				let sTop = y + parentNode.clientHeight; //input 点下边界线
				//let dialog = document.querySelector(".dialog.current-dialog>.dialog-box");
				let maxHeight;
				this.upArrow = true;
				let top = 0;
				let subHeight = 71; //36(tab)+30(margin)+5(预留空间)
				let clientHeight = document.body.clientHeight;
				maxHeight = clientHeight - y - parentNode.clientHeight - subHeight

				//对列表的位置进行自动调整
				if(maxHeight < 200) {
					subHeight = 81; //36(tab)+30(margin)+5(预留空间)+10(箭头位置)
					let _maxHeight = y - top - subHeight;
					if(maxHeight < _maxHeight) {
						this.upArrow = false;
						maxHeight = _maxHeight > 295 ? 295 : _maxHeight;
						sTop = y - maxHeight - subHeight;
					}
				}

				this.maxHeight = maxHeight + "px";

				this.sTop = sTop + (this.top || 0) + "px";
				this.sLeft = x + (this.left || 0) + "px";
			},
			provincesClick(data, charIndex, i) {
				//设置选中样式
				if(data.__active !== undefined) {
					if(data.__active === true) {
						return;
					}
					data.__active = true;
				} else {
					this.$set(data, "__active", true);
				}

				this.provinces.forEach((item, j) => {
					if(!item.provinces && item.provinces.length === 0) {
						return;
					}
					item.provinces.forEach((v, k) => {
						if(j === charIndex && k === i) {
							return;
						}
						if(v.__active === undefined) {
							this.$set(v, "__active", false);
							return;
						}

						v.__active = false;
					});

				});

				this.changeFlag = true;
				this.currentNode.province = data;
				this.currentNode.city = null;
				this.currentNode.area = null;
				//若只需要省份时，直接返回
				if(this.type === "province") {
					this.close();
					return;
				}
				//触发获取城市数据
				this.getCitys(data, (res) => {
					if(!res||res.length===0){
						this.close();
						return;
					}
					
					res.forEach(item => {
						if(item.__active === undefined) {
							this.$set(item, "__active", false);
							return;
						}
						item.__active = false;
					});
					if(res.length === 1) {
						this.citysClick(res[0], 0);
					}

					this.tapClick(1);
				});
			},
			citysClick(data, index) {
				if(data.__active === true || !data) {
					return;
				}

				this.citys.forEach((item, i) => {
					if(item.__active === undefined) {
						this.$set(item, "__active", false);
						return;
					}

					item.__active = false;
				});
				data.__active = true;
				this.changeFlag = true;
				this.currentNode.city = data;
				this.currentNode.area = null;

				if(this.type === "city") {
					this.close();
					return;
				}

				//触发获取城市数据
				this.getAreas(data, (res) => {
					if(!res||res.length===0){
						this.close();
						return;
					}
					res.forEach(item => {
						if(item.__active === undefined) {
							this.$set(item, "__active", false);
							return;
						}
						item.__active = false;
					});

					this.tapClick(2);
				});
			},
			areasClick(data, index) {
				if(data.__active === true || !data) {
					return;
				}

				this.areas.forEach((item, i) => {
					if(item.__active === undefined) {
						this.$set(item, "__active", false);
						return;
					}

					item.__active = false;
				});
				data.__active = true;
				this.changeFlag = true;
				this.currentNode.area = data;
				this.close();
			},
			//根据数目，及分隔符，获取首字母数据
			getFirstChar: function(rowCount, seperate) {
				if(rowCount == 0) {
					return [];
				}
				var arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
				var result = [];
				var label = "";
				var charValue = [];
				if(rowCount == 1) {
					for(var i = 0; i < arr.length; i++) {
						var current = {
							label: arr[i],
							charValue: [arr[i]]
						};
						result.push(current);
					}
					return result;
				}

				for(var i = 0; i < arr.length; i++) {
					charValue.push(arr[i]);
					if((i + 1) % rowCount == 0 || i == arr.length - 1) {
						label = charValue[0] + seperate + (i == arr.length - 1 ? 'Z' : charValue[rowCount - 1]);
						result.push({
							label,
							charValue
						});
						label = "";
						charValue = [];

					}
				}
				return result;
			},
			//省份
			getProvinces: function() {
				this.$get("/api/plat/areas/provinces", {}, function(datas) {
					this.datas = datas;
					let res = this.datas;
					let provinces = [];

					var chars = this.getFirstChar(7, '-');

					for(var i = 0; i < chars.length; i++) {
						var current = {};
						current.label = chars[i].label;
						current.provinces = [];
						let charValue=chars[i].charValue;

						for(var j = 0; j < charValue.length; j++) {
							for(var k = 0; k < res.length; k++) {
								if(res[k].FirstChar === charValue[j]) {
									current.provinces.push(res[k]);
								}
							}
						}
						if(current.provinces.length > 0) {
							provinces.push(current);
						}
					}
					this.provinces = provinces;
					this.init();
				});
			},
			//城市
			getCitys: function(data, callback) {

				//判断是否已经加载了数据，有则直接从provinces取
				if(data.children && data.children.length > 0) {
					this.citys = [].concat(data.children);
					if(typeof callback === "function") {
						callback(this.citys);
					}
				} else {
					this.$get("/api/plat/areas/" + data.Id + "/citys", function(res) {
						this.citys = res;
						if(res.length === 0) {
							callback(res);
							return;
						}
						this.$set(data, "children", [].concat(this.citys));
						if(typeof callback === "function") {
							callback(this.citys);
						}
					});
				}
			},
			//区域
			getAreas: function(data, callback) {
				//判断是否已经加载了数据，有则直接从provinces取
				if(data.children && data.children.length > 0) {
					this.areas = [].concat(data.children);
					if(typeof callback === "function") {
						callback(this.areas);
					}
				} else {
					this.$get("/api/plat/areas/" + data.Id + "/areas", function(res) {
						this.areas = res;
						this.$set(data, "children", [].concat(this.areas));
						if(typeof callback === "function") {
							callback(res);
						}
					});
				}
			},
			init() {
				//还原第一个tab选项卡
				let tabIndex = this.tabIndex;
				if(this.tabIndex[0] !== true) {
					for(let key in tabIndex) {
						tabIndex[key] = false;
					}

					tabIndex[0] = true;
				}
				
				//还原省份选中问题
				if(this.currentNode.province){
					this.currentNode.province.__active=false;
				}
				
				//还原市区选中问题
				if(this.currentNode.city){
					this.currentNode.city.__active=false;
				}
				
				//还原县城选中问题
				if(this.currentNode.area){
					this.currentNode.area.__active=false;
				}

				if(this.$typeof(this.value) !== "object" || this.datas.length === 0 || !this.value.provinceId) {
					this.currentNode.province = null;
					this.currentNode.city = null;
					this.currentNode.area = null;
					this.$refs.provinces && this.$refs.provinces.scrollToY(0);
					return;
				}

				//省份初始化
				let provinceId = this.value.provinceId;
				let datas = this.datas;
				let data;
				for(let i = 0, ii = datas.length; i < ii; i++) {
					if(datas[i].Id === provinceId) {
						data = datas[i];
						this.$set(data, "__active", true);
						this.currentNode.province = data;
						break;
					}
				}

				//城市初始化
				let cityId = this.value.cityId;
				if(!cityId || !data || this.type === "province") {
					this.currentNode.city = null;
					this.currentNode.area = null;
					return;
				}

				const _this = this; //使用这个的目的，调试。。。
				this.getCitys(data, () => {
					let res = _this.citys;
					if(!res||res.length===0){
						return;
					}
					let flag = false;
					for(let i = 0, ii = res.length; i < ii; i++) {
						if(res[i].Id === cityId) {
							_this.currentNode.city = res[i];
							_this.$set(_this.currentNode.city, "__active", true);
							flag = true;
							break;
						}
					}

					let areaId = _this.value.areaId;
					if(!areaId || flag === false || this.type === "city") {
						_this.currentNode.area = null;
						return;
					}

					_this.getAreas(_this.currentNode.city, () => {
						let res = _this.areas;
						for(let j = 0, jj = res.length; j < jj; j++) {
							if(res[j].Id === areaId) {
								_this.currentNode.area = res[j];
								_this.$set(_this.currentNode.area, "__active", true);
								break;
							}
						}
					});
				});
			},
			mousewheel(e) {
				e.preventDefault();
			}
		},
		created() {
			for(let i = 0; i < 3; i++) {
				this.$set(this.tabIndex, i.toString(), false);
			}
			this.tabIndex[0] = true;
			this.getProvinces();
		},
		watch: {
			value: {
				handler(val) {
					if(this.emitInput===true){
						this.emitInput=false;
						return;
					}　　　　　　　　　　　　
					this.init();　　　　　　　　　　
				},
				deep: true
			}
		},
		beforeDestroy() {
			this.$refs["area-box"].outerHTML = "";
		}
	}
</script>

<style lang="less">
	@border-color: #e4e4e4;
	@background-color: #fff;
	@active-color: #20a0ff;
	@bg-f2: #f2f2f2;
	.sapi-area {
		.sapi-area-input {
			position: relative;
			
			.el-icon-arrow-down {
				transition: all 0.3s;
			}
			.el-icon-arrow-down.active {
				transform: rotate(180deg);
			}
			&.delete-icon:hover {
				.icon-closer {
					display: inline-block;
				}
				.el-icon-arrow-down {
					display: none;
				}
			}
			input{
				padding-right: 26px;
			}
		}
		&.readonly {
			.sapi-area-icon {
				display: none;
			}
		}
		.sapi-area-icon {
			position: absolute;
			right: 10px;
			top: 8px;
			width: 13px;
			height: 13px;
			line-height: 13px;
			cursor: pointer;
			&.icon-closer {
				display: none;
			}
		}
	}
	
	.sapi-area-box {
		position: absolute;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		z-index: 125;
		display: none;
		&.active {
			display: block;
		}
		.sapi-area-box-wrap {
			position: relative;
			z-index: 129;
			width: 284px;
		}
		.sapi-area-box-list {
			position: absolute;
			left: 0;
			top: 10px;
			width: 100%;
			min-height: 100px;
			background-color: @background-color;
			border-radius: 3px;
			-webkit-box-shadow: 0px 0px 6px #ccc;
			-moz-box-shadow: 0px 0px 6px #ccc;
			-ms-box-shadow: 0px 0px 6px #ccc;
			box-shadow: 0px 0px 6px #ccc;
			&.is-up-arrow {
				top: 0
			}
		}
		.sapi-area-tab {
			position: relative;
			z-index: 2;
			width: 100%;
			height: 36px;
			line-height: 36px;
			text-align: center;
			border-radius: 3px;
			overflow: hidden;
			&>li {
				float: left;
				width: 33.333%;
				background-color: @bg-f2;
				cursor: pointer;
				&.active {
					background-color: @background-color;
					color: @active-color;
					font-weight: bold;
				}
				&:nth-of-type(2) {
					border-right: 1px solid @border-color;
					border-left: 1px solid @border-color;
				}
				&.cursor-default {
					cursor: default;
				}
			}
		}
		.sapi-area-content {
			height: 100%;
			margin-top: 15px;
			margin-bottom: 15px;
		}
		dl,
		dd,
		dt {
			margin: 0;
			padding: 0;
		}
		.provinces-box {
			padding: 0px 20px;
			dl {
				overflow: hidden;
			}
			dd,
			dt {
				float: left;
			}
			dt {
				clear: left;
				width: 37px;
				line-height: 30px;
				color: #888888;
			}
			dd {
				width: calc(100% - 40px);
			}
			dt+dd {
				margin-top: 5px;
			}
		}
		.sapi-area-label {
			display: inline-block;
			padding: 0px 8px;
			line-height: 21px;
			&:hover {
				cursor: pointer;
				background-color: #eef7ff;
				color: @active-color;
			}
			&.active {
				color: #fff;
				background-color: @active-color;
			}
		}
		.area-box {
			padding: 0px 22px;
			.sapi-area-label {
				margin-bottom: 5px;
			}
		}
		.is-province {
			.sapi-area-tab li {
				display: none;
				&:first-child {
					display: block;
					cursor: default;
				}
			}
			ul {
				background: @bg-f2;
			}
		}
		.is-city {
			.sapi-area-tab li:last-child {
				display: none;
			}
			ul {
				background: @bg-f2;
			}
		}
	}
	
	.up-arrow,
	.down-arrow {
		position: absolute;
		left: 23px;
		display: block;
		width: 0;
		height: 0;
		border: 8px;
		border-color: transparent;
		border-style: solid;
		&:after {
			position: absolute;
			display: block;
			width: 0;
			height: 0;
			margin-left: -8px;
			content: " ";
			border: 8px;
			border-color: transparent;
			border-style: solid;
		}
	}
	
	.up-arrow {
		top: -8px;
		border-top-width: 0;
		border-bottom-color: rgba(225, 225, 225, 0.7);
		&:after {
			top: 1px;
			border-bottom-color: #fff;
			border-top-width: 0;
		}
	}
	
	.down-arrow {
		bottom: -8px;
		border-bottom-width: 0;
		border-top-color: rgba(225, 225, 225, 0.7);
		&:after {
			bottom: 1px;
			border-top-color: #fff;
			border-bottom-width: 0;
		}
	}
</style>