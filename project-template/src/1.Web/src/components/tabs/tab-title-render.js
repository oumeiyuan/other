export default {
	props: {
		item: Object,   //slot 对象
		index: Number   //tab 索引
	},
	methods: {
		clickHandler() {
			this.$emit("on-click", this.item,this.index);
		}
	},
	render(h) {
		return h("span", {
			class: "tabs-title",
			on: {
				click: this.clickHandler
			},
		}, [this.item.slot]);
	}
}