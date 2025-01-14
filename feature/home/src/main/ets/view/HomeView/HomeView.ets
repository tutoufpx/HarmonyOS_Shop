//首页
import { BreakpointConstants, BreakPointType, CategoryItem, YGGoodsItem } from "basic"
import { DiscountGoodsComp, DiscountType } from "../../componnent/DiscountGoodsComp"
import { Banner, HotResult, Params } from "../../viewmodel"
import { YGGoods } from "../../componnent/YGGoods"
import {
  getBannerApi,
  getCategoryApi,
  getHotApi,
  getNewApi,
  getOneApi,
  getPreferenceApi,
  getRecommendApi
} from "../../api"


@Component
export struct HomeView {
  // 断点值
  @StorageProp(BreakpointConstants.BREAK_POINT_KEY)
  currentBreakpoint: string = BreakpointConstants.MD
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp("bottomHeight")
  bottomHeight: number = 0
  // 每个部分数据
  // 轮播图
  @State bannerList: Banner[] = []
  // 分类
  @State categories: CategoryItem[] = []
  // 特惠推荐
  @State saleGoodsList: YGGoodsItem[] = []
  // 爆款推荐
  @State hotGoodsList: YGGoodsItem[] = []
  // 一站买全
  @State oneGoodsList: YGGoodsItem[] = []
  // 新鲜好物
  @State newGoodsList: YGGoodsItem[] = []
  // 推荐商品
  @State recommendGoodsList: YGGoodsItem[] = []

  // 自定义
  @Builder
  DiscountBuilder(params: Params) {
    Column() {
      Row({ space: 10 }) {
        Text(params.title)
          .fontColor($r('[basic].color.black'))
          .fontSize(14)
        Text(params.subTitle)
          .fontColor($r('[basic].color.text'))
          .fontSize(11)
      }
      .width('100%')
      .margin({ bottom: 10 })

      List({ space: 10 }) {
        ForEach(params.list, (item: YGGoodsItem) => {
          ListItem() {
            DiscountGoodsComp({ type: DiscountType.DISCOUNT, goods: item })
          }
        })
      }
      .width('100%')
      .height(116)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }
    .height(160)
    .layoutWeight(1)
    .padding(10)
    .backgroundColor(params.bg)
    .borderRadius(8)
  }

  // 模拟数据
  mockData() {
    this.bannerList = new Array(6).fill({
      id: "42",
      imgUrl: "https://img1.baidu.com/it/u=2148799435,3416689533&fm=253&fmt=auto?w=607&h=405",
      hrefUrl: "/category/1181622006",
      type: "1"
    })

    this.categories = new Array(10).fill({
      id: "1181622001",
      name: "气质女装",
      picture: "https://img2.baidu.com/it/u=982409805,3816813331&fm=253&app=138&size=w931&n=0&f=JPEG&fmt=auto?sec=1736182800&t=3e10028bd81a47a43a02b8c7eb0317eb"
    })

    this.saleGoodsList = new Array(6).fill({
      "id": "1111002",
      "name": "剪出精致感，金致圆柄复古剪刀",
      "desc": "轻薄设计，简约大方",
      "price": "9.90",
      "picture": "https://img1.baidu.com/it/u=2654427060,739450640&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1736182800&t=97d9d04440920a044a1036eed5362a83",
      "orderNum": 172
    },)

    this.hotGoodsList = new Array(8).fill({
      "id": "1135059",
      "name": "手工八年老陈醋500毫升",
      "desc": "地道醇香，醋酸浓郁",
      "price": "30.00",
      "picture": "https://yanxuan-item.nosdn.127.net/77da20e77b02830a26f931901ac1a9e0.png",
      "orderNum": 147
    },)
    this.oneGoodsList = new Array(8).fill({
      "id": "1135079",
      "name": "免浸泡，12种谷物一次同享，五谷米400克",
      "desc": "无需浸泡，同煮同熟",
      "price": "9.90",
      "picture": "https://yanxuan-item.nosdn.127.net/bfe70bd66efe94f2f18061c707d2a097.png",
      "orderNum": 144
    })
    this.newGoodsList = new Array(8).fill({
      "id": "4027998",
      "name": "亮碟多效合一洗涤块495g",
      "desc": "洗碗机专用，强力去污",
      "price": "69.90",
      "picture": "https://yanxuan-item.nosdn.127.net/e07c2b63765cf9f4a46d489c6e09c1c1.jpg",
      "orderNum": 643
    })

    this.recommendGoodsList = new Array(8).fill({
      "id": "4033959",
      "name": "我可是真爱粉,谁都不可以黑我家鸽鸽",
      "price": "996",
      "picture": "https://i1.hdslb.com/bfs/archive/f35e6b328c4bdcf957c7b9b85602912afaeee651.jpg",
      "payCount": 1
    })
  }

  aboutToAppear() {
    this.getAllData()
  }

  // 获取接口的数据
  async getData() {
    // 获取轮播图数据
    const BanList = await getBannerApi()
    this.bannerList = BanList.data.result
    //   获取分类数据
    const categoryList = await getCategoryApi()
    this.categories = categoryList.data.result
    //   特惠推荐
    const PreferenceList = await getPreferenceApi()
    this.saleGoodsList = PreferenceList.data.result.subTypes[0].goodsItems.items
    //   爆款推荐
    const HotList = await getHotApi()
    this.hotGoodsList = HotList.data.result.subTypes[1].goodsItems.items

    //   一站买全
    const OneList = await getOneApi()
    this.oneGoodsList = OneList.data.result.subTypes[2].goodsItems.items
  }

  // 使用promise.allsettel来优化异步数据的获取
  async getAllData() {
    //   定义数组
    const allData =
      [getBannerApi(), getCategoryApi(), getPreferenceApi(), getHotApi(), getOneApi(), getNewApi(), getRecommendApi()]
    // allSettled 可以获取到每个请求状态成功或失败
    const resArr = await Promise.allSettled(allData)
    //   判断状态
    if (resArr[0].status == 'fulfilled') {
      this.bannerList = resArr[0].value.data.result as Banner[]
    }
    if (resArr[1].status == 'fulfilled') {
      this.categories = resArr[1].value.data.result as CategoryItem[]
    }
    if (resArr[2].status === 'fulfilled') {
      this.saleGoodsList = (resArr[2].value.data.result as HotResult).subTypes[0].goodsItems.items
    }
    if (resArr[3].status == 'fulfilled') {
      this.hotGoodsList = (resArr[3].value.data.result as HotResult).subTypes[1].goodsItems.items
    }
    if (resArr[4].status == 'fulfilled') {
      this.oneGoodsList = (resArr[4].value.data.result as HotResult).subTypes[2].goodsItems.items
    }
    if (resArr[5].status == 'fulfilled') {
      this.newGoodsList = resArr[5].value.data.result as YGGoodsItem[]
    }
    if (resArr[6].status == 'fulfilled') {
      this.recommendGoodsList = resArr[6].value.data.result as YGGoodsItem[]
    }
  }

  // 元素间隙
  getSpace(): number | undefined {
    return new BreakPointType({ sm: 14, md: 36, lg: 72 }).getValue(this.currentBreakpoint)
  }

  build() {
    Scroll() {
      Column() {
        // 轮播图+搜索
        Stack({ alignContent: Alignment.Top }) {
          //     轮播图
          Swiper() {
            ForEach(this.bannerList, (it: Banner) => {
              Image(it.imgUrl)
            })
          }
          .indicator(this.currentBreakpoint === BreakpointConstants.SM ? DotIndicator.dot()
            .itemWidth(8)
            .itemHeight(4)
            .color('#33191919')
            .selectedItemWidth(24)
            .selectedItemHeight(4)
            .selectedColor('#191919') : false
          )
          .displayCount(new BreakPointType({
            sm: 1,
            md: 2,
            lg: 3
          }).getValue(this.currentBreakpoint))
          .itemSpace(new BreakPointType({
            sm: 0,
            md: 10,
            lg: 20
          }).getValue(this.currentBreakpoint))

          //搜索
          Row() {
            Row({ space: 4 }) {
              Image($r('[basic].media.ic_public_search'))
                .width(16)
                .aspectRatio(1)
                .fillColor($r('[basic].color.white'))
              Text('搜索...')
                .fontSize(14)
                .fontColor($r('[basic].color.white'))
            }
            .backgroundColor('#33191919')
            .width('100%')
            .height(40)
            .borderRadius(20)
            .padding({ left: 12 })
          }
          .padding({ left: 16, right: 16, })
        }
        .width('100%')

        //   分类
        Column({ space: 10 }) {
          //   分类
          List({ space: this.getSpace() }) {
            ForEach(this.categories, (it: CategoryItem) => {
              ListItem() {
                Column() {
                  Image(it.picture)
                    .width(56)
                    .aspectRatio(1)
                  Text(it.name)
                    .fontSize(10)
                    .fontColor('#CC191919')
                }
                .width(60)
                .height(80)
                .borderRadius(30)
                .clip(true)
                .backgroundImage(it.picture)
                .backgroundImageSize(ImageSize.Contain)
                .backgroundImagePosition(Alignment.Center)
                .backgroundBlurStyle(BlurStyle.BACKGROUND_ULTRA_THICK, { scale: 0.25 })
              }
            })

          }
          .width('100%')
          .height(92)
          .scrollBar(BarState.Off)
          .listDirection(Axis.Horizontal)
          .alignListItem(ListItemAlign.Center)

          //   特惠推荐
          Column({ space: 10 }) {
            Image($r('app.media.home_cmd_title'))
              .width(150)
              .height(20)
            Row() {
              Image($r('app.media.home_cmd_inner'))
                .width(86)
                .height(116)
              List({ space: this.getSpace() }) {
                ForEach(this.saleGoodsList, (it: YGGoodsItem, i: number) => {
                  ListItem() {
                    DiscountGoodsComp({ goods: it })
                  }
                })
              }
              .layoutWeight(1)
              .width('100%')
              .height(116)
              .backgroundColor($r('[basic].color.white'))
              .borderRadius({ topRight: 8, bottomRight: 8 })
              .padding({ right: 10, left: 10 })
              .scrollBar(BarState.Off)
              .listDirection(Axis.Horizontal)
            }
          }
          .width('100%')
          .height(166)
          .backgroundImage($r('app.media.home_cmd_sm'))
          .backgroundImageSize(ImageSize.Cover)
          .borderRadius(8)
          .padding(10)
          .alignItems(HorizontalAlign.Start)

          //   商品爆款+一站买全
          Row() {
            this.DiscountBuilder({
              title: '商品爆款',
              subTitle: '最受欢迎',
              bg: '#EDF1F8',
              list: this.hotGoodsList
            })
            this.DiscountBuilder({
              title: '一站买全',
              subTitle: '买一送一',
              bg: '#F7F7F7',
              list: this.oneGoodsList
            })
          }

          //   新鲜好物
          Column({ space: 10 }) {
            Image($r('app.media.home_new'))
              .width(146)
              .height(19)
            List({ space: this.getSpace() }) {
              ForEach(this.newGoodsList, (it: YGGoodsItem, i: number) => {
                ListItem() {
                  DiscountGoodsComp({ type: DiscountType.NEW, goods: it })
                }
              })
            }
            .width('100%')
            .height(116)
            .scrollBar(BarState.Off)
            .listDirection(Axis.Horizontal)
          }
          .width('100%')
          .height(156)
          .padding(10)
          .backgroundColor('#F7EFF5')
          .borderRadius(8)
          .alignItems(HorizontalAlign.Start)

          //   推荐商品
          WaterFlow() {
            ForEach(this.recommendGoodsList, (it: YGGoodsItem) => {
              FlowItem() {
                YGGoods({ goods: it })
              }
            })
          }
          .columnsTemplate(new BreakPointType({
            sm: '1fr 1fr',
            md: '1fr 1fr 1fr',
            lg: '1fr 1fr 1fr 1fr'
          }).getValue(this.currentBreakpoint))
          .columnsGap(8)
          .rowsGap(10)

        }
        .padding({
          left: 8,
          right: 8,
          bottom: 10,
          top: 10
        })
      }
      .padding({
        top: this.topHeight,
      })
    }
    .scrollBar(BarState.Off)

  }
}
