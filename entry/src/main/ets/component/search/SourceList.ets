import { LengthMetrics } from '@kit.ArkUI';
import { ImagePreviewController } from '@rv/image-preview';
import { UDataSource } from '../../common/Data';
import { SearchResultItem } from '../../models/Result';
import { ImageCom, ImageDialog } from '../index';

/** 数据回调函数, 用于添加数据 */
export type TItemCallback = Callback<SearchResultItem | SearchResultItem[]>;

/** 数据生成函数, 用于生成数据 */
export type TItemGenerate = Callback<TItemCallback>;

/** 搜索结果列表 */
@Reusable
@Component
export struct SourceResultList {
  /** 图片间距 */
  static readonly itemGap = 10;
  /** 接收根据对应规则生成的数据 */
  generateData?: TItemGenerate;
  /** 数据懒加载源 */
  dataSource: UDataSource<SearchResultItem> = new UDataSource<SearchResultItem>();
  /** 数据刷新中 */
  @State
  private isRefreshing: boolean = false
  /** 数据加载中 */
  @State
  private isLoading: boolean = false;
  /** Grid 滚动控制器 */
  private scroller: Scroller = new Scroller();
  /** 预览控制器 */
  private readonly controller: ImagePreviewController = new ImagePreviewController();
  /** 图片弹窗 */
  private readonly dialogController: CustomDialogController = new CustomDialogController({
    builder: ImageDialog({ controller: this.controller }),
    customStyle: true,
    offset: { dx: 0, dy: 0 },
    alignment: DialogAlignment.Center,
    autoCancel: true
  });

  aboutToAppear(): void {
    this.dataSource.registerCallback(this.setImages);
    this.controller.setCachedCount(1).setAutoResize(true);
    if (this.generateData != null) {
      this.generateData((item) => this.dataSource.pushAll(item));
    }
  }

  aboutToDisappear(): void {
    this.dataSource.unregisterCallback(this.setImages);
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing }) {
        WaterFlow({ scroller: this.scroller, footer: () => { this.buildFooter() } }) {
          LazyForEach(this.dataSource, (item: SearchResultItem, index: number) => {
            FlowItem() {
              ImageCom({ src: item.thumbnail ?? item.origin })
                .onClick(() => {
                  this.controller.setInitialIndex(index);
                  this.dialogController.open();
                })
            }
          })
        }
        .columnsTemplate('repeat(auto-fit, 240)')
        .columnsGap(SourceResultList.itemGap)
        .rowsGap(SourceResultList.itemGap)
        .edgeEffect(EdgeEffect.Spring)
        .scrollBarWidth(2)
        .fadingEdge(true, { fadingEdgeLength: LengthMetrics.vp(40) })
        .onReachEnd(() => {
          // 触底时增加数据
          if (this.isLoading === false) {
            this.loadData();
          }
        })
      }
      .refreshOffset(128)
      .onRefreshing(() => this.refreshData())
    }
    .height('100%')
    .padding({ bottom: SourceResultList.itemGap })
  }

  @Builder
  buildFooter() {
    if (this.isLoading) {
      Image($r('app.media.loading_gif'))
        .width('100%')
        .constraintSize({ maxHeight: 80 })
        .objectFit(ImageFit.ScaleDown)
    }
  }

  /**
   * 刷新数据
   */
  async refreshData() {
    await new Promise<void>((resolve) => setTimeout(resolve, 2000));
    this.isRefreshing = false;
  }

  /**
   * 加载数据
   */
  async loadData() {
    const param: AnimateParam = { duration: 300, curve: Curve.Ease };
    animateTo(param, () => this.isLoading = true)
    await new Promise<void>((resolve) => setTimeout(resolve, 2000));
    animateTo(param, () => this.isLoading = false)
  }

  /***
   * 设置预览图片数组
   */
  setImages: VoidCallback = () => {
    this.controller.setImage(this.dataSource.getAllData().map((item) => item.origin));
  }
}