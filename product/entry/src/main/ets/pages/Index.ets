import { Logger, TabBarItem, BreakpointConstants, BreakPointType } from 'basic'

import { CartView } from 'cart/src/main/ets/views/CartView/CartView'
import { CategoryView } from 'category/src/main/ets/view/CategoryView/CategoryView'

import { HomeView } from 'home/src/main/ets/view/HomeView/HomeView'
import { MyHome } from 'my/src/main/ets/view/MyHome/MyHome'


@Entry
@Component
struct Index {
  bottomHeight: Length | LengthMetrics | undefined
  @StorageProp('currentBreakpoint') breakPoint: string = 'xs'
  @StorageProp('safeTop') safeTop: number = 0
  @StorageProp('safeBottom') safeBottom: number = 0
  //  当前的tab下标
  @State currentTabIndex: number = 0
  TabList: TabBarItem[] = [
    { text: '首页', img: $r('app.media.ic_public_home_normal'), selImg: $r('app.media.ic_public_home_active') },
    { text: '分类', img: $r('app.media.ic_public_pro_normal'), selImg: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', img: $r('app.media.ic_public_cart_normal'), selImg: $r('app.media.ic_public_cart_active') },
    { text: '我的', img: $r('app.media.ic_public_my_normal'), selImg: $r('app.media.ic_public_my_active') },]
  // 页面栈
  @Provide pageStack: NavPathStack = new NavPathStack()

  // 自定义导航栏
  @Builder
  tabBuilder(item: TabBarItem, index: number) {
    Column() {
      Image(this.currentTabIndex === index ? item.selImg : item.img)
        .width(24)
        .aspectRatio(1)

      Text(item.text)

        .fontSize(12)
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .height(50)
  }

  build() {

    Navigation(this.pageStack) {
      Tabs({
        barPosition: new BreakPointType({
          xs: BarPosition.End,
          sm: BarPosition.End,
          md: BarPosition.End,
          lg: BarPosition.Start
        }).getValue(this.breakPoint), index: $$this.currentTabIndex
      }) {
        ForEach(this.TabList, (item: TabBarItem, i: number) => {
          TabContent() {
            if (i === 0) {
              HomeView()
            } else if (i === 1) {
              CategoryView()
            } else if (i === 2) {
              CartView()
            } else if (i === 3) {
              MyHome()
            }

          }.tabBar(this.tabBuilder(item, i))
        })
      }
      .padding({ bottom: this.safeBottom })
      .scrollable(false)
      .barPosition(new BreakPointType({
        sm: BarPosition.End,
        md: BarPosition.End,
        lg: BarPosition.Start
      }).getValue(this.breakPoint))
      .vertical(this.breakPoint === BreakpointConstants.LG ? true : false)
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}