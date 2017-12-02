//
//  ViewController.m
//  ZQVariableMenuDemo
//
//  Created by 肖兆强 on 2017/12/1.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#define ShowMenusPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject] stringByAppendingPathComponent:@"Menus.txt"]


#import "ViewController.h"
#import "ZQVariableMenuControl.h"
#import "ZQVariableMenuCell.h"

//菜单列数
static NSInteger ColumnNumber = 4;
//横向和纵向的间距
static CGFloat CellMarginX = 15.0f;
static CGFloat CellMarginY = 10.0f;

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSArray *_currentMenus;
}

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"菜单编辑";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showChannel)];
    [self buildUI];
    [self reloadCollectionView];
    
}

-(void)buildUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = (self.view.bounds.size.width - (ColumnNumber + 1) * CellMarginX)/ColumnNumber;
    flowLayout.itemSize = CGSizeMake(cellWidth,cellWidth+20);
    flowLayout.sectionInset = UIEdgeInsetsMake(CellMarginY, CellMarginX, CellMarginY, CellMarginX);
    flowLayout.minimumLineSpacing = CellMarginY;
    flowLayout.minimumInteritemSpacing = CellMarginX;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 40);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ZQVariableMenuCell class] forCellWithReuseIdentifier:@"ZQVariableMenuCell"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

- (void)reloadCollectionView
{
    _currentMenus = [NSArray arrayWithContentsOfFile:ShowMenusPath];
    
    if (_currentMenus.count>0) {
    }else
    {
        _currentMenus = @[@"素材回传",@"内容库",@"直播",@"消息",@"UGC",@"选题管理",@"串联单",@"移动文稿"];
    }
    [_collectionView reloadData];
}


-(void)showChannel
{
    NSMutableArray *UnShowMenus = [NSMutableArray arrayWithArray:@[@"素材回传",@"内容库",@"直播",@"消息",@"UGC",@"移动文稿",@"任务",@"选题管理",@"串联单",@"线索"]];
    [UnShowMenus removeObjectsInArray:_currentMenus];
    [[ZQVariableMenuControl shareControl] showChannelViewWithInUseTitles:_currentMenus unUseTitles:UnShowMenus fixedNum:2 finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        [inUseTitles writeToFile:ShowMenusPath atomically:YES];
        [self reloadCollectionView];
    }];
    
    
    
}


#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _currentMenus.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"ZQVariableMenuCell";
    ZQVariableMenuCell* item = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    item.title = _currentMenus[indexPath.row];
    item.imageName = _currentMenus[indexPath.row];
    item.backgroundColor = [UIColor whiteColor];
    
    item.isFixed = NO;
    return  item;
}

@end
