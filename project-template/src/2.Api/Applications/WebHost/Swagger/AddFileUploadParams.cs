using System.Web.Http.Description;
using Swashbuckle.Swagger;

namespace WebHost
{
    public class AddFileUploadParams : IOperationFilter
    {
        public void Apply(Operation operation, SchemaRegistry schemaRegistry, ApiDescription apiDescription)
        {
            if (operation.operationId == "File_PostFormData" || operation.operationId == "User_EditHeadIconPath" || operation.operationId == "User_Import"
                || operation.operationId == "Employee_Import" || operation.operationId == "Station_Import" || operation.operationId == "Position_Import"
				|| operation.operationId == "File_UploadFile" || operation.operationId == "Share_Uplaod")
            {
                operation.consumes.Add("application/form-data");
                operation.parameters = new[]
                {
                    new Parameter
                    {
                        name = "file",
                        @in = "formData",
                        required = true,
                        type = "file"
                    }
                };
            }
            if (operation.operationId == "Structure_Import")
            {
                operation.consumes.Add("application/form-data");
                operation.parameters = new[]
                {
                    new Parameter
                    {
                        name = "file",
                        @in = "formData",
                        required = true,
                        type = "file"
                    },
                    new Parameter
                    {
                        name = "struId",
                        @in = "query",
                        required = false,
                        type = "string",
                        description = "指定的架构Id，默认值为null，表示第一级节点的父级架构Id为null"
                    },
                    new Parameter
                    {
                        name = "isCover",
                        @in = "query",
                        required = false,
                        type = "boolean",
                        description = "是否覆盖，默认值为false，false：表示直接追加；true：表示将当前架构下的子级架构以及岗位先删除再添加"
                    }
                };
            }
        }
    }
}