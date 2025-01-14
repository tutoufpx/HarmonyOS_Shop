import { RequestAxios } from "basic"
import { Banner, CategoryItem, HotResult, YGGoodsItem } from "../viewmodel"

//获取轮播图
export const getBannerApi = () => {
  return RequestAxios.get<Banner[]>('/home/banner')
}

// 获取分类数据
export const getCategoryApi = () => {
  return RequestAxios.get<CategoryItem[]>('/home/category/head')
}

// 获取特惠推荐数据
export const getPreferenceApi = () => {
  return RequestAxios.get<HotResult>('/hot/preference')
}

//获取 爆款推荐数据
export const getHotApi = () => {
  return RequestAxios.get<HotResult>('/hot/inVogue')
}

//获取 一战买全数据
export const getOneApi = () => {
  return RequestAxios.get<HotResult>('/hot/oneStop')
}

//获取新鲜好物数据
export const getNewApi = () => {
  return RequestAxios.get<YGGoodsItem[]>('/home/new')
}

//获取推荐数据
export const getRecommendApi = (limit: number = 8) => {
  return RequestAxios.get<YGGoodsItem[]>('/home/recommend', { params: { limit } })
}