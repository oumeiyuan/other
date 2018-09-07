export default {
	supplierManage: {
		//oper

		//model
		supName:"供方名称",
        className:"供方分类",
        supNo:"供方编号",
        taxPayerId:"纳税类型",
        enterpriseForm:"企业类型",
        registeredCapital:"注册资本",
        remark:"备注",
        area: "所在地区",
        provinceName:"省份",
        cityName:"城市",
        areaName:"区域",
        creditCode:"信用代码",
        businessLicence:"营业执照",
        address:"公司地址",
        postalCode:"邮政编码",
        officePhone:"公司电话",
        faxNumber:"公司传真",
        email:"电子邮箱",
        officialWebsite:"公司网页",

        contactName:"姓名",
        positionName:"职级",
        sex:"性别",
        mobileTelephone:"手机号码",
        qualificationName:"资质类型",
        qualificationFile:"资质文件",

        cooperativeType:"合作类型",
        cooperativeCompany:"合作公司",
        cooperativeProjectName:"合作项目",
        cooperativeRange:"合作范围",
        contractAmount:"合同金额",
        amountUnit: "合同金额(万元)",
        commencementDate:"开工完成日期",
        taxPayer:"纳税人类型",
        legalRepresentative:"法人代表",
        registeredCapital:"注册资本",
        setContact:"联系人信息",
        setQualification:"资质信息",
        setCooperativeCase:"合作案例",

        //msg		
        addSupplierTitle:"新增供方",
        editSupplierTitle: "修改供方",
        viewSupplierTitle:"查看供方",
        search:"按供方名称搜索",
        addSupplierContactTitle:"新增联系人",
        editSupplierContactTitle:"修改联系人",
        importCooperativeCaseTitle:"合作案例导入",
        import:"合作案例导入",
        baseInfo:"基本信息",
        contactInformation:"联系人信息",
        qualificationInformation:"资质信息",
        cooperativeCaseInformation:"合作案例信息",

        supNameNotBeEmpty:"供方名称不能为空",
        provinceNotBeEmpty:"省份不能为空",
        cityNotBeEmpty:"城市不能为空",
        areaNotBeEmpty:"区域不能为空",
        classNameNotBeEmpty:"供方分类不能为空",
        classCannotExceed:"供方分类不能选择超过3个",
        businessLicenceNotBeEmpty:"营业执照不能为空",
        contactNameNotBeEmpty:"联系人姓名不能为空。",
        qualificationFileNotBeEmpty: "资质文件不能为空",
        contactOfficePhoneASCIIContentPlease: "联系人公用电话,请输入字母、数字、英文标点及常用特殊字符",
        contactMobileTelephoneASCIIContentPlease: "联系人手机号码,请输入字母、数字、英文标点及常用特殊字符",
        contactEmailASCIIContentPlease: "联系人电子邮箱,请输入字母、数字、英文标点及常用特殊字符",
        
        addSupplierSuccess:"新增供方成功。",
        editSupplierSuccess:"修改供方成功。",
        delSupplierSuccess:"删除供方成功。",
       

		//data
        taxTypeData:{
            General:"一般纳税人", // 1
            SmallScale :"小规模纳税人", //2
            GovernmentFee :"政府规费"  //3
        },
        enterpriseFormData:
        {
            StateOwnedEnterprise:"国有企业", //1
            PrivateEnterprise:"民营企业",
            OtherEnterprise:"其他" 
        },
        sexData:
        {
            man:"男",
            woman:"女"
        },
        
		//code
		code: {
            121011:"新增失败，已经存在一个相同的供方名称。",
            121012:"修改失败，已经存在一个相同的供方名称。",
            121013:"移除失败，找不到可移除的供方名称。",
            121014:"导入合作案例失败，导入数据为空。",
            121015:"导入合作案例数据失败，导入数据列名与模板不一致。",
            121016:"导入合作案例失败，第{0}行合作公司为空。",
            121017:"导入合作案例失败，第{0}行合作公司格式不正确。",
            121018:"导入合作案例失败，第{0}行合作项目为空。",
            121019:"导入合作案例失败，第{0}行合作公司格式不正确。",
            121020:"导入合作案例失败，第{0}行合同范围为空。",
            121021:"导入合作案例失败，第{0}行合同范围格式不正确。",
            12022:"导入合作案例失败，第{0}行合同金额为空。",
            12023:"导入合作案例失败，第{0}行合同金额格式不正确。"
		}
	}
}