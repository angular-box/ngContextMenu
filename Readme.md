# ngContextMenu

right menu
[demo](http://angular-box.github.io/ngContextMenu
)

[![Build Status][travis-image]][travis-url]
[![Test Coverage][coveralls-image]][coveralls-url]

## Install

`
bower install ngcontextmenu --save
`

## Usage

* html

```
<div contextmenu menu-list="lists" click-menu="clickMenu(item)">
  <span>111</span>
</div>
```

* js

```
$scope.lists = [{
  name: '11'
}, {
  name: '22'
}]

$scope.clickMenu = function (item) {
  console.log(item);
};
```

You can add options config

```
$scope.options = {
  isMultiple: false,
  itemLabel: 'label'
}
```

### align

add align position

```
<div contextmenu menu-list="lists" class="box" align="rb"></div>
```

* lt left top(default)
* lb left bottom
* rt right top
* rb right bottom

## Pull Request

```
git clone git@github.com:angular-box/ngContextMenu.git
cd ngContextMenu
npm install
bower install

# run serve
gulp serve
```

## Test

```
gulp test
```

## Todo

* Add animation
* Add nest menu
* Add disabled menu

[travis-image]: https://travis-ci.org/angular-box/ngContextMenu.svg
[travis-url]: https://travis-ci.org/angular-box/ngContextMenu
[coveralls-image]: https://img.shields.io/coveralls/angular-box/ngContextMenu.svg?style=flat
[coveralls-url]: https://coveralls.io/r/angular-box/ngContextMenu?branch=master

