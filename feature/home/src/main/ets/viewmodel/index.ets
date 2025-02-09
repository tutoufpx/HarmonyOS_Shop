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

export interface SearchResult {
  pageData: GoodsItems
}


export interface Params {
  title: string,
  subTitle: string,
  bg: ResourceStr,
  list: YGGoodsItem[]
}

// 懒加载数据
// BasicDataSource实现了IDataSource接口，用于管理listener监听，以及通知LazyForEach数据更新
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: object[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): object {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.ADD, index: index}]);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.CHANGE, index: index}]);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.DELETE, index: index}]);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
      // 写法2：listener.onDatasetChange(
      //         [{type: DataOperationType.EXCHANGE, index: {start: from, end: to}}]);
    })
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }
}

export class GoodsItemsDataSource extends BasicDataSource {
  private dataArray: object[] = []

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): object {
    return this.dataArray[index]
  }

  //   添加数据
  public addData(index: number, data: object): void {
    this.dataArray.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  //   push 数据
  public pushData(data: object): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1)
  }

  //  删除数据
  public deleteData(index: number, data: object): void {
    if (index >= 0 && index < this.dataArray.length) {
      this.dataArray.splice(index, 1)
      this.notifyDataDelete(index)
    }
  }

  //   数据重新赋值
  public reloadData(data: object[]) {
    this.dataArray = data;
    this.notifyDataReload();


  }
}
