//
//  ImagePickerView.h
//  ImagePickerView
//
//  Created by Stephen on 7/22/15.
//  Copyright (c) 2015 Zake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImagePickerView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    ALAssetsLibrary *library;
    NSMutableArray* groupsArray;
    NSMutableArray* assetToDisplay;
    NSMutableArray* assetSelected;
    UILabel* subtitle;
    UIImageView* arrow;
}

@end
