/*
 * 2012/11/15
 * by liangwei
 */
(function(droppable) {
    jQuery.fn.droppable = function(options) {
        if(options.accept == null){return;}
        /*
         * 以下是droppable控件的所有可选操作
         * accept:可以被droppable接受的元素
         * activeClass:当可接受元素被拖动时，接受元素的class
         * hoverClass:当可接受元素经过droppable的元素时。。。
         * drop:当可接受元素被放到droppable元素上时，执行的回调函数，
         * 它有俩个参数(dragging,dropping),顾名思义
         * liveSelector:为了克服新增添的元素不能“droppable”而为之，
         * 我再想不出别的办法了，jquery也不支持新元素“droppable”,
         * 此option不指定时，新加的元素不能droppable
         */
        var accept          = options.accept,
            activeClass     = options.activeClass,
            hoverClass      = options.hoverClass,
            drop            = options.drop,
            liveSelector    = options.liveSelector;
           /*
            * 以下变量都是辅助变量，主要是为了尽量减少“mousemove”
            * 事件的回调函数中的操作，提高一些性能。
            * draging和droping是传给drop回调函数用的，
            * acceper是所有droppable元素
            * center记录了droping元素的中心的坐标，scopes记录所有droppable元素的坐标范围。
            */
        var draging=droping=center=offset=null,
            accepter=this,len = this.length,
            scopes = $.map(accepter.toArray(),function(itm){
                var item = $(itm);
                return {
                    minX : item.offset().left,
                    maxX : item.offset().left + item[0].offsetWidth,
                    minY : item.offset().top,
                    maxY : item.offset().top + item[0].offsetHeight 
                };
            });
        $(accept).live("mousedown",function(){
            draging = $(this);
            if(liveSelector !=null){
                accepter = $(liveSelector);
                len = accepter.length;
                scopes = $.map(accepter.toArray(),function(itm){
                    var item = $(itm);
                    return {
                        minX : item.offset().left,
                        maxX : item.offset().left + item[0].offsetWidth,
                        minY : item.offset().top,
                        maxY : item.offset().top + item[0].offsetHeight 
                    };
                });
            }
            activeClass ? accepter.addClass(activeClass):"";
        });
        
        $(accept).live("mouseup",function(){
            activeClass ? accepter.removeClass(activeClass):"";
            hoverClass ? accepter.removeClass(hoverClass):"";
            if(droping != null && draging != null && drop != null){
                drop(draging,droping);
            }
            draging = null;
            droping = null;
        });
        $(accept).live("mousemove",function(e){
            if(draging != null){
                offset = draging.offset();
                center = {
                    x : offset.left + draging[0].offsetWidth/2,
                    y : offset.top + draging[0].offsetHeight/2
                };
                $.each(scopes,function(i,scope){
                    /*
                     * 判断draging元素是否和droppable相交，并找出与之相交的droppable元素。
                     */
                    if(center.x>scope.minX&&center.x<scope.maxX&&center.y>scope.minY&&center.y<scope.maxY){
                        droping = $(accepter[i]);
                        droping.addClass(hoverClass);
                        return false;
                    }
                    if(i==len-1 && droping != null){
                        droping.addClass(activeClass);
                        droping.removeClass(hoverClass);
                        droping = null;
                    } 
                });
            }
        });
        return this;
    }
})(jQuery);