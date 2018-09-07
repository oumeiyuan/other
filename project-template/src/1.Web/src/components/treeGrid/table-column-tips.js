export default {
    methods: {
        $initTips(option) {
            if (window["sapi-title-tips"]) {
                return; 
            }

            let className="";
            if(option){

            }

            let div = document.createElement("div"); 
            div.id = "sapi-title-tips"; 
            div.className = "sapi-title-tips hide"; 
            div.innerHTML = '<span class="text"></span><span class="down-arrow"></span>'; 
            document.body.appendChild(div); 
        }, 
        $showTips(text, e, option) {
            if ( ! text) {
                return; 
            }

            const tipDom = window["sapi-title-tips"]; 
            if ( ! tipDom) {
                console.warn("请先注册tip组件"); 
                return; 
            }

            tipDom.style.left = 0;
            tipDom.style.top = 0;
            tipDom.style.width = null;
 
            tipDom.className=tipDom.className.replace(/\s+hide/g, "");
            if(tipDom.className.indexOf("visibiHide") === -1){
                tipDom.className += " visibiHide";
            }

            const tipTextDom = tipDom.firstChild; 
            const lastChild = tipDom.lastChild; 

            tipTextDom.innerText = text; 

            let target = e.target; 
            const maxWidth = target.clientWidth - 20; 
            
            let subWidth = tipTextDom.clientWidth - maxWidth; 
            if (subWidth > 0) {
                let bodyWidth = document.body.clientWidth; 
                let width = tipDom.clientWidth; 
                let x = e.clientX - e.offsetX; //节点的左边界线
                let left, iconLeft = 23; 
                let subLeft = width - (bodyWidth - x); 
                //基本上等于窗口大小时
                if (width + 10 > bodyWidth) {
                    left = 0; 
                    iconLeft += x + 5; 
                }
                //往后延伸超出窗口
                else if (subLeft > 0) {
                    subLeft = subLeft + 15;
                    left = x - subLeft; 
                    iconLeft += subLeft; 
                }
                //正常情况下
                else {
                    let subMidLeft = parseInt(subWidth / 2);
                    left = x - subMidLeft; 
                    iconLeft += subMidLeft; 
                }

                let y = e.clientY - e.offsetY; //节点的上边界线
                let top = y - tipDom.clientHeight - 10; 
                tipDom.style.left = left + "px"; 
                tipDom.style.top = top + "px"; 
                tipDom.style.width = width + 10 + "px"; 
                lastChild.style.left = iconLeft + "px";
                tipDom.className = tipDom.className.replace("visibiHide",""); 
            } else {
                this.$closeTips();
            }
        }, 
        $closeTips() {
            const tipDom = window["sapi-title-tips"]; 
            if ( ! tipDom) {
                console.warn("请先注册tips组件"); 
                return; 
            }

            if(tipDom.className.indexOf("hide") === -1){            
                tipDom.className = tipDom.className.replace(" visibiHide", "") + " hide";
            }
            
        }
    }
}