import { window } from "@kit.ArkUI"

@Builder
function SearchViewBuilder() {

  SearchView()
}


@Component
export struct SearchView {
  @StorageProp('safeTop') safeTop: number = 0
  @State keyWord: string = ''
  // 页面栈
  @Consume
  pageStack: NavPathStack

  aboutToAppear(): void {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({ statusBarContentColor: '#FFFFFF' })
      })
  }

  aboutToDisappear(): void {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({ statusBarContentColor: '#000000' })
      })
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Image($r('[basic].media.ic_public_left'))
            .width(24)
            .aspectRatio(1)
            .fillColor($r('[basic].color.white'))
            .margin(13)
            .onClick(() => {
              // TODO
            })


          //   搜索框
          Search({ placeholder: '你要搜索的商品是....', value: this.keyWord })
            .searchIcon({ src: $r('[basic].media.ic_public_search'), color: $r('[basic].color.gray') })
            .placeholderColor($r('[basic].color.gray'))
            .placeholderFont({ size: 14, weight: 400 })
            .searchButton('搜索', { fontSize: 14, fontColor: $r('[basic].color.red') })
            .backgroundColor($r('[basic].color.white'))
            .textFont({ size: 14 })
            .layoutWeight(1)
            .padding(0)
            .margin(0)
            .height(36)
            .caretStyle({ color: $r('[basic].color.red') })
            .defaultFocus(true)
            .onSubmit((value) => {
              //   TODO
            })

        }
        .padding({ top: this.safeTop, right: 16 })
        .linearGradient({
          angle: 135,
          colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
        })
      }
    }
    .hideTitleBar(true)
  }
}