(function() {
  angular.module('ngContextMenu', []).directive('contextmenu', [
    '$compile', '$document', function($compile, $document) {
      var defaults;
      defaults = function(obj, prop, value) {
        if (!obj[prop] && !(typeof obj[prop] === 'boolean')) {
          return obj[prop] = value;
        }
      };
      return {
        restrict: 'A',
        scope: {
          menuList: '=',
          clickMenu: '&',
          rightClick: '&',
          onMenuClose: '&',
          options: '=?',
          align: '@'
        },
        link: function(scope, element, attrs) {
          var dropmenu, hideMenu, offset, template;
          template = '<div class="ng-context-menu"> <ul class="dropdown-menu" role="menu"> <li ng-click="clickItem(item, $event)" ng-repeat="item in menu"> <hr ng-if="item.type==\'hr\'"  /> <a href="javascript:void(0)" ng-if="item.type!=\'hr\'">{{item[options.itemLabel]}}</a> </li> </ul> </div>';
          scope.options = scope.options || {};
          defaults(scope.options, 'itemLabel', 'name');
          defaults(scope.options, 'isMultiple', true);
          scope.menu = scope.menuList;
          scope.dropmenu = dropmenu = $compile(template)(scope);
          element.append(dropmenu);
          element.bind('contextmenu', function(event) {
            event.preventDefault();
            return setTimeout(function() {
              var dropmenuHeight, dropmenuWidth, left, top;
              if (scope.rightClick) {
                scope.rightClick({
                  $event: event
                });
              }
              dropmenu.addClass('open');
              dropmenuHeight = dropmenu[0].offsetHeight;
              dropmenuWidth = dropmenu[0].offsetWidth;
              scope.align = scope.align || 'lt';
              switch (scope.align) {
                case 'lt':
                  top = event.clientY;
                  left = event.clientX;
                  break;
                case 'lb':
                  top = event.clientY - dropmenuHeight;
                  left = event.clientX;
                  break;
                case 'rt':
                  top = event.clientY;
                  left = event.clientX - dropmenuWidth;
                  break;
                case 'rb':
                  top = event.clientY - dropmenuHeight;
                  left = event.clientX - dropmenuWidth;
              }
              return offset(dropmenu, {
                top: top,
                left: left
              });
            }, 0);
          });
          $document.bind('contextmenu', function(event) {
            if (!scope.options.isMultiple) {
              if (dropmenu.hasClass('open')) {
                return hideMenu();
              }
            }
          });
          $document.bind('click', function(event) {
            if (event.button === 0 && dropmenu.hasClass('open')) {
              hideMenu();
              if (scope.onMenuClose) {
                return scope.onMenuClose();
              }
            }
          });
          scope.clickItem = function(item, event) {
            if (scope.clickMenu) {
              return scope.clickMenu({
                item: item,
                $event: event
              });
            }
          };
          hideMenu = function() {
            dropmenu.css({
              top: 0,
              left: 0
            });
            return dropmenu.removeClass('open');
          };
          return offset = function(elem, options) {
            var curCssLeft, curCssTop, curElem, curLeft, curOffset, curTop, left, rect, scrollLeft, scrollTop, top;
            curElem = elem[0];
            if (options) {
              curCssTop = curElem.style.top || getComputedStyle(curElem)['top'];
              curCssLeft = curElem.style.left || getComputedStyle(curElem)['left'];
              curOffset = offset(elem);
              scrollLeft = window.pageXOffset || curElem.scrollLeft;
              scrollTop = window.pageYOffset || curElem.scrollTop;
              if ((curCssTop + curCssLeft).indexOf('auto') > -1) {
                curTop = curElem.offsetTop;
                curLeft = curElem.offsetLeft;
              } else {
                curTop = parseFloat(curCssTop) || 0;
                curLeft = parseFloat(curCssLeft) || 0;
              }
              left = scrollLeft + options.left - curOffset.left + curLeft;
              top = scrollTop + options.top - curOffset.top + curTop;
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
