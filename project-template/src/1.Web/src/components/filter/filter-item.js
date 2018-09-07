export default {
	template: "<li><slot></slot></li>",
	props: {
		param: [String, Number, Boolean, Array, Object, Date],  //绑定的参数
		props: Object,  //跟树型一样 label,value
		data: [Array, Object], //数据源
		related: Array,     //关联列表,
		deleted: {  //是否可删除
			type:Boolean,
			default:true
		},   
		prop: String,   //绑定字段
		type: String,  //数据类型 比如date,dateTime
		defaultValue: [String, Number, Boolean, Array, Object, Date],//默认字段
		format: Function,   //列表显示的格式
	}
}
