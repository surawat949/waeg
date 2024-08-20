(function($,sr){
  var debounce = function (func, threshold, execAsap) {
      var timeout;
      return function debounced () {
          var obj = this, args = arguments;
          function delayed () {
              if (!execAsap)
                  func.apply(obj, args);
              timeout = null;
          };

          if (timeout) clearTimeout(timeout);
          else if (execAsap) func.apply(obj, args);

          timeout = setTimeout(delayed, threshold || 100);
      };
  }
  jQuery.fn[sr] = function(fn){  return fn ? this.bind('resize', debounce(fn)) : this.trigger(sr); };

})(jQuery,'smartresize');

var addWheelEvent = (function(window, undefined) {        
	var _eventCompat = function(event) {
		var type = event.type;
		if (type == 'DOMMouseScroll' || type == 'mousewheel') { event.delta = (event.wheelDelta) ? event.wheelDelta / 120 : -(event.detail || 0) / 3; }
		if (event.srcElement && !event.target) { event.target = event.srcElement; }
		if (!event.preventDefault && event.returnValue !== undefined) {
			event.preventDefault = function() { event.returnValue = false; };
		}
		return event;
	};
	if (window.addEventListener) {
		return function(el, type, fn, capture) {
			if (type === "mousewheel" && document.mozHidden !== undefined) { type = "DOMMouseScroll"; }
			el.addEventListener(type, function(event) { fn.call(this, _eventCompat(event));
			}, capture || false);
		}
	} else if (window.attachEvent) {
		return function(el, type, fn, capture) {
			el.attachEvent("on" + type, function(event) {
				event = event || window.event;
				fn.call(el, _eventCompat(event));    
			});
		}
	}
	return function() {};    
})(window);

var delWheelEvent = (function(window, undefined){
	if (window.addEventListener) {
		return function(el, type, fn) {
			if (type === "mousewheel" && document.mozHidden !== undefined) { type = "DOMMouseScroll"; }
			el.removeEventListener(type, fn, true);
		}
	} else if (window.attachEvent) {
		return function(el, type, fn) {
			el.detachEvent("on" + type, fn);
		}
	}
})(window);

;(function($) {
	/** var scrollbarW = $.getScrollbarWidth(); */
	var scrollbarWidth = 0;
	$.getScrollbarWidth = function() {
		if ( !scrollbarWidth ) {
			if ( navigator.appVersion.indexOf("MSIE") != -1) {
				var $textarea1 = $('<textarea cols="10" rows="2"></textarea>').css({ position: 'absolute', top: -1000, left: -1000 }).appendTo('body'),
					$textarea2 = $('<textarea cols="10" rows="2" style="overflow: hidden;"></textarea>').css({ position: 'absolute', top: -1000, left: -1000 }).appendTo('body');
				scrollbarWidth = $textarea1.width() - $textarea2.width();
				$textarea1.add($textarea2).remove();
			} else {
				var $div = $('<div />').css({ width: 100, height: 100, overflow: 'auto', position: 'absolute', top: -1000, left: -1000 }).prependTo('body').append('<div />').find('div').css({ width: '100%', height: 200 });
				scrollbarWidth = 100 - $div.width();
				$div.parent().remove();
			}
		}
		return scrollbarWidth;
	};
})(jQuery);
	
;(function($){
	/*
		browser : ie/firefox/chrome/opera/safari
		browser Kernel :$.NV('ua'); or $.NV('UA');
		browser Kernel :$.NV('name');or $.NV();
		browser Kernel :$.NV('version');
	*/
	$.extend({
		NV:function(name){
			var NV = {};
			var UA = navigator.userAgent.toLowerCase();
			try{
				NV.name=!-[1,]?'ie':
				(UA.indexOf("firefox")>0)?'firefox':
				(UA.indexOf("chrome")>0)?'chrome':
				window.opera?'opera':
				window.openDatabase?'safari':
				'unkonw';
			}catch(e){};
			try{
				NV.version=(NV.name=='ie')?UA.match(/msie ([\d.]+)/)[1]:
				(NV.name=='firefox')?UA.match(/firefox\/([\d.]+)/)[1]:
				(NV.name=='chrome')?UA.match(/chrome\/([\d.]+)/)[1]:
				(NV.name=='opera')?UA.match(/opera.([\d.]+)/)[1]:
				(NV.name=='safari')?UA.match(/version\/([\d.]+)/)[1]:
				'0';
			}catch(e){}
			switch(name){
				case 'ua':
				case 'UA':br=UA;break;
				case 'name':br=NV.name;break;
				case 'version':br=NV.version;break;
				default:br=NV.name;
			}
			return br;
		}
	});
})(jQuery);

var oldValue = '';// validation_qty = /^[1-9]+[0-9]*]*$/, validation_qty1 = /^([1-9]+[0-9]*)$|^0$/;
$.fn.inputFocusValue = function(validationType, e){		//input the history of value is saved
	var eventConfig = {
		focus : function(){
			oldValue = '';
			var focus_val = $.trim($(this).val());
			if(validationType.test(focus_val)){oldValue = focus_val;}
		}
	};
	if($.isFunction(eventConfig[e.type])){eventConfig[e.type].call(this, e);}
	return oldValue;
};

$.fn.inputFocusValueFormat = function(validationType, e){		//input the history of value is saved
	var eventConfig = {
		focus : function(){
			oldValue = '';
			var focus_val = Globalize.parseFloat($.trim($(this).val()));
			if(validationType.test(focus_val)){oldValue = focus_val;}
		}
	};
	if($.isFunction(eventConfig[e.type])){eventConfig[e.type].call(this, e);}
	return oldValue;
}
;function customMap(){
    /** var map_demo = new Map();*/
    this.elements = new Array();
    this.size = function(){return this.elements.length;}
    this.isEmpty = function(){return (this.elements.length < 1);}
    this.clear = function(){this.elements = new Array();}
    this.put = function(_key, _value){this.elements.push({ key: _key, value: _value});}
  
    this.remove = function(_key){
        var bln = false;
        try {for (i = 0; i < this.elements.length; i++) {if (this.elements[i].key == _key) {this.elements.splice(i, 1);return true;}}} catch (e) {bln = false;}
        return bln;
    }
 
    this.get = function(_key){
        try {for (i = 0; i < this.elements.length; i++) {if (this.elements[i].key == _key) {return this.elements[i].value;}}} catch (e) {return null;}
    }
 
    this.element = function(_index){
        if (_index < 0 || _index >= this.elements.length) {return null;}
        return this.elements[_index];
    }
 
    this.containsKey = function(_key){
        var bln = false;
        try {for (i = 0; i < this.elements.length; i++) {if (this.elements[i].key == _key) {bln = true;}}} catch (e) {bln = false;}
        return bln;
    }
 
    this.containsValue = function(_value){
        var bln = false;
        try {for (i = 0; i < this.elements.length; i++) {if (this.elements[i].value == _value) {bln = true;}}} catch (e) {bln = false;}
        return bln;
    }
 
    this.values = function(){
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {arr.push(this.elements[i].value);}
        return arr;
    }
 
    this.keys = function(){
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {arr.push(this.elements[i].key);}
        return arr;
    }
}
$.fn.inputFocusVal = function(e){		//input the history of value is saved
	var eventConfig = {
		focus : function(){ oldValue = ''; var focus_val = $.trim($(this).val()); oldValue = focus_val; }
	};
	if($.isFunction(eventConfig[e.type])){eventConfig[e.type].call(this, e);}
	return oldValue;
};
;function customFomatFloat(src,pos){     
	return Math.round(src*Math.pow(10, pos))/Math.pow(10, pos);     
}
$.fn.setInputHiddenValue = function(val){
	$(this).parent().find('input[type="hidden"]').val(val);
}
$.fn.numberFomatFloat = function(){
	var myTagName = $(this)[0].tagName.toLowerCase(), thisValue = 0;
	if(myTagName == 'input'){thisValue = $.trim($(this).val());}else{thisValue = $.trim($(this).text());}	
	var f = parseFloat(x);  
	if (isNaN(f)) {return 0}
	var f = (x*100)/100;  
	var s = f.toString();  
	var rs = s.indexOf('.');  
	if (rs < 0) {rs = s.length;s += '.';}  
	while (s.length <= rs + 2) {s += '0';}  
	return s;  
};

$.fn.tagValue = function(){
	var val = 0;
	val = $.trim($(this).find('span').text());
	if(typeof $(this).find('input[type="text"]')[0] != "undefined"){
		val = $.trim($(this).find('input[type="text"]').val());
	}
	return val;
}
$.fn.returnNaNValue = function(){return (isNaN(parseFloat($.trim($(this).val()))) ? 0 : $.trim($(this).val()));}
$.fn.tagTypeValue = function(){
	var thisValue = 0;
	if(typeof $(this).find('input[type="text"]')[0] != "undefined"){
		thisValue = $.trim($(this).find('input[type="text"]').val());
	}else{thisValue = $.trim($(this).text());}
	var f = parseFloat(thisValue);  
	if (isNaN(f)) {return 0}
	return f;  
};
;function toDecimal2(x) {  
    var f = parseFloat(x);  
    if (isNaN(f)) {return 0;}
    var f = (x*100)/100;  
    var s = f.toString();  
    var rs = s.indexOf('.');  
    if (rs < 0) {rs = s.length;s += '.';}  
    while (s.length <= rs + 2) {s += '0';}  
    return (parseFloat(s).toFixed(2));  
}
;function toDecimal3(x) {  
    var f = parseFloat(x);  
    if (isNaN(f)) {return '0.00';}
    var f = (x*100)/100;  
    var s = f.toString();  
    var rs = s.indexOf('.');  
    if (rs < 0) {rs = s.length;s += '.';}  
    while (s.length <= rs + 2) {s += '0';}  
    return (parseFloat(s).toFixed(2));  
}

function accDiv(arg1,arg2){	// /
	var t1=0,t2=0,r1,r2;
	r1 = tryChatchValue(r1, arg1);
	r2 = tryChatchValue(r2, arg2);
	with(Math){
		r1=Number(arg1.toString().replace(".",""))
		r2=Number(arg2.toString().replace(".",""))
		return (r1/r2)*pow(10,t2-t1);
	}
} 
function accMul(arg1,arg2){	// *
	var m=0,s1=arg1.toString(),s2=arg2.toString();
	try{m+=s1.split(".")[1].length}catch(e){}
	try{m+=s2.split(".")[1].length}catch(e){}
	return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)
}
function accAdd(arg1,arg2){	//	+
	var r1,r2,m;
	r1 = tryChatchValue(r1, toDecimal3(arg1));
	r2 = tryChatchValue(r2, toDecimal3(arg2));
	m=Math.pow(10,Math.max(r1,r2))
	return ((arg1*m+arg2*m)/m);
}
function tryChatchValue(r, arg0){
	try{ return (arg0.toString().split(".")[1].length);}catch(e){ return 0;}
}
function accSubtr(arg1,arg2){	// -
	var r1,r2,m,n;
	r1 = tryChatchValue(r1, arg1);
	r2 = tryChatchValue(r2, arg2);
	m=Math.pow(10,Math.max(r1,r2));
	n=(r1>=r2)?r1:r2;	//
	return (((arg1*m-arg2*m)/m).toFixed(n));
}
function ceilFn(digit, length) {
	length = length ? parseInt(length) : 0;
	if (length <= 0) return Math.ceil(digit);
	digit = Math.ceil(digit * Math.pow(10, length)) / Math.pow(10, length);
	return digit;
};
function roundFn(digit, length) {
	length = length ? parseInt(length) : 0;
	if (length <= 0) return Math.round(digit);
	digit = Math.round(digit * Math.pow(10, length)) / Math.pow(10, length);
	return digit;
};
function jQCallback(callback){if($.isFunction(callback)){callback();}}
function JsCallback(callback){if (typeof callback != 'undefined' && callback != null) {callback();}}