export interface YGGoodsItem {
  id: string
  name: string
  desc: string
  price: string
  picture: ResourceStr
  orderNum: number
}

// 分类数据
export interface CategoryItem {
  children?: CategoryItemChild[]
  goods?: YGGoodsItem[]
  id: string
  name: string
  picture: ResourceStr
}

export interface CategoryItemChild {
  id: string
  name: string
  picture: ResourceStr
}

// 轮播图
export interface Banner {
  id: string;
  imgUrl: string;
  type: string;
}

// 特惠推荐  一站买全  爆款推荐 数据
export interface HotResult {
  id: string,
  title: string,
  subTypes: SubType[]
}

export interface SubType {
  id: string,
  title: string,
  goodsItems: GoodsItems;
}

export interface GoodsItems {
  counts: number;
  pageSize: number;
  pages: number;
  page: number;
  items: YGGoodsItem[]

}


export interface Params {
  title: string,
  subTitle: string,
  bg: ResourceStr,
  list: YGGoodsItem[]
}
