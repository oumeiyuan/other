<template>
	<table-tree :data="data" :default-expand-all="false" :resizable="false" :lazy-load="loadChild" :props="props" max-height="500px" @on-expand="expand">
		<!--<table-column prop="abcd" label="大列">
			<table-column prop="a1" label="小列" width="180"></table-column>
			<table-column prop="cdfsdf" label="小列1">
				<table-column prop="a2" width="180" label="小列小小1"></table-column>
				<table-column prop="a3" width="180" label="小列小小2"></table-column>
				<table-column prop="a4" width="180" label="小列小小3"></table-column>
				<table-column prop="a5" width="180" label="小列小小4"></table-column>
				<table-column prop="a6" width="180" label="小列小小5"></table-column>
			</table-column>
			<table-column prop="a7" width="180" label="小列2"></table-column>
			<table-column prop="a8" width="180" label="小列3"></table-column>
			<table-column prop="a9" width="180" label="小列4"></table-column>
		</table-column>-->
		<table-column prop="a0" type="selection">
		</table-column>
		<table-column prop="a10" label="大列2">
		</table-column>
		<table-column prop="a9" width="150" label="大列3">
		</table-column>
		<table-column prop="a11" :show-tip="true" width="180" label="小小小列31"></table-column>
		<table-column prop="a12" label="小小小列32"></table-column>
		<table-column prop="a13" label="大列4">
			<template slot-scope="prop">
				<div class="d4156">
					<el-input :value="prop.row.a13"></el-input>
					<!-- <div v-text="prop.row.a13+'963254566'" @click="myclick(prop)"></div> -->
				</div>
			</template>
		</table-column>
		<table-column prop="a14" label="大列5">
		</table-column>
		<table-column prop="a15" width="180" label="大列6">
		</table-column>
		<table-column prop="a16" width="180" label="小列7"></table-column>
		<!--<table-column prop="a17" width="180" label="小列8">
			<table-column prop="a18" width="180" label="小列8"></table-column>
			<table-column prop="a19" width="180" label="小列8"></table-column>
		</table-column>-->
	</table-tree>
</template>

<script>
import table from "@/components/treeGrid";
export default {
    data() {
        return {
            data: [],
            props: {
                children: "children",
                hasChild: "HasChild",
                expandNode: "a9"
            }
        };
    },
    methods: {
        myclick(item) {
            console.log(item);
        },
        expand(item, flag) {
            console.log(item, flag);
        },
        renderContent(h, data, index) {},
        format(data, index) {
            return "<div>123</div>";
        },
        loadChild(item, callback) {
            let child = [];
            for (let g = 1; g < 3; g++) {
                let curchild = {};
                for (let j = 1; j < 17; j++) {
                    curchild["a" + j] = "叶子-" + g;
                }

                child.push(curchild);
            }

            callback(child);
        }
    },
    components: {
        "table-tree": table
    },
    created() {
        let datas = [];
        for (let i = 0; i < 50; i++) {
            let obj = {};
            for (let j = 1; j < 17; j++) {
                if (i % 4 === 0 && j === 11) {
                    obj["a" + j] =
                        "1节点 的风格让他的风格让rrr" +
                        i;
                } else {
                    obj["a" + j] = "1节点:" + i;
                }
            }

            obj.children = [];
            for (let k = 0; k < 3; k++) {
                let child = {};
                for (let j = 1; j < 17; j++) {
                    if (k === 0 && j === 11) {
                        child["a" + j] =
                            "是数据量是的的法国人十多个电饭锅水电费了电饭锅VB的风格水电费为的风格让他的风格让他地方个人法规和天然法规和头发刚刚好就让他焚膏继晷发几个" +
                            k;
                    } else {
                        child["a" + j] = "abcd=" + k;
                    }
                }

                child.HasChild = true;

                child.children = [];
                // for (let g = 1; g < 3; g++) {
                //     let curchild = {};
                //     for (let j = 1; j < 17; j++) {
                //         curchild["a" + j] = "叶子-" + g;
                //     }

                //     child.children.push(curchild);
                // }

                obj.children.push(child);
            }
            datas.push(obj);
        }

        console.log(datas);

        setTimeout(() => {
            this.data = datas;
        }, 50);
    }
};
</script>

<style>

</style>