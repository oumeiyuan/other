
export default {
    getAddress (provinceName, cityName, areaName,seperate) {
        seperate=seperate||"";
        var result=(provinceName||"");

        if(cityName && cityName.length>0 && (cityName!==provinceName)){
            result+=seperate;
            result+=cityName;
        }
        if(areaName && areaName.length>0 && (areaName!==cityName)){
            result+=seperate;
            result+=areaName;
        }
       
        return result;
    }
}