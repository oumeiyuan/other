import importLocale from "@/static/js/importLocale.js";
import {platStatic} from "./locale-static.js";
!Vue.toLocale&&Vue.use(importLocale);
Vue.toLocale(platStatic);

export default {
    //下拉列表使用 纳税人类型
    TaxPayerValues: [
        { TaxPayerId: 1, TaxPayerName: Vue.__t('supplierManage.taxTypeData.General') },
        { TaxPayerId: 2, TaxPayerName: Vue.__t('supplierManage.taxTypeData.SmallScale') },
        { TaxPayerId: 3, TaxPayerName: Vue.__t('supplierManage.taxTypeData.GovernmentFee') }
    ],
    //下拉列表使用 企业类型
    EnterpriseFormValues: [
        { EnterpriseForm: 1, EnterpriseFormName: Vue.__t('supplierManage.enterpriseFormData.StateOwnedEnterprise') },
        { EnterpriseForm: 2, EnterpriseFormName: Vue.__t('supplierManage.enterpriseFormData.PrivateEnterprise') },
        { EnterpriseForm: 3, EnterpriseFormName: Vue.__t('supplierManage.enterpriseFormData.OtherEnterprise') }
    ],

    //用于查看，可以直接通过TaxPayerValue[taxType]; 获取到名称
    TaxPayerValue:
    {
        1: Vue.__t('supplierManage.taxTypeData.General'),
        2: Vue.__t('supplierManage.taxTypeData.SmallScale'),
        3: Vue.__t('supplierManage.taxTypeData.GovernmentFee')
    },
    //用于查看，可以直接通过EnterpriseFormValue[taxType]; 获取到名称
    EnterpriseFormValue:
    {
        1: Vue.__t('supplierManage.enterpriseFormData.StateOwnedEnterprise'),
        2: Vue.__t('supplierManage.enterpriseFormData.PrivateEnterprise'),
        3: Vue.__t('supplierManage.enterpriseFormData.OtherEnterprise')
    }
}