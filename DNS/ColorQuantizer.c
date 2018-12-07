//
//  ColorQuantizer.c
//  DNS
//
//  Created by WENTAO XING on 2018/12/7.
//  Copyright © 2018 WENTAO XING. All rights reserved.
//

#include "ColorQuantizer.h"
#include <stdlib.h>
#include <errno.h>
#define oops(m) {perror(m); exit(1);}
static int leafNum = 0;
ColorNode * reducerArr[MAX_LENGTH];

ColorNode * createColorNode(uint32_t level) {
    ColorNode * node = (ColorNode *) malloc(sizeof(ColorNode));
    if (node == NULL) {
        oops("malloc: ");
    }
    
    node -> r = 0;
    node -> g = 0;
    node -> b = 0;
    node->pixelCount = 0;
    if (level == MAX_LENGTH) {
        node->isLeaf = true;
        node->children = NULL;
        leafNum++;
    } else {
        node->isLeaf = false;
        node->children = (ColorNode **) calloc(8, 8 * sizeof(ColorNode *));
    }
    return node;
}

uint8_t getColorIndex(uint8_t r, uint8_t g, uint8_t b, uint32_t level) {
//    printf("level: %d\n", level);
    uint8_t index = 0;
    uint8_t mask = 0x80 >> level;
    if (r & mask) index |= 0x04;
    if (g & mask) index |= 0x02;
    if (b & mask) index |= 0x01;
    return index;
}

void addColorNode(uint8_t r, uint8_t g, uint8_t b, ColorNode * node, uint32_t level) {
    if (node->isLeaf) {
        node->r += r;
        node->g += g;
        node->b += b;
        node->pixelCount += 1;
    } else {
        uint8_t index = getColorIndex(r, g, b, level);
        ColorNode * nextNode;
        if (node->children[index] == NULL) {
            node->children[index] = createColorNode(level + 1);
            if (reducerArr[level]) {
                node->children[index]->next = reducerArr[level];
            }
            reducerArr[level] = node->children[index];

        }
        nextNode = node->children[index];
        addColorNode(r, g, b, nextNode, level + 1);
    }
}

ColorNode * getColor(ColorNode * root) {
    printf("leafNum = %d\n", leafNum);
    if (root->children && root->children[7]) {
        return getColor(root->children[7]);
    }
    
    return root;
}

void reducerTree(ColorNode * root, uint32_t count) {
    if (count > leafNum) return;
    for (int i = MAX_LENGTH - 2; i >= 0; i--) {
        ColorNode * node = reducerArr[i];
        while(node) {
            ColorNode ** children = node->children;
            for (int i = 0; i < 8; i++) {
                ColorNode * child = children[i];
                if (child) {
                    node->r += child->r;
                    node->g += child->g;
                    node->b += child->b;
                    node->pixelCount += child->pixelCount;
                    leafNum--;
                }
            }
            node->children = NULL;
            if (leafNum <= count) break;
            node = node->next;
        }
        
        if (leafNum <= count) break;
    }
}

void releaseNode(ColorNode * root) {
    free(root);
}
