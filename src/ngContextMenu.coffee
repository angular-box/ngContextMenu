angular.module 'ngContextMenu', []

.directive 'contextmenu', ['$compile', '$document', ($compile, $document) ->
  return {
    restrict: 'A'
    scope:
      menuList: '='
      clickMenu: '&'
      rightClick: '&'
      onMenuClose: '&'
    link: (scope, element, attrs) ->
      template = '
        <div class="ng-context-menu">
          <ul class="dropdown-menu" role="menu">
            <li ng-click="clickItem(item, $event)" ng-repeat="item in menu">
              <a href="#">{{item.name}}</a>
            </li>
          </ul>
        </div>
      '

      scope.menu = scope.menuList

      scope.dropmenu = dropmenu = $compile(template)(scope)
      element.append(dropmenu)

      element.bind 'contextmenu', (event) ->
        event.preventDefault()
        event.stopPropagation()

        dropmenu.addClass('open')
        
        offset(dropmenu, {
          top: event.clientY
          left: event.clientX
        })

        if scope.rightClick
          scope.rightClick({
            $event: event
          })

      $document.bind 'click', (event) ->
        if event.button is 0 and dropmenu.hasClass('open')
          dropmenu.removeClass('open')
          if scope.onMenuClose
            scope.onMenuClose()

      scope.clickItem = (item, event) ->
        if scope.clickMenu
          scope.clickMenu({
            item: item
            $event: event
          })

      # set offset or get offset
      offset = (elem, options) ->
        curElem = elem[0]

        if options
          curCssTop = curElem.style.top or getComputedStyle(curElem)['top']
          curCssLeft = curElem.style.left or getComputedStyle(curElem)['left']
          curOffset = offset(elem)

          if (curCssTop + curCssLeft).indexOf('auto') > -1
            curTop = curElem.offsetTop
            curLeft = curElem.offsetLeft
          else
            curTop = parseFloat(curCssTop) or 0
            curLeft = parseFloat(curCssLeft) or 0

          console.log curElem.offsetTop

          left = options.left - curOffset.left + curLeft
          top = options.top - curOffset.top + curTop

          elem.css({
            top: top + 'px'
            left: left + 'px'
          })

          return

        rect = curElem.getBoundingClientRect()

        return {
          top: rect.top + document.body.scrollTop
          left: rect.left + document.body.scrollLeft
        }
  }
]
