import { TitleBar } from '../component';

@Builder
export function buildSetting() {
  VSetting()
}

@Component({ freezeWhenInactive: true })
export struct VSetting {
  /**
   * 导航栈
   */
  @Consume('pageStack')
  pageStack: NavPathStack;
  @State
  message: string = 'Hello Setting';

  build() {
    NavDestination() {
      TitleBar({ title: $r("app.string.soutu") })

      RelativeContainer() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.message = 'Welcome';
          })
      }
      .height('100%')
      .width('100%')
    }
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}