# @todo add document click && offset position
describe('ngContextMenu', () ->
  $compile = null
  $rootScope = null
  element = null
  currentItem = {}

  lists = [
    {
      name: 'list1'
      value: 1
    }
    {
      name: 'list2'
      value: 2
    }
  ]

  clickMenu = (item) ->
    currentItem = item

  beforeEach(() ->
    module('ngContextMenu')
    inject(($injector) ->
      $compile = $injector.get('$compile')
      $rootScope = $injector.get('$rootScope')
    )
  )

  describe('render', () ->
    beforeEach(() ->
      $rootScope.lists = lists
      element = $($compile('<div contextmenu menu-list="lists"></div>')($rootScope))
      $rootScope.$digest()
    )

    it 'should create dropdown-menu', () ->
      expect(element.find('.ng-context-menu').length).toEqual(1)

    it 'should create two item', () ->
      expect(element.find('.dropdown-menu > li').length).toEqual(2)
  )

  describe('render with no list', () ->
    beforeEach(() ->
      element = $($compile('<div contextmenu></div>')($rootScope))
      $rootScope.$digest()
    )
    
    it 'should no list', () ->
      expect(element.find('.dropdown-menu > li').length).toEqual(0)
  )

  describe('rightClick', () ->
    beforeEach(() ->
      $rootScope.lists = lists
      $rootScope.rightClick = jasmine.createSpy('rightClick')
      element = $($compile('<div contextmenu menu-list="lists" right-click="rightClick($event)"></div>')($rootScope))
      $rootScope.$digest()
    )

    it 'should show drop-menu with element right click', (done) ->
      element.contextmenu()

      setTimeout () ->
        expect(element.find('.ng-context-menu').hasClass('open')).toBe(true)
        done()
      , 5

    it 'should call right click', (done) ->
      element.contextmenu()
      setTimeout () ->
        expect($rootScope.rightClick).toHaveBeenCalled()
        done()
      , 5
  )

  describe('clickItem', () ->
    beforeEach(() ->
      $rootScope.lists = lists
      $rootScope.clickMenu = clickMenu
      element = $($compile('<div contextmenu menu-list="lists" click-menu="clickMenu(item)"></div>')($rootScope))
      $rootScope.$digest()
    )

    it 'should hide dropmenu with item click', () ->
      element.contextmenu()
      element.find('.dropdown-menu li').eq(1).click()

      expect(currentItem.value).toEqual(2)
      currentItem = {}
  )

  describe('position', () ->
    beforeEach(() ->
      $rootScope.lists = lists
      element = $compile('<div contextmenu></div>')($rootScope)
      element.css({
        top: 0
        left: 0
      })
      $rootScope.$digest()
    )

    it 'should show fixed position', (done) ->
      element.find('.ng-context-menu').trigger({
        type: 'contextmenu'
        clientX: 100
        clientY: 200
      })

      setTimeout () ->
        expect(element.find('.ng-context-menu').css('top')).toEqual('200px')
        expect(element.find('.ng-context-menu').css('left')).toEqual('100px')
        done()
      , 5

    it 'should show position use offsetLeft and offsetTop', (done) ->
      element.find('.ng-context-menu').css({
        top: 'auto'
        left: 0
      })

      element.find('.ng-context-menu')[0].style.left = 'auto'

      element.find('.ng-context-menu').trigger({
        type: 'contextmenu'
        clientX: 100
        clientY: 200
      })

      setTimeout () ->
        expect(element.find('.ng-context-menu').css('top')).toEqual('200px')
        expect(element.find('.ng-context-menu').css('left')).toEqual('100px')
        done()
      , 5

  )

  describe('hideCallback', () ->
    beforeEach(() ->
      $rootScope.hide = jasmine.createSpy('hide')
      element = $compile('<div contextmenu on-menu-close="hide()"></div>')($rootScope)
      $rootScope.$digest()
    )

    it 'should call hide function', (done) ->
      element.find('.ng-context-menu').trigger({
        type: 'contextmenu'
      })

      setTimeout () ->
        $(document).trigger({
          type: 'click'
          button: 0
        })

        expect($rootScope.hide).toHaveBeenCalled()
        done()
      , 5
  )

  describe('menu options', () ->
    beforeEach(() ->
      $rootScope.lists = [{
        label: 'item1'
      }, {
        label: 'item2'
      }]
      $rootScope.options = {
        itemLabel: 'label'
        isMultiple: false
      }
      element = $($compile('<div contextmenu menu-list="lists" options="options"></div>')($rootScope))
      $rootScope.$digest()
    )
    it 'should change label name', () ->
      expect(element.find('.dropdown-menu li a').eq(0).text()).toEqual('item1')
      expect(element.find('.dropdown-menu li a').eq(1).text()).toEqual('item2')

    it 'should hide if dropmenu is open with dropmenu right click', (done) ->
      element.find('.ng-context-menu').trigger({
        type: 'contextmenu'
      })

      setTimeout () ->
        expect(element.find('.ng-context-menu').hasClass('open')).toBe(true)
        $(document).trigger({
          type: 'contextmenu'
        })
        expect(element.find('.ng-context-menu').hasClass('open')).toBe(false)
        done()
      , 5
  )

  describe('menu align', () ->
    beforeEach () ->
      $rootScope.lists = [{
        label: 'item1'
      }, {
        label: 'item2'
      }]

    describe('left top', () ->
      element = null
      beforeEach () ->
        element = $($compile('<div contextmenu menu-list="lists" align="rt"></div>')($rootScope))
        element.find('.ng-context-menu')[0].width = 50
        $rootScope.$digest()

      it 'should align in position left top', (done) ->
        element.find('.ng-context-menu').trigger({
          type: 'contextmenu'
          clientX: 100
          clientY: 200
        })
        setTimeout () ->
          console.log element.find('.ng-context-menu').css('top')
          console.log element.find('.ng-context-menu').css('left')
          done()
        , 500
    )
  )
)
