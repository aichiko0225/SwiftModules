

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImagePickerCompletionHandler)(NSData *imageData, UIImage *image);

@interface UIViewController (ImagePicker)

- (void)pickImageOnlyTakePhotoWithCompletionHandler:(ImagePickerCompletionHandler)completionHandler;
- (void)pickImageWithCompletionHandler:(ImagePickerCompletionHandler)completionHandler;
- (void)pickImageWithpickImageCutImageWithImageSize:(CGSize)imageSize CompletionHandler:(ImagePickerCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
