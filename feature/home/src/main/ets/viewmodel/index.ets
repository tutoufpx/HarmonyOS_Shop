export interface YGGoodsItem {
  id: string
  name: string
  desc: string
  price: string
  picture: ResourceStr
  orderNum: number
}

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


export interface Params {
  title: string,
  subTitle: string,
  bg: ResourceStr,
  list: YGGoodsItem[]
}
