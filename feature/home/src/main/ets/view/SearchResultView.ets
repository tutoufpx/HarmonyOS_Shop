import { YGGoodsItem, YGPullToRefresh } from "basic"
import { getSearchGoodsApi } from "../api"
import { YGGoods } from "../componnent/YGGoods"
import { promptAction } from "@kit.ArkUI"
import { GoodsItemsDataSource } from "../viewmodel"


// 联合类型
export type SortField = 'publishTime' | 'orderNum' | 'price'

export type SortMethod = 'desc' | 'asc'

// 提交给服务器的参数
export interface SearchParams {
  keyword: string
  sortField: SortField
  sortMethod: SortMethod
  page: number
  pageSize: number
}

// 筛选条件
export interface SortCompAttr {
  field: SortField
  label: string
}


// 路由参数
interface RouterParam {
  keyword: string
}

@Builder
function SearchResultViewBuilder() {
  SearchResultView()
}

@Component
export struct SearchResultView {
  // 顶部安全区域
  @StorageProp('safeTop') safeTop: number = 0
  // mock 数据
  @State data: YGGoodsItem[] = new Array(8).fill({
    "id": "4033959",
    "name": "3秒快速拆琴轻松保养odin奥丁12半音阶口琴",
    "price": 329,
    "picture": "https://yanxuan-item.nosdn.127.net/937a8e46a9284e8f7e00e13911ecfbe7.png",
    "payCount": 0
  })
  // 懒加载的数据
  @State LazyData: GoodsItemsDataSource = new GoodsItemsDataSource()
  // 查询参数
  @State
  @Watch('paramsChange')
  params: SearchParams =
    {
      keyword: '',
      sortField: 'publishTime',
      sortMethod: 'desc',
      page: 1,
      pageSize: 10
    }
  // 筛选条件
  sortList: SortCompAttr[] = [
    { label: '时间', field: 'publishTime' },
    { label: '销量', field: 'orderNum' },
    { label: '价格', field: 'price' }
  ]
  // 控制器
  scroller = new Scroller()
  @Consume
  pageStack: NavPathStack
  page: number = 1

  aboutToAppear(): void {
    // TODO 解析参数
    this.params.keyword = this.pageStack.getParamByName('SearchResultView')[0] as string
    // TODO 获取查询数据
    this.getSearchData()
  }

  paramsChange() {
  }

  //获取查询的数据
  async getSearchData() {
    const res = await getSearchGoodsApi(this.params)
    this.data = res.data.result.pageData.items
    // 懒加载数据
    this.LazyData.reloadData(res.data.result.pageData.items)
    this.page = res.data.result.pageData.pages
  }

  //将瀑布流抽取成组件,方便后续使用
  @Builder
  WaterFlowBuilder() {
    WaterFlow({ scroller: this.scroller }) {
      ForEach(this.data, (item: YGGoodsItem) => {
        FlowItem() {
          YGGoods({ goods: item, smallImage: true })
        }
      })
    }
    .columnsTemplate("1fr 1fr")
    .columnsGap(0.5)
    .rowsGap(0.5)
  }

  build() {
    NavDestination() {

      Column() {
        // 搜索区域
        Row() {
          Image($r('[basic].media.ic_public_left'))
            .width(24)
            .aspectRatio(1)
            .fillColor($r('[basic].color.white'))
            .margin(13)
            .onClick(() => {
              this.pageStack.pop()
            })
          Search({ placeholder: '商品关键字...', value: this.params.keyword })
            .searchIcon({ src: $r('[basic].media.ic_public_search'), color: $r('[basic].color.gray') })
            .placeholderColor($r('[basic].color.gray'))
            .placeholderFont({ size: 14 })
            .backgroundColor($r('[basic].color.white'))
            .textFont({ size: 14 })
            .layoutWeight(1)
            .padding(0)
            .margin(0)
            .height(36)
            .caretStyle({ color: $r('[basic].color.red') })
            .onSubmit((value) => {
              this.params.keyword = value
              this.getSearchData()
            })
        }
        .padding({ top: this.safeTop, right: 16 })
        .linearGradient({
          angle: 135,
          colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
        })

        // list
        Row() {
          ForEach(this.sortList, (item: SortCompAttr) => {
            // 筛选组件
            SortItemComp({
              label: item.label,
              field: item.field,
              sortField: this.params.sortField,
              sortMethod: this.params.sortMethod,
              ClickChange: (sortFiled: SortField, sortMethod: SortMethod) => {
                this.params.sortField = sortFiled
                this.params.sortMethod = sortMethod
                this.getSearchData()
              }

            })
          })
          Text('筛选')
            .fontSize(14)
            .fontColor($r('[basic].color.gray'))
        }
        .padding({ left: 16, right: 16 })
        .height(50)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .border({ width: { bottom: 0.5 }, color: $r('[basic].color.border') })

        YGPullToRefresh({
          data: $LazyData,
          scroller: this.scroller,
          customList: () => {
            this.WaterFlowBuilder()
          },
          //下拉刷新
          onRefresh: async () => {
            this.LazyData.reloadData([])
            this.params.page = 1
            await this.getSearchData()
            return '下拉刷新成功'
          },
          //触底加载

          onLoadMore: async () => {
            // 如果还有数据就继续加载数据,没有的就提示用户没有数据
            if (this.params.page < this.page) {
              this.params.page++
              const res = await getSearchGoodsApi(this.params)
              //使用懒加载的数据  将数据拼接在最后
              res.data.result.pageData.items.forEach((data) => {
                this.LazyData.pushData(data)
              })

              return '加载成功'

            } else {
              promptAction.showToast({
                message: '没有更多数据了~~'
              })

            }
            return '没有更多数据了~~'
          }
        })

      }
    }
    .hideTitleBar(true)
  }
}

@Component
struct SortItemComp {
  // 筛选字段
  field: SortField = 'publishTime'
  // 显示的文本
  label: string = ''
  // 状态变量，接收父组件的状态属性
  // 父组件的筛选字段
  @Prop sortField: SortField = 'publishTime'
  // 父组件的排序方法
  @Prop sortMethod: SortMethod = 'desc'
  // TODO 点击筛选条件，回传  sortField 和 sortMethod 给父组件（回调函数）
  // 这是一个回调函数,可以传递给父组件,然后点击可以实现切换排序效果
  ClickChange = (sortFiled: SortField, sortMethod: SortMethod) => {
  }

  build() {
    Row() {
      Text(this.label)
        .fontWeight(500)
        .fontSize(14)
        .fontColor(this.sortField === this.field ? $r('[basic].color.black') : $r('[basic].color.gray'))
      Column() {
        Image($r('[basic].media.ic_public_up'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'asc' ? $r('[basic].color.black') :
          $r('[basic].color.gray'))
        Image($r('[basic].media.ic_public_down'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'desc' ? $r('[basic].color.black') :
          $r('[basic].color.gray'))
      }
      .justifyContent(FlexAlign.Center)
    }
    .onClick(() => {
      //点击实现排序方法的切换
      if (this.field == this.sortField) {
        this.ClickChange(this.field, this.sortMethod === 'desc' ? 'asc' : 'desc')
      } else {
        this.ClickChange(this.field, 'desc')
      }
    })
  }
}