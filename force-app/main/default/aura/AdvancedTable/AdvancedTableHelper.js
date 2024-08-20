/**
 * Created by thomas.schnocklake on 12.02.18.
 */
({
    handleListOrColsChange : function (component, event, helper) {
        var quickFilter = '';//component.get('v.quickFilter');
        var columns = component.get('v.columns');
        var objectList = component.get('v.objectList');
       // console.log('dataOrColsChange', columns, objectList);


        var sortField = component.get('v.sortField');
        var sortDir = component.get('v.sortDir');

        var sortMod = sortDir == 'asc' ? 1 : -1;

        if (columns && objectList)
        {
            var sortCol = columns.find(col => col.fieldName === sortField );

            var sortFunc = function(a,b)
            {
                var result = sortMod * (a[sortField] < b[sortField] ? -1 : a[sortField] > b[sortField] ? 1 : 0);
                if((a[sortField]==null ||a[sortField]=='') && b[sortField]!=null) result=sortMod;
                if((b[sortField]==null ||b[sortField]=='') && a[sortField]!=null) result=sortMod*-1;
                return result;
            };

            
            if (sortCol && sortCol.type === 'DATETIME')
            {
                sortFunc = function(a,b)
                {
                    var a1 = typeof a[sortField] === "undefined" ? null : new Date(a[sortField]);
                    var b1 = typeof b[sortField] === "undefined" ? null : new Date(b[sortField]);

                    return sortMod * (a1 < b1 ? -1 : a1 > b1 ? 1 : 0);
                };
            }

            if(sortField.includes('Additionnal_account_data__r')){
                var sortFunc = function(a,b)
                {
                    var sortFieldName = sortField.substring('Additionnal_account_data__r.'.length, sortField.length);
                    var aa = a['Additionnal_account_data__r'];
                    var bb = b['Additionnal_account_data__r'];
                    if(aa!=null) {aa=a['Additionnal_account_data__r'][sortFieldName];}
                    if(bb!=null) {bb=b['Additionnal_account_data__r'][sortFieldName];}
                    var result = sortMod * (aa < bb ? -1 : aa > bb ? 1 : 0);
                    if((aa==null ||aa=='') && bb!=null) result=sortMod;
                    if((bb==null ||bb=='') && aa!=null) result=sortMod*-1;
                    return result;
                };
            }


            objectList.sort(sortFunc);


            var dataArrayInternal = (quickFilter ? objectList.filter(function (obj) {
                    var objString = '';
                    Object.keys(obj).forEach(function (k) {
                        if (k !== 'Id')
                            objString = objString + ' ' + obj[k];
                    })
                    return objString.toLowerCase().indexOf(quickFilter.toLowerCase()) >= 0;
                }) : objectList).map(
                function(rowObject) {
                    var n = [];
                            
                    columns.forEach(
                        function(col)
                        {
                            var value = rowObject[col.fieldName];
                            if(col.fieldName.includes('Additionnal_account_data__r')){
                                var linkedFieldName = col.fieldName.substring('Additionnal_account_data__r.'.length, col.fieldName.length);
                                if(rowObject['Additionnal_account_data__r']!=null){
                                    value = rowObject['Additionnal_account_data__r'][linkedFieldName];
                                }
                            }
                            if (col.type === 'TEXTAREA' ||
                                col.type === 'STRING' ||
                                col.type === 'EMAIL' ||
                                col.type === 'PICKLIST'
                                )
                            {
                                //n.push(rowObject[col.fieldName]);
                                n.push(value);
                            }
                            else if (col.type === 'DATETIME')
                            {
                                //n.push(typeof rowObject[col.fieldName] === "undefined" ? "" : new Date(rowObject[col.fieldName]).toLocaleString());
                                n.push(typeof rowObject[col.fieldName] === "undefined" ? "" : new Date(value).toLocaleString());
                            }
                            else if (col.type === 'PERCENT')
                            {
                                //n.push(rowObject[col.fieldName]);
                                n.push(value);
                            }
                            else if (col.type === 'DOUBLE')
                            {
                                //n.push(rowObject[col.fieldName]);
                                n.push(value);
                            }
                            else if (col.type === 'PHONE')
                            {
                                //n.push(rowObject[col.fieldName]);
                                n.push(value);
                            }
                            else if (col.type === 'DOUBLE')
                            {
                                //n.push(rowObject[col.fieldName]);
                                n.push(value);
                            }
                            else if (col.type === 'CURRENCY')
                            {
                                //n.push(rowObject[col.fieldName]);
                                n.push(value);
                            }
                            else if (col.type === 'dd')
                            {
                                n.push(typeof rowObject[col.fieldName] === "undefined" ? "" : new Date(rowObject[col.fieldName]).toLocaleString());
                            }
                            else
                            {
                                //console.log(col.type, rowObject[col.fieldName]);
                                //n.push(rowObject[col.fieldName]);
                                n.push(value);
                            }
                        }
                    );

                    return {dataList: n, dataObject : rowObject};
                });

            //console.log('dataArrayInternal', dataArrayInternal);

            component.set('v.dataArrayInternal', dataArrayInternal);
            helper.attachDND(component, event, helper);
            //helper.applySorting(component, event, helper);
            setTimeout(function(e){
                if (typeof $ !== 'undefined' &&
                    typeof $('.tablescroller') !== 'undefined' &&
                    typeof $('.tablescroller').find('div') !== 'undefined' &&
                    typeof $('.scrolledtable') !== 'undefined' &&
                    typeof $('.scrolledtable').find('table') !== 'undefined')
                {
                    console.log($('.scrolledtable').find('table').width());
                    $('.tablescroller').find('div').width($('.scrolledtable').find('table').width());

                }
            },100);


        }
    },
    applySorting : function (component, event, helper) {
        var dataArrayInternal = component.get('v.dataArrayInternal', dataArrayInternal);

        dataArrayInternal.sort(function(a,b) {
            return a.Name < b.Name ? -1 : 1;
        } );


        component.set('v.dataArrayInternal', dataArrayInternal);
        helper.attachDND(component, event, helper);
    },
    attachDND : function (component, event, helper) {
        setTimeout(function(e){

            if (typeof $('.ddrag').draggable !== 'undefined')
            $('.ddrag').draggable({
              helper: "clone",
              iframeFix: true,
                zIndex: 999,
              cursor: "move",
              cursorAt: { top: -12, left: -20 },
              helper: function( event )
              {
                  //console.log(event);
                  var name = $(event.target).data().name
                return $( "<div class='ui-widget-header'>" + name + "</div>" );
              }
            });
        }, 100);

    }
})