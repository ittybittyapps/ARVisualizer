//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARPlaneGeometry.h"
#import "IBAMemoryUtilities.h"
#import "NSCoder+IBACodingHelpers.h"

@implementation IBAARPlaneGeometry
{
    // Pointer property-backing ivars declared as non-const pointers
    simd_float3 *_vertices;
    simd_float2 *_textureCoordinates;
    int16_t *_triangleIndices;
    simd_float3 *_boundaryVertices;
}

static NSString * const kIBAARPlaneGeometryVertexCountKey = @"vxc";
static NSString * const kIBAARPlaneGeometryVerticesKey = @"vx";
static NSString * const kIBAARPlaneGeometryTextureCoordinateCountKey = @"tcc";
static NSString * const kIBAARPlaneGeometryTextureCoordinatesKey = @"tc";
static NSString * const kIBAARPlaneGeometryTriangleIndexCountKey = @"tric";
static NSString * const kIBAARPlaneGeometryTriangleIndicesKey = @"tri";
static NSString * const kIBAARPlaneGeometryBoundaryVertexCountKey = @"bvc";
static NSString * const kIBAARPlaneGeometryBoundaryVerticesKey = @"bv";

static const NSUInteger kTriangleIndicesPerTriangle = 3;

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithVertexCount:(NSUInteger)vertexCount
                           vertices:(const simd_float3 *)vertices
             textureCoordinateCount:(NSUInteger)textureCoordinateCount
                 textureCoordinates:(const simd_float2 *)textureCoordinates
                 triangleIndexCount:(NSUInteger)triangleIndexCount
                    triangleIndices:(const int16_t *)triangleIndices
                boundaryVertexCount:(NSUInteger)boundaryVertexCount
                   boundaryVertices:(const simd_float3 *)boundaryVertices
{
    NSParameterAssert(vertices != NULL);
    NSParameterAssert(textureCoordinates != NULL);
    // Under some rare circumstances, ARKit may fail to triangulate the plane geometry, in which cases triangleIndices will be NULL. This is a violation of its nullability contract, but we have to account for that.
    NSParameterAssert(triangleIndexCount == 0 || triangleIndices != NULL);
    NSParameterAssert(boundaryVertices != NULL);

    NSParameterAssert(triangleIndexCount % kTriangleIndicesPerTriangle == 0);

    self = [super init];
    if (self) {
        _vertexCount = vertexCount;
        _vertices = IBAArrayCopy(vertices, sizeof(simd_float3), vertexCount);

        _textureCoordinateCount = textureCoordinateCount;
        _textureCoordinates = IBAArrayCopy(textureCoordinates, sizeof(simd_float2), textureCoordinateCount);

        _triangleIndexCount = triangleIndexCount;
        _triangleIndices = IBAArrayCopy(triangleIndices, sizeof(int16_t), triangleIndexCount);

        _boundaryVertexCount = boundaryVertexCount;
        _boundaryVertices = IBAArrayCopy(boundaryVertices, sizeof(simd_float3), boundaryVertexCount);
    }

    return self;
}

- (void)dealloc
{
    free(_vertices);
    free(_textureCoordinates);
    free(_triangleIndices);
    free(_boundaryVertices);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSUInteger vertexCount, textureCoordinateCount, triangleIndexCount, boundaryVertexCount;
    const simd_float3 *vertices = [aDecoder iba_decodeArrayNoCopyAndCountWithElementSize:sizeof(simd_float3) count:&vertexCount forKey:kIBAARPlaneGeometryVerticesKey countKey:kIBAARPlaneGeometryVertexCountKey];
    const simd_float2 *textureCoordinates = [aDecoder iba_decodeArrayNoCopyAndCountWithElementSize:sizeof(simd_float2) count:&textureCoordinateCount forKey:kIBAARPlaneGeometryTextureCoordinatesKey countKey:kIBAARPlaneGeometryTextureCoordinateCountKey];
    const int16_t *triangleIndices = [aDecoder iba_decodeArrayNoCopyAndCountWithElementSize:sizeof(int16_t) count:&triangleIndexCount forKey:kIBAARPlaneGeometryTriangleIndicesKey countKey:kIBAARPlaneGeometryTriangleIndexCountKey];
    const simd_float3 *boundaryVertices = [aDecoder iba_decodeArrayNoCopyAndCountWithElementSize:sizeof(simd_float3) count:&boundaryVertexCount forKey:kIBAARPlaneGeometryBoundaryVerticesKey countKey:kIBAARPlaneGeometryBoundaryVertexCountKey];

    if (triangleIndexCount % kTriangleIndicesPerTriangle != 0) {
        [aDecoder iba_failWithReadCorruptError];
        return nil;
    }

    if (vertices != NULL && textureCoordinates != NULL && triangleIndices != NULL && boundaryVertices != NULL) {
        return [self initWithVertexCount:vertexCount
                                vertices:vertices
                  textureCoordinateCount:textureCoordinateCount
                      textureCoordinates:textureCoordinates
                      triangleIndexCount:triangleIndexCount
                         triangleIndices:triangleIndices
                     boundaryVertexCount:boundaryVertexCount
                        boundaryVertices:boundaryVertices];
    } else {
        return nil;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder iba_encodeArrayAndCountWithElementSize:sizeof(simd_float3) count:self.vertexCount at:self.vertices forKey:kIBAARPlaneGeometryVerticesKey countKey:kIBAARPlaneGeometryVertexCountKey];
    [aCoder iba_encodeArrayAndCountWithElementSize:sizeof(simd_float2) count:self.textureCoordinateCount at:self.textureCoordinates forKey:kIBAARPlaneGeometryTextureCoordinatesKey countKey:kIBAARPlaneGeometryTextureCoordinateCountKey];
    [aCoder iba_encodeArrayAndCountWithElementSize:sizeof(int16_t) count:self.triangleIndexCount at:self.triangleIndices forKey:kIBAARPlaneGeometryTriangleIndicesKey countKey:kIBAARPlaneGeometryTriangleIndexCountKey];
    [aCoder iba_encodeArrayAndCountWithElementSize:sizeof(simd_float3) count:self.boundaryVertexCount at:self.boundaryVertices forKey:kIBAARPlaneGeometryBoundaryVerticesKey countKey:kIBAARPlaneGeometryBoundaryVertexCountKey];
}

- (NSUInteger)triangleCount
{
    return self.triangleIndexCount / kTriangleIndicesPerTriangle;
}

@end
