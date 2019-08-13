//
//  MapTypeLocationView.m
//  Emergency
//
//  Created by gzx on 2019/8/7.
//  Copyright © 2019 古智性. All rights reserved.
//

#import "MapTypeLocationView.h"

@interface MapTypeLocationView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *slidingView;
@property (nonatomic, strong) UIImageView *slidingImg;
@property (nonatomic, strong) UIButton *rescueBtn;


@end

@implementation MapTypeLocationView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = QL_UIColorFromHEX(0xFFFFFF);
        [self configUI];
    }
    return self;
}

#pragma mark - UI
- (void)configUI
{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.slidingView];
    [self.slidingView addSubview:self.slidingImg];
    [self.bgView addSubview:self.rescueBtn];
    [self layoutUI];
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightOrange.direction = UISwipeGestureRecognizerDirectionUp;
    [self.slidingView addGestureRecognizer:swipeRightOrange];
    
    UISwipeGestureRecognizer *swipeRightOrangedown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightOrangedown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.slidingView addGestureRecognizer:swipeRightOrangedown];
    
    NSArray *aroundStores = [AroundStoreModel searchWithWhere:nil];
    for (int i = 0 ; i < aroundStores.count; i ++)
    {
        AroundStoreModel *model = aroundStores[i];
        UIView *view = [self creatViewAroundStoreModel:model index:i];
        [self.bgView addSubview:view];
    }
}

- (void)layoutUI
{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.slidingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bgView);
        make.height.mas_equalTo(40);
    }];
    
    [self.slidingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.slidingView);
        make.centerY.equalTo(self.slidingView);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(16);
    }];
    
    [self.rescueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(32);
        make.right.equalTo(self.bgView).offset(-32);
        make.bottom.equalTo(self.bgView).offset(-16);
        make.height.mas_equalTo(38);
    }];
}

- (UIView *)creatViewAroundStoreModel:(AroundStoreModel *)model index:(NSInteger)index
{
    CGFloat width = ScreenWidth/4;
    NSInteger row = index%4;
    NSInteger col = index/4;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(row*width, 40 + col*width, width, width)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width/2 - 19, view.frame.size.height/2 - 33, 38, 38)];
    iconImg.image = [UIImage imageNamed:model.iconName];
    [view addSubview:iconImg];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8, iconImg.frame.origin.y + iconImg.frame.size.height + 8, width - 16, 20)];
    lab.text = model.title?:@"";
    lab.textColor = QL_RGBAlpha(0, 0, 0, 0.87);
    lab.font = QL_Default_Font(14);
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, width, width);
    btn.titleLabel.text = model.title;
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(aroundStoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    [view addSubview:btn];
    return view;
}

#pragma mark - action
- (void)aroundStoreBtnClick:(UIButton *)sender
{
    NSLog(@"-------%@",sender.titleLabel.text);
    if ([self.delegate respondsToSelector:@selector(aroundStoreBtnClick:)])
    {
        [self.delegate aroundStoreBtnClick:sender];
    }
}

- (void)rescueBtnClick:(UIButton *)sender
{
    NSLog(@"-------一键救援");
}

- (void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    
    if ([self.delegate respondsToSelector:@selector(slideToRightWithGestureRecognizer:)])
    {
        [self.delegate slideToRightWithGestureRecognizer:swipeGestureRecognizer];
    }
    [self.bgView layoutIfNeeded];
}
#pragma mark - setter & getter
- (UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UIView *)slidingView
{
    if (!_slidingView)
    {
        _slidingView = [[UIView alloc] init];
        _slidingView.backgroundColor = [UIColor clearColor];
    }
    return _slidingView;
}

- (UIImageView *)slidingImg
{
    if (!_slidingImg)
    {
        _slidingImg = [[UIImageView alloc] init];
        _slidingImg.image = [UIImage imageNamed:@"home-up"];
    }
    return _slidingImg;
}

- (UIButton *)rescueBtn
{
    if (!_rescueBtn)
    {
        _rescueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rescueBtn setTitle:@"一键救援" forState:UIControlStateNormal];
        [_rescueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rescueBtn.titleLabel.font = QL_Default_Medium_Font(15);
        _rescueBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rescueBtn.backgroundColor = QL_UIColorFromHEX(0xFBB134);
        [_rescueBtn addTarget:self action:@selector(rescueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rescueBtn.layer.cornerRadius = 2;
        _rescueBtn.layer.masksToBounds = YES;
    }
    return _rescueBtn;
}
@end
