(function() {
  angular.module('ngContextMenu', []).directive('contextmenu', [
    '$compile', '$document', function($compile, $document) {
      return {
        restrict: 'A',
        scope: {
          clickMenu: '&',
          rightClick: '&'
        },
        link: function(scope, element, attrs) {
          var dropmenu, offset, template;
          template = '<div class="ng-context-menu"> <ul class="dropdown-menu" role="menu"> <li ng-click="clickItem(item, $event)" ng-repeat="item in menu"> <a href="#">{{item.name}}</a> </li> </ul> </div>';
          if (attrs['contextmenu']) {
            scope.menu = angular.fromJson(attrs['contextmenu']) || [];
          } else {
            scope.menu = [];
          }
          scope.dropmenu = dropmenu = $compile(template)(scope);
          element.append(dropmenu);
          element.bind('contextmenu', function(event) {
            event.preventDefault();
            event.stopPropagation();
            dropmenu.addClass('open');
            offset(dropmenu, {
              top: event.clientY,
              left: event.clientX
            });
            if (scope.rightClick) {
              return scope.rightClick({
                $event: event
              });
            }
          });
          $document.bind('click', function() {
            return dropmenu.removeClass('open');
          });
          scope.clickItem = function(item, event) {
            if (scope.clickMenu) {
              return scope.clickMenu({
                item: item,
                $event: event
              });
            }
          };
          return offset = function(elem, options) {
            var curCssLeft, curCssTop, curElem, curLeft, curOffset, curTop, left, rect, top;
            curElem = elem[0];
            if (options) {
              curCssTop = getComputedStyle(curElem)['top'];
              curCssLeft = getComputedStyle(curElem)['left'];
              curOffset = offset(elem);
              if ((curCssTop + curCssLeft).indexOf('auto') > -1) {
                curTop = curElem.offsetTop;
                curLeft = curElem.offsetLeft;
              } else {
                curTop = parseFloat(curCssTop) || 0;
                curLeft = parseFloat(curCssLeft) || 0;
              }
              left = options.left - curOffset.left + curLeft;
              top = options.top - curOffset.top + curTop;
              elem.css({
                top: top + 'px',
                left: left + 'px'
              });
              return;
            }
            rect = curElem.getBoundingClientRect();
            return {
              top: rect.top + document.body.scrollTop,
              left: rect.left + document.body.scrollLeft
            };
          };
        }
      };
    }
  ]);

}).call(this);
