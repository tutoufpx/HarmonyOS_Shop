import { BreakpointConstants, CategoryItem, CategoryItemChild, YGNavbar } from "basic"

//分类
@Component
export struct CategoryView {
  // 分类数据
  @StorageProp('categoryList')
  categoryList: CategoryItem[] = []
  @StorageProp(BreakpointConstants.BREAK_POINT_KEY)
  currentBreakpoint: string = BreakpointConstants.SM
  // 当前的下标
  @State currentIndex: number = 0
  // 页面栈
  @Consume
  pageStack: NavPathStack

  build() {
    Column() {
      YGNavbar({
        title: '分类',
        showLeftIcon: false,
        showRightIcon: true,
        rightIcon: $r('app.media.ic_public_search'),
        rightClickHandler: () => {
          this.pageStack.pushPathByName('SearchView', null)
        }
      })
        .border({ width: { bottom: 0.5 }, color: '#F5F4F9' })


      Row() {
        Column() {
          ForEach(this.categoryList, (it: CategoryItem, i: number) => {
            Text(it.name)
              .fontSize(14)
              .fontColor(this.currentIndex === i ? $r('[basic].color.white') : $r('[basic].color.black'))
              .height(56)
              .width('100%')
              .backgroundColor(this.currentIndex === i ? $r('[basic].color.black') : $r('[basic].color.white'))
              .textAlign(TextAlign.Center)
              .onClick(() => {
                this.currentIndex = i
                // console.log('1', i)
              })
          })
        }
        .width(88)
        .border({
          width: { right: 0.5 },
          color: $r('[basic].color.under')
        })

        Scroll() {
          Column() {
            Image(this.categoryList[this.currentIndex].picture)
              .width('100%')
              .height(136)
              .margin({ bottom: 8 })
              .borderRadius(8)
              .backgroundColor('#f6f6f6')
              .objectFit(ImageFit.Contain)
              .height(this.currentBreakpoint === BreakpointConstants.SM ? 136 : 316)
            //   子分类
            GridRow({ columns: { sm: 2, md: 3, lg: 4 }, gutter: 8 }) {
              ForEach(this.categoryList[this.currentIndex].children, (subit: CategoryItemChild, i: number) => {

                GridCol() {
                  Column() {
                    Image(subit.picture)
                      .width(64)
                      .aspectRatio(1)
                    Text(subit.name)
                      .fontSize(14)
                      .fontColor($r('[basic].color.text'))
                      .margin({ top: 8 })
                  }
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .aspectRatio(1)
                .backgroundColor('#f6f6f6')
                .borderRadius(8)
              })

            }
          }
          .padding(8)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .height('100%')
  }
}