export default{
	props:{
		itemSlot:Object
	},
	render(h,node){
		console.log(this.itemSlot)
		return h(this.itemSlot);
	}
}
