//
//  ImagePickerView.m
//  ImagePickerView
//
//  Created by Stephen on 7/22/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

#import "ImagePickerView.h"
#import "ImagePickerCell.h"

@implementation ImagePickerView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[ImagePickerCell class] forCellWithReuseIdentifier:@"cell"];
        [self getAllPictures];
        assetSelected = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return assetToDisplay.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImagePickerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    ALAsset *asset = assetToDisplay[indexPath.row];
    cell.image.image = [UIImage imageWithCGImage:[asset thumbnail]];
    if ([assetSelected containsObject:(NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL]]) {
        if ([assetSelected indexOfObject:(NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL]] == 0) {
            cell.numberLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(@"choosephoto_ic_press")]];
            cell.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[assetSelected indexOfObject:(NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL]]+1];
//            cell.labelWidth.constant = 44;
//            cell.labelHeight.constant = 22;
//            cell.numberLabel.frame = CGRectMake(63, 8, 23, 23);
        } else {
            cell.numberLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(@"choosephoto_ic_press")]];
//            cell.labelWidth.constant = 23;
//            cell.labelHeight.constant = 23;
            cell.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[assetSelected indexOfObject:(NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL]]+1];
        }
    } else {
        cell.numberLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(@"choosephotos_ic_normal")]];
//        cell.labelWidth.constant = 23;
//        cell.labelHeight.constant = 23;
        cell.numberLabel.text = @"";
    }
    return cell;
}

#pragma collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ALAsset* asset = assetToDisplay[indexPath.row];
//      NSLog(@"%@",(NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL]);
    NSURL* url = (NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL];
    if ([assetSelected containsObject:url]) {
        [assetSelected removeObject:url];
    } else {
        if (assetSelected.count < 10) {
            [assetSelected addObject:url];
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You can only choose 10 images!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    [self reloadData];
    //  [self reloadDataAndScrollToBottom];
}

- (void)setImageSelected:(NSArray*)images {
    assetSelected = [NSMutableArray arrayWithArray:images];
}

#pragma collection view flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(96, 96);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(9, 9, 9, 9);
}

#pragma read user info

-(void)getAllPictures {
    groupsArray = [[NSMutableArray alloc]init];
    library = [[ALAssetsLibrary alloc] init];
    void (^ assetGroupEnumerator) ( ALAssetsGroup *, BOOL *)= ^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if (group != nil && group.numberOfAssets > 0) {
            [groupsArray addObject:group];
            //            if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"]) {
            //                NSLog(@"%@",group);
            //                [self getGroupImageWith:group];
            //            }
            if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
                [self getGroupImageWith:group];
            }
        }
    };
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock:^(NSError *error) {
                             NSLog(@"There is an error %@",error);
                         }];
}

- (void)getGroupImageWith:(ALAssetsGroup*)groupNeedDisplay {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    assetToDisplay = [[NSMutableArray alloc] init];
    subtitle.text = [groupNeedDisplay valueForProperty:ALAssetsGroupPropertyName];
    [subtitle sizeToFit];
    subtitle.center = CGPointMake(self.frame.size.width/2, 48);
    if (subtitle.frame.size.width>92.5) {
        arrow.center = CGPointMake(self.frame.size.width/2+subtitle.frame.size.width/2+10, 20+22-1);
    }
    
    void (^assetEnumerator)( ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != nil) {
            if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                NSURL *url= (NSURL*) [result valueForProperty:ALAssetPropertyAssetURL];
                
                [library assetForURL:url resultBlock:^(ALAsset *asset) {
                    //                    [UIImage imageWithCGImage:[asset thumbnail]]
                    
                    [assetToDisplay addObject:asset];
                    if (assetToDisplay.count == groupNeedDisplay.numberOfAssets) {
                        //                        [self.imageDisplayView reloadData];
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [self reloadDataAndScrollToBottom];
                    }
                } failureBlock:^(NSError *error){
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSLog(@"operation was not successfull!");
                }];
            }
        }
    };
    
    [groupNeedDisplay enumerateAssetsUsingBlock:assetEnumerator];
}

- (void)reloadDataAndScrollToBottom {
    [self reloadData];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:assetToDisplay.count-1 inSection:0];
    [self scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
