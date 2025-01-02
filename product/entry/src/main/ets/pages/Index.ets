import { TabBarItem } from 'basic'

@Entry
@Component
struct Index {
  //  当前的tab下标
  @State currentTabIndex: number = 0
  Tablist: TabBarItem[] = [
    { text: '首页', img: $r('app.media.ic_public_home_normal'), selImg: $r('app.media.ic_public_home_active') },
    { text: '分类', img: $r('app.media.ic_public_pro_normal'), selImg: $r('app.media.ic_public_pro_active') },
    { text: '购物袋', img: $r('app.media.ic_public_cart_normal'), selImg: $r('app.media.ic_public_cart_active') },
    { text: '我的', img: $r('app.media.ic_public_my_normal'), selImg: $r('app.media.ic_public_my_active') },]

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
    Tabs({ barPosition: BarPosition.End, index: $$this.currentTabIndex }) {
      ForEach(this.Tablist, (item: TabBarItem, i: number) => {
        TabContent() {

        }.tabBar(this.tabBuilder(item, i))
      })

    }
    .scrollable(false)
  }
}