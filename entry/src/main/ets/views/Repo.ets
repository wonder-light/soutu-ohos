import { TitleBar } from '../component';

@Builder
export function buildRepo() {
  VRepo()
}

@Component({ freezeWhenInactive: true })
export struct VRepo {
  /**
   * 导航栈
   */
  @Consume('pageStack')
  pageStack: NavPathStack;
  @State
  message: string = 'Hello Repo';

  build() {
    NavDestination() {
      TitleBar({ title: $r('app.string.repo') })

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