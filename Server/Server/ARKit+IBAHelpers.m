//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "ARKit+IBAHelpers.h"
#import <Accelerate/Accelerate.h>
#import <Core/Core.h>

@implementation ARFrame (IBAHelpers)

static BOOL IBASampleScaledCapturedPixelBuffer(CVPixelBufferRef pixelBuffer, CGFloat scale, const CGPoint *points, NSUInteger count, simd_float3 *outputBuffer);
static void IBASampleYCbCrPoints(vImage_Buffer lumaBuffer, vImage_Buffer cbcrBuffer, const CGPoint *points, NSUInteger count, CGFloat lumaScale, CGFloat cbcrScale, simd_float3 *outputBuffer);
static vImage_Buffer IBAPixelBufferGetPlanarBuffer(CVPixelBufferRef pixelBuffer, size_t planeIndex);

- (float)iba_estimatedHorizontalPlanePosition
{
    ARHitTestResult *hitResult = [self hitTest:CGPointMake(0.5, 0.5) types:ARHitTestResultTypeEstimatedHorizontalPlane].firstObject;
    return IBATranslationFromTransform(hitResult.worldTransform)[1];
}

- (NSData *)iba_sampledColorsForPointCloud:(ARPointCloud *)pointCloud
{
    ARCamera *camera = self.camera;
    CGSize imageResolution = camera.imageResolution;
    NSUInteger pointsCount = pointCloud.count;

    // Project all feature points back into image 2D coordinate system
    const simd_float3 *points = pointCloud.points;
    CGPoint *projectedPoints = malloc(sizeof(CGPoint) * pointsCount);

    for (NSUInteger index = 0; index < pointsCount; index++) {
        CGPoint projectedPoint = [camera projectPoint:points[index] orientation:UIInterfaceOrientationLandscapeRight viewportSize:imageResolution];
        if (projectedPoint.x >= 0 && projectedPoint.x <= imageResolution.width - 1 &&
            projectedPoint.y >= 0 && projectedPoint.y <= imageResolution.height - 1) {
            projectedPoints[index] = projectedPoint;
        } else {
            // Fall back to the center of the frame
            projectedPoints[index] = CGPointMake(imageResolution.width / 2, imageResolution.height / 2);
        }
    }

    // Sample the biplanar YCbCr color of each projected point in the image
    NSUInteger colorsSize = sizeof(simd_float3) * pointsCount;
    simd_float3 *colors = malloc(colorsSize);

    const CGFloat kDownscaleFactor = 16.0;
    IBASampleScaledCapturedPixelBuffer(self.capturedImage, 1 / kDownscaleFactor, projectedPoints, pointsCount, colors);

    free(projectedPoints);

    return [NSData dataWithBytesNoCopy:colors length:colorsSize freeWhenDone:YES];
}

BOOL IBASampleScaledCapturedPixelBuffer(CVPixelBufferRef pixelBuffer, CGFloat scale, const CGPoint *points, NSUInteger count, simd_float3 *outputBuffer)
{
    if (CVPixelBufferGetPlaneCount(pixelBuffer) < 2) {
        return NO;
    }

    // Calculate scaled size for buffers
    size_t baseWidth = CVPixelBufferGetWidth(pixelBuffer);
    size_t baseHeight = CVPixelBufferGetHeight(pixelBuffer);

    vImagePixelCount scaledWidth = (vImagePixelCount)ceil(baseWidth * scale);
    vImagePixelCount scaledHeight = (vImagePixelCount)ceil(baseHeight * scale);

    // Lock the source pixel buffer
    CVReturn lockResult = CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    if (lockResult != kCVReturnSuccess) {
        return NO;
    }

    // Allocate buffer for scaled Luma
    // Yes, vImageBuffer_Init takes height then width
    vImage_Buffer scaledLumaBuffer;
    vImageBuffer_Init(&scaledLumaBuffer, scaledHeight, scaledWidth, 8, kvImagePrintDiagnosticsToConsole);

    // Retrieve address of source Luma and scale it
    vImage_Buffer sourceLumaBuffer = IBAPixelBufferGetPlanarBuffer(pixelBuffer, 0);
    vImageScale_Planar8(&sourceLumaBuffer, &scaledLumaBuffer, NULL, kvImagePrintDiagnosticsToConsole);

    // Allocate buffer for scaled CbCr
    vImage_Buffer scaledCbcrBuffer;
    vImageBuffer_Init(&scaledCbcrBuffer, scaledHeight, scaledWidth, 16, kvImagePrintDiagnosticsToConsole);

    // Retrieve address of source CbCr and scale it
    vImage_Buffer sourceCbcrBuffer = IBAPixelBufferGetPlanarBuffer(pixelBuffer, 1);
    vImageScale_CbCr8(&sourceCbcrBuffer, &scaledCbcrBuffer, NULL, kvImagePrintDiagnosticsToConsole);

    // Unlock source buffer now
    CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);

    // Perform sampling
    IBASampleYCbCrPoints(scaledLumaBuffer, scaledCbcrBuffer, points, count, scale, scale, outputBuffer);

    // Free scaled buffers
    free(scaledLumaBuffer.data);
    free(scaledCbcrBuffer.data);

    return YES;
}

void IBASampleYCbCrPoints(vImage_Buffer lumaBuffer, vImage_Buffer cbcrBuffer, const CGPoint *points, NSUInteger count, CGFloat lumaScale, CGFloat cbcrScale, simd_float3 *outputBuffer)
{
    for (NSUInteger index = 0; index < count; index++) {
        CGPoint point = points[index];
        CGPoint lumaPoint = CGPointMake(point.x * lumaScale, point.y * lumaScale);
        CGPoint cbcrPoint = CGPointMake(point.x * cbcrScale, point.y * cbcrScale);

        const void *lumaPixelAddress = lumaBuffer.data + lumaBuffer.rowBytes * (int)lumaPoint.y + (int)lumaPoint.x;
        const void *cbcrPixelAddress = cbcrBuffer.data + cbcrBuffer.rowBytes * (int)cbcrPoint.y + (int)cbcrPoint.x * 2;

        UInt8 luma = *((UInt8 *)lumaPixelAddress);
        UInt8 cb = *((UInt8 *)cbcrPixelAddress);
        UInt8 cr = *((UInt8 *)cbcrPixelAddress + 1);
        outputBuffer[index] = simd_make_float3(luma / 255.0f, cb / 255.0f, cr / 255.0f);
    }
}

// Assumes that pixel buffer base address is already locked
vImage_Buffer IBAPixelBufferGetPlanarBuffer(CVPixelBufferRef pixelBuffer, size_t planeIndex)
{
    void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, planeIndex);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, planeIndex);
    size_t width = CVPixelBufferGetWidthOfPlane(pixelBuffer, planeIndex);
    size_t height = CVPixelBufferGetHeightOfPlane(pixelBuffer, planeIndex);

    return (vImage_Buffer){ .data = baseAddress, .height = height, .width = width, .rowBytes = bytesPerRow };
}

@end
