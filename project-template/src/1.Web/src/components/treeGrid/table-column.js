//定义一个全局组件，限制一些属性
export default {
    name: "table-column",
    template: " ",
    props: {
        showTip: Boolean, //是否显示提示文字
        type: String,  //数据类型，比如多选框，现在只有一种selection
        prop: String,  //列的字段名
        width: {
            //宽度大小
            type: Number,
            default: 0
        },   
        label: String,   //列的名称
        format: Function //自定义输出格式
    }
}