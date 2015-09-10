angular.module 'ngContextMenu', []

.directive 'contextmenu', ['$compile', '$document', ($compile, $document) ->
  defaults = (obj, prop, value) ->
    if not obj[prop] and not (typeof obj[prop] is 'boolean')
      obj[prop] = value

  return {
    restrict: 'A'
    scope:
      menuList: '='
      clickMenu: '&'
      rightClick: '&'
      onMenuClose: '&'
      options: '=?'
      align: '@'
    link: (scope, element, attrs) ->
      template = '
        <div class="ng-context-menu">
          <ul class="dropdown-menu" role="menu">
            <li ng-click="clickItem(item, $event)" ng-repeat="item in menu">
              <hr ng-if="item.type==\'hr\'"  />
              <a href="javascript:void(0)" ng-if="item.type!=\'hr\'">{{item[options.itemLabel]}}</a>
            </li>
          </ul>
        </div>
      '

      scope.options = scope.options or {}
      defaults(scope.options, 'itemLabel', 'name')
      defaults(scope.options, 'isMultiple', true)

      scope.menu = scope.menuList

      scope.dropmenu = dropmenu = $compile(template)(scope)
      element.append(dropmenu)

      element.bind 'contextmenu', (event) ->
        event.preventDefault()
        # event.stopPropagation()

        setTimeout () ->
          if scope.rightClick
            scope.rightClick({
              $event: event
            })

          dropmenu.addClass('open')

          dropmenuHeight = dropmenu[0].offsetHeight
          dropmenuWidth  = dropmenu[0].offsetWidth

          scope.align = scope.align or 'lt'
          switch(scope.align)
            when 'lt'
              top = event.clientY
              left = event.clientX
            when 'lb'
              top = event.clientY - dropmenuHeight
              left = event.clientX
            when 'rt'
              top = event.clientY
              left = event.clientX - dropmenuWidth
            when 'rb'
              top = event.clientY - dropmenuHeight
              left = event.clientX - dropmenuWidth

          offset(dropmenu, {
            top: top
            left: left
          })

        , 0
        
      $document.bind 'contextmenu', (event) ->
        if not scope.options.isMultiple
          if dropmenu.hasClass('open')
            hideMenu()

      $document.bind 'click', (event) ->
        if event.button is 0 and dropmenu.hasClass('open')
          # dropmenu.removeClass('open')
          hideMenu()
          if scope.onMenuClose
            scope.onMenuClose()

      scope.clickItem = (item, event) ->
        if scope.clickMenu
          scope.clickMenu({
            item: item
            $event: event
          })

      hideMenu = () ->
        dropmenu.css({
          top: 0
          left: 0
        })
        dropmenu.removeClass('open')

      # set offset or get offset
      offset = (elem, options) ->
        curElem = elem[0]

        if options
          curCssTop = curElem.style.top or getComputedStyle(curElem)['top']
          curCssLeft = curElem.style.left or getComputedStyle(curElem)['left']
          curOffset = offset(elem)
          scrollLeft = window.pageXOffset or curElem.scrollLeft
          scrollTop = window.pageYOffset or curElem.scrollTop

          if (curCssTop + curCssLeft).indexOf('auto') > -1
            curTop = curElem.offsetTop
            curLeft = curElem.offsetLeft
          else
            curTop = parseFloat(curCssTop) or 0
            curLeft = parseFloat(curCssLeft) or 0

          left = scrollLeft + options.left - curOffset.left + curLeft
          top = scrollTop + options.top - curOffset.top + curTop

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
