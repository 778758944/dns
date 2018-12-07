//
//  ColorQuantizer.h
//  DNS
//
//  Created by WENTAO XING on 2018/12/7.
//  Copyright © 2018 WENTAO XING. All rights reserved.
//

#ifndef ColorQuantizer_h
#define ColorQuantizer_h

#include <stdio.h>
#include <stdbool.h>
#define MAX_LENGTH 7


typedef struct ColorItem {
    uint8_t r;
    uint8_t g;
    uint8_t b;
    bool isLeaf;
    struct ColorItem ** children;
    uint64_t pixelCount;
    struct ColorItem * next;
} ColorNode;

ColorNode * createColorNode(uint32_t level);

void addColorNode(uint8_t r, uint8_t g, uint8_t b, ColorNode * node, uint32_t level);

uint8_t getColorIndex(uint8_t r, uint8_t g, uint8_t b, uint32_t level);

ColorNode * getColor(ColorNode * root);

void reducerTree(ColorNode * root, uint32_t count);
void releaseNode(ColorNode * root);

#endif /* ColorQuantizer_h */
