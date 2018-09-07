--更新版本信息
UPDATE TSys_Config
SET Value = N'{"Name": "业务系统","Version": "1.0.0.0","Description": "","Date": "2018-05-23","Author": "赛普爱德","Support": "","Dependencies": [{"Name": "IDPlat","Version": "1.3.3"},{"Name": "Sapi","Version": "1.0.5"}, {"Name": "Sapi.Data.EntityFramework","Version": "1.0.5"}, {"Name": "Sapi.Redis","Version": "1.0.5"}, {"Name": "Sapi.WebApi","Version": "1.0.5"}]}'
WHERE ConfigId='Version'