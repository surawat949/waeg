var TIMEOUT, scrollbarW=$.getScrollbarWidth(), QUEUE = async.queue(queueRun, 1);
;function queueRun(task, callback) {
    task.run(callback);
}

;function initCtrlDocument(){
	Globalize.culture(this.locale).numberFormat.currency.symbol = "";
	fixTableLayout();
	initTablesoter();
	completegetAccountFunction();
}

;function initTablesoter(){
	var tablesorterOptions={
		    widgetOptions: { stickyHeaders : "tablesorter-stickyHeader"},
			theme: 'blue', headerTemplate : '{content} {icon}', widthFixed: true, 
			sortRestart: true, widgets: ['zebra', 'filter', 'stickyHeaders']
		},
		pagerOptions={
			container: $(".pager"), output: '{startRow} - {endRow} / {filteredRows} ({totalRows})', 
			fixedHeight: false, removeRows: false, cssGoto: '.gotoPage', page: 0, size: 10
		};

  $('#actDiv').hide().find('#actsoter').tablesorter(tablesorterOptions).tablesorterPager(pagerOptions)
  		.bind('pageMoved', function(e, c){
  			var $allCheck=$('#allcheck'), checkLen=$('#tabBody tr:not(:hidden)').find('input[type="checkbox"]:checked').length;
  			console.log( checkLen );
  			if(checkLen >= c.size){
  				$allCheck.prop({'checked': true});
  			}else{
  				$allCheck.prop({'checked': false});
  			}
	    });
}

;function completegetAccountFunction(){
	var $paging=$('[id*=paging]'), _json=$.parseJSON($paging.val()), $tabBody=$('#tabBody');
	
	$tabBody.append($('#tmpBody tr'));
	console.log(_json);
	if(_json['isStop']){
		document.getElementById('loading-curtain-div').style.display = 'none';
		$('#actsoter').trigger('updateAll');
		$('#actDiv').show();
		return;
	}
	
	_json['sql']=(_json['baseSql'] + ' ' + _json['filter'] +/*' and id >\''+ _json['lastId']+'\' ' +*/ _json['orderBy'] + ' limit ' + _json['limitSize']);
	$paging.val(JSON.stringify(_json));
	getAccountFunction();	//this is action function.
}

;function completegetFilterAccountFunction(){
	var $paging=$('[id*=paging]'), _json=$.parseJSON($paging.val()), $tabBody=$('#tabBody');
	
	$tabBody.append($('#tmpBody tr'));
	console.log(_json);
	if(_json['isStop']){
		document.getElementById('loading-curtain-div').style.display = 'none';
		$('#actsoter').trigger('updateAll');
		$('#actDiv').show();
		return;
	}
	
	_json['sql']=(_json['baseSql'] + ' ' + _json['filter'] +' '+ _json['searchFilter'] +/*' and id >\''+ _json['lastId']+'\' ' +*/ _json['orderBy'] + ' limit ' + _json['limitSize']);
	$paging.val(JSON.stringify(_json));
	getAccountFunction();	//this is action function.
}

;function complete_insertCampaignMember(result, event, data){
	if(event.status){
		window.location.href = '/'+$('#campaignId').val();
    }else{
    	alert(event['message']);
    	console.log(event);
    }
    document.getElementById('loading-curtain-div').style.display = 'none';
}

;function event_checkAll_click(target){
	var $this=$(target);
	$('#tabBody tr:not(:hidden)').each(function(){
		$(this).find('input[type="checkbox"]').prop({'checked': $this.prop('checked')});
	});
}

;function event_save_click(target){
	
	var list_insert=[], cId=$('#campaignId').val();
	
	$('#tabBody input[type="checkbox"]:checked').each(function(){
		list_insert.push({'aId': $(this).parent().parent().attr('id'), 'cId': cId});
	});
	if(list_insert.length > 1000){
		art.dialog({
	        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid', content: 'Can not save more than 1000 data.',
	        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
	    });
	    return;
	}
	if(list_insert.length == 0){
		return;
	}
	document.getElementById('loading-curtain-div').style.display = '';
	customRemoteAction({'json': JSON.stringify(list_insert)}, insertCampaignMember_js, complete_insertCampaignMember);
}


;function event_cancel_click(target){
	document.getElementById('loading-curtain-div').style.display = '';
	window.location.reload();
}
;function event_exitWithoutSave_click(target){
	window.location.href = '/'+$('#campaignId').val(); 
}
;function event_filter_click(target){
	var $template=$('#filterTmp div.filter-box').clone(), $filterBox=$('#filterbox'), $box=$filterBox.find('div.filter-box');
	if($box.length == 0){
		$template.find('div.logic').css({'visibility': 'hidden'});
	}
	if($box.length > 0 && !$box.first().find('div.btnbox input:first').hasClass('edit')){
		art.dialog({
	        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid', 
	        content: 'Please make sure the first filter.',
	        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
	    });
		return false;
	}
	$filterBox.append($template);
}

;function event_addFilter_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	
	var $this=$(target), $filterBox=$this.parent().parent();
	
	if($this.hasClass('new')){
		$filterBox.find('div:not(:last)').find('input, select').prop({'disabled': true});
		$this.addClass('edit').removeClass('new').val($this.attr('data-edit'));
		return;
	}
	$filterBox.find('div:not(:last)').find('input, select').prop({'disabled': false});
	$this.addClass('new').removeClass('edit').val($this.attr('data-ok'));
	
}

;function event_cancelFilter_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	var $parent=$(target).parent().parent(), $parentBox=$parent.parent();

	$parent.remove();
	$parentBox.find('div.filter-box:first').find('div.logic').css({'visibility': 'hidden'});
}

;function event_searchFilter_click(event, target){
	event = (event?event:window.event);
	event.cancelBubble = true;
	document.getElementById('loading-curtain-div').style.display = '';
	$('#actDiv').hide().find('#tabBody tr').remove();
	$('#actDiv').hide().find('#tmpBody tr').remove();

	$('#actsoter').trigger('updateAll');
	var $paging=$('[id*=paging]'), _json=$.parseJSON($paging.val());
	_json['searchFilter'] = '';
	$('#filterbox input[type="button"].querycheck').each(function(idx){
		var $this=$(this), $parent=$this.parent().parent(), logic=$parent.find('select.logicselect option:selected').val(),
			logicField=$parent.find('select.fieldselect option:selected').val(), logicFilter=$parent.find('select.string option:selected').attr('data-filter'),
			logicString=$.trim($parent.find('input[type="text"].filtervalue').val());
		var finalFilter = logicFilter;

		if(logicFilter == 'in' || logicFilter == 'not in'){
            logicString = logicString.split(',');
            var t=''
            for(var i=0, max=logicString.length; i<max; i++){
                t += ('\''+logicString[i]+'\',');
            }
            t = (t.length > 0 ? t.substring(0, t.length-1): '');
            logicString = ('('+t+')');
        } else if(logicFilter == 'like'){
        	logicString = ' \''+logicString+'%\' ';
		} else if($.isNumeric(logicString)){
			logicString = logicString;
		} else {
            logicString = ' \'' +logicString+ '\' ';
		}
		if(logicFilter == 'le'){
			finalFilter = ' <= ';
		}else if(logicFilter == 'ge'){
			finalFilter = ' >= ';
		}
      
		logic = ' '+ (idx == 0 ? '' : logic)+ ' ';
		_json['searchFilter'] +=  (logic+logicField+ ' ' + finalFilter + logicString);
	});
	_json['searchFilter'] = (_json['searchFilter'] != '' ? (' and ('+_json['searchFilter']+') ') : _json['searchFilter']);
	_json['sql']=(_json['baseSql'] + ' ' + _json['filter'] +' '+ _json['searchFilter'] +/*' and id >\''+ _json['lastId']+'\' ' +*/ _json['orderBy'] + ' limit ' + _json['limitSize']);
	$paging.val(JSON.stringify(_json));
	
	getFilterAccountFunction();		//this is action function
}



;function fixTableLayout(resize_width){
    try{
        var $compbody=$('#forecastdiv_id'), min_cw= parseInt($compbody.css('min-width').replace('px', ''), 10), 
            max_ow=(typeof(resize_width) != 'undefined' ? resize_width : $('#contentallid').outerWidth(true));
    
        min_cw = (max_ow < min_cw ? min_cw : (max_ow-40));
        
        document.getElementById('contentallid').style.width = (min_cw)+'px';    //set all div width

        $compbody.css('visibility', 'visible');
    }catch(e){
        
    }
}

;function artDialogBox(content){
	art.dialog({
        title:' ', lock:true, dblclick_hide:false, esc:false, id: 'countsid', content: content,
        button : [ {value: 'Ok', focus: true, callback: function(){  }} ]
    });
}

;function numberOfZero(t){
    if(t == ''){return 0;}
    t = Globalize.parseFloat(t);
    return ($.isNumeric(t) ? t : 0);
}

;function getZeroOfNumber(t){
	t=parseFloat(t);
	return ($.isNumeric(t) ? t : 0);
}

;function getZeroOfNumber_Int(t){
	t=parseInt(t, 10);
	return ($.isNumeric(t) ? t : 0);
}

;function asyncEachSeries(result, asyncCallBack, asyncCallBackComplete, time, _data, $tbody){
    async.eachSeries(result, function(item, callback){
        setTimeout(function(){
            asyncCallBack(item, callback);
            callback(null);
        }, (time||120));
    }, function(err){
        asyncCallBackComplete(err, _data, $tbody);
    });
}

;function asyncEachSeries_Original(result, asyncCallBack, asyncCallBackComplete, time){
    async.eachSeries(result, function(item, callback){
        setTimeout(function(){
            asyncCallBack(item, callback);
            callback(null);
        }, (time||120));
    }, function(err){
        asyncCallBackComplete(err);
    });
}

function customRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
}

function customMultipleRemoteAction(strParam, callFunction, callResult) {
    Visualforce.remoting.Manager.invokeAction(
        callFunction(), strParam['cls'], strParam['json'], function(result, event){ callResult(result, event, strParam); }, {escape: false, timeout:120000}
    );
}

;function eventHandle(e, _over, _out, _click){
    var customMouser = {mouseenter: _over,mouseleave: _out,click: _click};
    customMouser[e.type].call(this, e);customMouser = {};
}

;function eventHandle_ov_ot(e, _over, _out){
    var customMouser = {mouseenter: _over,mouseleave: _out};
    customMouser[e.type].call(this, e);customMouser = {};
}

;function addListener (element, event, fn, params) {
    var eventHandler = ( params ? function(){ fn.call(params); } : fn );
    if (window.attachEvent) {
        element.attachEvent('on' + event, eventHandler);
    } else {
        element.addEventListener(event, eventHandler, false);
    }
}