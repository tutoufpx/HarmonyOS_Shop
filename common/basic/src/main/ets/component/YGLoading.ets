@Component
export struct YGLoading {
  LoadingWidth: number = 100

  build() {
    //   使用帧动画
    ImageAnimator()
      .images([
        { src: $r('app.media.loading_01') },
        { src: $r('app.media.loading_02') },
        { src: $r('app.media.loading_03') },
        { src: $r('app.media.loading_04') }
      ])
      .duration(199)
      .state(AnimationStatus.Running)
      .iterations(-1)
      .width(this.LoadingWidth)
      .height(this.LoadingWidth)
  }
}