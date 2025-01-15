import { CategoryItem, CategoryItemChild } from "basic"
import image from "@ohos.multimedia.image"

//分类
@Component
export struct CategoryView {
  // 分类数据
  @StorageProp('categoryList')
  categoryList: CategoryItem[] = []
  // 当前的下标
  @State currentIndex: number = 0

  build() {
    Column() {
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
            Image('https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c1/qznz.png')
              .width('100%')
              .height(136)
              .margin({ bottom: 8 })
              .borderRadius(8)
              .backgroundColor('#f6f6f6')
              .objectFit(ImageFit.Contain)
            //   子分类
            GridRow({ columns: 2, gutter: 8 }) {
              ForEach(Array.from({ length: 10 }), (subit: CategoryItemChild, i: number) => {

                GridCol() {
                  Column() {
                    Image('https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meikou/c2/qznz_bq.png?quality=95&imageView')
                      .width(64)
                      .aspectRatio(1)
                    Text('半裙')
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