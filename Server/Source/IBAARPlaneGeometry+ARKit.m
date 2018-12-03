//
//  Copyright © 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
//

#import "IBAARPlaneGeometry+ARKit.h"

@implementation IBAARPlaneGeometry (ARKit)

+ (instancetype)planeGeometryWithARPlaneGeometry:(ARPlaneGeometry *)planeGeometry
{
    return [[self alloc] initWithVertexCount:planeGeometry.vertexCount
                                    vertices:planeGeometry.vertices
                      textureCoordinateCount:planeGeometry.textureCoordinateCount
                          textureCoordinates:planeGeometry.textureCoordinates
                          triangleIndexCount:planeGeometry.triangleCount * 3
                             triangleIndices:planeGeometry.triangleIndices
                         boundaryVertexCount:planeGeometry.boundaryVertexCount
                            boundaryVertices:planeGeometry.boundaryVertices];
}

@end
