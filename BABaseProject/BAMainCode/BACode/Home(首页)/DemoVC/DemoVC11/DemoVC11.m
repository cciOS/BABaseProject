//
//  DemoVC11.m
//  BABaseProject
//
//  Created by 博爱 on 16/6/1.
//  Copyright © 2016年 博爱之家. All rights reserved.
//

#import "DemoVC11.h"
#import "DemoVC11_model.h"
#import "DemoVC11_Cell.h"
#import "DemoVC11_AutoLayout.h"
#import "BANewsNetManager.h"

static NSString * const DemoVC11_cellID = @"DemoVC11_Cell";

@interface DemoVC11 ()
<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    DemoVC11_AutoLayoutDelegate
>
@property (nonatomic, strong) UICollectionView     *collectionView;
@property (nonatomic, strong) NSMutableArray       *dataArray;
@property (nonatomic, strong) BANewsNetManager     *netManager;

@end

@implementation DemoVC11

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setVCBgColor:BA_White_Color];
    
    [self setupLayout];
}

- (void)setupLayout
{
    [self getData];
    
    self.collectionView.hidden = NO;
}

#pragma mark - ***** setter / getter
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        DemoVC11_AutoLayout *layout     = [DemoVC11_AutoLayout new];
        /*! 列数 */
        layout.columCounts              = 3;
        /*! 列间距 */
        layout.columSpace               = 5;
        /*! 行间距 */
        layout.itemSpace                = 5;
        /*! 边距 */
        layout.edgeInsets               = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.delegate                 = self;
        

        _collectionView                 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = BA_Yellow_Color;
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        
        [self.view addSubview:_collectionView];
        /*! 滚动条隐藏 */
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[DemoVC11_Cell class] forCellWithReuseIdentifier:DemoVC11_cellID];
        
        _collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

#pragma mark - ***** 获取网络数据
- (void)getData
{
    [self BA_showAlert:BA_Loading];
    [BANewsNetManager getDemoVC11DataCompletionHandle:^(id model, NSError *error) {
        
        [self BA_hideProgress];
        if (!error)
        {
            self.dataArray = [(NSArray *)model mutableCopy];
            [self.collectionView reloadData];
        }
        else
        {
            [self BA_showAlertWithTitle:@"解析错误！"];
        }
    }];
}

#pragma mark - ***** UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoVC11_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DemoVC11_cellID forIndexPath:indexPath];
    cell.model          = self.dataArray[indexPath.item];
    cell.backgroundColor = BA_Green_Color;
    
    if ([NSString BA_NSStringIsNULL:cell.model.desc])
    {
        cell.titleLabel.text = @(indexPath.item).stringValue;
    }
    else
        cell.titleLabel.text = cell.model.desc;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *msg = [NSString stringWithFormat:@"你点击了第 %ld 个item！", (long)indexPath.item];
    [self.view ba_showAlertView:@"温馨提示：" message:msg];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    /*! 第二种：卡片式动画 */
//    static CGFloat initialDelay = 0.2f;
//    static CGFloat stutter = 0.06f;
//    
//    cell.contentView.transform =  CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
//    
//    [UIView animateWithDuration:1.0f delay:initialDelay + ((indexPath.row) * stutter) usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
//        cell.contentView.transform = CGAffineTransformIdentity;
//    } completion:NULL];
    
    
    /*! 第七种：扇形动画 */
    if (indexPath.row % 2 != 0)
    {
        cell.transform = CGAffineTransformTranslate(cell.transform, BA_SCREEN_WIDTH/2,0);
    }
    else
    {
        cell.transform = CGAffineTransformTranslate(cell.transform, -BA_SCREEN_WIDTH/2, 0);
    }

    cell.alpha = 0.0;

    [UIView animateWithDuration:0.7 animations:^{

        cell.transform = CGAffineTransformIdentity;

        cell.alpha = 1.0;
        
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - ***** DemoVC11_AutoLayoutDelegate 设置图片高度
- (CGFloat) layout:(BALayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexpath width:(CGFloat)width
{
    DemoVC11_model *model = self.dataArray[indexpath.item];
    CGFloat height        = width * model.height.doubleValue / model.width.doubleValue + 25;
    return height;
}








@end
