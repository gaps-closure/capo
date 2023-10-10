#include "klvparser.h"
#include "Constants.h"
#include "fielddecode.h"
#include "scaleddecode.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct KlvTag_t
{
    uint8_t Key;
    uint32_t Length;
    uint8_t *pData;
    struct KlvTag_t *pNext;
} KlvTag_t;

KlvTag_t *pHeadTag = NULL;

// Define to output data in radians, undefine for degrees
#define RADIANS

#ifdef RADIANS
# define CONVERT_ANGLE(x) radians(x)
#else
# define CONVERT_ANGLE(x) (x)
#endif // RADIANS

typedef enum
{
    KLV_TYPE_UINT,
    KLV_TYPE_INT,
    KLV_TYPE_DOUBLE,
    KLV_TYPE_STRING,
    KLV_TYPE_OTHER
} KlvType_t;

typedef struct
{
    char Name[64];
    KlvType_t Type;
    double Min;
    double Max;
} KlvTagInfo_t;

KlvTagInfo_t TagInfo[KLV_UAS_NUM_ELEMENTS] = {
    { "KLV_UAS_NULL", /* = 0, */                  KLV_TYPE_OTHER },
    { "KLV_UAS_CHECKSUM", /* = 1, */              KLV_TYPE_UINT },
    { "KLV_UAS_TIME_STAMP", /* = 2, */            KLV_TYPE_UINT },
    { "KLV_UAS_MISSION_ID", /* = 3, */            KLV_TYPE_STRING },
    { "KLV_UAS_TAIL_NUMBER", /* = 4, */           KLV_TYPE_STRING },
    { "KLV_UAS_PLATFORM_YAW", /* = 5, */          KLV_TYPE_DOUBLE, CONVERT_ANGLE(0), CONVERT_ANGLE(360) },
    { "KLV_UAS_PLATFORM_PITCH_SHORT", /* = 6 */   KLV_TYPE_DOUBLE, CONVERT_ANGLE(-20), CONVERT_ANGLE(20) },
    { "KLV_UAS_PLATFORM_ROLL_SHORT", /* = 7 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-50), CONVERT_ANGLE(50) },
    { "KLV_UAS_PLATFORM_TAS", /* = 8, */          KLV_TYPE_UINT },
    { "KLV_UAS_PLATFORM_IAS", /* = 9, */          KLV_TYPE_UINT },
    { "KLV_UAS_PLATFORM_ID", /* = 10 */           KLV_TYPE_STRING },
    { "KLV_UAS_SENSOR_ID", /* = 11 */             KLV_TYPE_STRING },
    { "KLV_UAS_COORD_SYSTEM", /* = 12 */          KLV_TYPE_STRING },
    { "KLV_UAS_SENSOR_LAT", /* = 13 */            KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_SENSOR_LON", /* = 14 */            KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_SENSOR_MSL", /* = 15 */            KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_SENSOR_HFOV", /* = 16 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(0), CONVERT_ANGLE(180) },
    { "KLV_UAS_SENSOR_VFOV", /* = 17 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(0), CONVERT_ANGLE(180) },
    { "KLV_UAS_SENSOR_PAN", /* = 18 */            KLV_TYPE_DOUBLE, CONVERT_ANGLE(0), CONVERT_ANGLE(360) },
    { "KLV_UAS_SENSOR_TILT", /* = 19 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_SENSOR_ROLL", /* = 20 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(0), CONVERT_ANGLE(360) },
    { "KLV_UAS_SLANT_RANGE", /* = 21 */           KLV_TYPE_DOUBLE, 0, 5000000 },
    { "KLV_UAS_TARGET_WIDTH", /* = 22 */          KLV_TYPE_DOUBLE, 0, 10000 },
    { "KLV_UAS_IMAGE_LAT", /* = 23 */             KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_IMAGE_LON", /* = 24 */             KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_IMAGE_MSL", /* = 25 */             KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_CORNER1_LAT_OFFSET", /* = 26 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-0.075), CONVERT_ANGLE(0.075) },
    { "KLV_UAS_CORNER1_LON_OFFSET", /* = 27 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-0.075), CONVERT_ANGLE(0.075) },
    { "KLV_UAS_CORNER2_LAT_OFFSET", /* = 28 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-0.075), CONVERT_ANGLE(0.075) },
    { "KLV_UAS_CORNER2_LON_OFFSET", /* = 29 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-0.075), CONVERT_ANGLE(0.075) },
    { "KLV_UAS_CORNER3_LAT_OFFSET", /* = 30 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-0.075), CONVERT_ANGLE(0.075) },
    { "KLV_UAS_CORNER3_LON_OFFSET", /* = 31 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-0.075), CONVERT_ANGLE(0.075) },
    { "KLV_UAS_CORNER4_LAT_OFFSET", /* = 32 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-0.075), CONVERT_ANGLE(0.075) },
    { "KLV_UAS_CORNER4_LON_OFFSET", /* = 33 */    KLV_TYPE_DOUBLE, CONVERT_ANGLE(-0.075), CONVERT_ANGLE(0.075) },
    { "KLV_UAS_ICING", /* = 34 */                 KLV_TYPE_UINT },
    { "KLV_UAS_WIND_DIRECTION", /* = 35 */        KLV_TYPE_DOUBLE, CONVERT_ANGLE(0), CONVERT_ANGLE(360) },
    { "KLV_UAS_WIND_SPEED", /* = 36 */            KLV_TYPE_DOUBLE, 0, 100 },
    { "KLV_UAS_STATIC_PRESSURE", /* = 37 */       KLV_TYPE_DOUBLE, 0, 500000 },
    { "KLV_UAS_DENSITY_ALTITUDE", /* = 38 */      KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_OAT", /* = 39 */                   KLV_TYPE_INT },
    { "KLV_UAS_TARGET_LAT", /* = 40 */            KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_TARGET_LON", /* = 41 */            KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_TARGET_MSL", /* = 42 */            KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_TRACK_WIDTH", /* = 43 */           KLV_TYPE_UINT },
    { "KLV_UAS_TRACK_HEIGHT", /* = 44 */          KLV_TYPE_UINT },
    { "KLV_UAS_TARGET_CE90", /* = 45 */           KLV_TYPE_UINT, 0, 4096 }, // NOTE: POORLY DEFINED BY SPEC
    { "KLV_UAS_TARGET_LE90", /* = 46 */           KLV_TYPE_UINT, 0, 4096 }, // NOTE: POORLY DEFINED BY SPEC
    { "KLV_UAS_GENERIC_FLAG", /* = 47 */          KLV_TYPE_UINT },
    { "KLV_UAS_SECURITY", /* = 48 */              KLV_TYPE_OTHER },
    { "KLV_UAS_DYNAMIC_PRESSURE", /* = 49 */      KLV_TYPE_DOUBLE, 0, 500000 },
    { "KLV_UAS_ANGLE_OF_ATTACK_SHORT", /* = 50 */ KLV_TYPE_OTHER },
    { "KLV_UAS_VERTICAL_VELOCITY", /* = 51 */     KLV_TYPE_DOUBLE, -180, 180 },
    { "KLV_UAS_SIDESLIP_SHORT", /* = 52 */        KLV_TYPE_DOUBLE, CONVERT_ANGLE(-20), CONVERT_ANGLE(20) },
    { "KLV_UAS_AIRFIELD_PRESSURE", /* = 53 */     KLV_TYPE_DOUBLE, 0, 500000 },
    { "KLV_UAS_AIRFIELD_ELEVATION", /* = 54 */    KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_HUMIDITY", /* = 55 */              KLV_TYPE_DOUBLE, 0, 1 },
    { "KLV_UAS_GROUND_SPEED", /* = 56 */          KLV_TYPE_UINT },
    { "KLV_UAS_GROUND_RANGE", /* = 57 */          KLV_TYPE_DOUBLE, 0, 5000000 },
    { "KLV_UAS_FUEL_REMAINING", /* = 58 */        KLV_TYPE_DOUBLE, 0, 10000 },
    { "KLV_UAS_CALLSIGN", /* = 59 */              KLV_TYPE_STRING },
    { "KLV_UAS_WEAPON_LOAD", /* = 60 */           KLV_TYPE_UINT },
    { "KLV_UAS_WEAPON_FIRED", /* = 61 */          KLV_TYPE_UINT },
    { "KLV_UAS_LASER_PRF_CODE", /* = 62 */        KLV_TYPE_UINT },
    { "KLV_UAS_FOV_NAME", /* = 63 */              KLV_TYPE_STRING },
    { "KLV_UAS_MAGNETIC_HEADING", /* = 64 */      KLV_TYPE_DOUBLE, CONVERT_ANGLE(0), CONVERT_ANGLE(360) },
    { "KLV_UAS_VERSION", /* = 65 */               KLV_TYPE_UINT },
    { "KLV_UAS_TARGET_COVARIANCE", /* = 66 */     KLV_TYPE_OTHER },
    { "KLV_UAS_ALT_PLATFORM_LAT", /* = 67 */      KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_ALT_PLATFORM_LON", /* = 68 */      KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_ALT_PLATFORM_MSL", /* = 69 */      KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_ALT_PLATFORM_NAME", /* = 70 */     KLV_TYPE_STRING },
    { "KLV_UAS_ALT_PLATFORM_HEADING", /* = 71 */  KLV_TYPE_DOUBLE, CONVERT_ANGLE(0), CONVERT_ANGLE(360) },
    { "KLV_UAS_EVENT_START_TIME", /* = 72 */      KLV_TYPE_UINT },
    { "KLV_UAS_RVT_LOCAL_SET", /* = 73 */         KLV_TYPE_OTHER },
    { "KLV_UAS_VMTI", /* = 74 */                  KLV_TYPE_OTHER },
    { "KLV_UAS_SENSOR_HAE", /* = 75 */            KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_ALT_PLATFORM_HAE", /* = 76 */      KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_OPERATIONAL_MODE", /* = 77 */      KLV_TYPE_UINT },
    { "KLV_UAS_IMAGE_HAE", /* = 78 */             KLV_TYPE_DOUBLE, -900, 19000 },
    { "KLV_UAS_NORTH_VELOCITY", /* = 79 */        KLV_TYPE_DOUBLE, -327, 327 },
    { "KLV_UAS_EAST_VELOCITY", /* = 80 */         KLV_TYPE_DOUBLE, -327, 327 },
    { "KLV_UAS_IMAGE_HORIZON", /* = 81 */         KLV_TYPE_OTHER },
    { "KLV_UAS_CORNER1_LAT", /* = 82 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_CORNER1_LON", /* = 83 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_CORNER2_LAT", /* = 84 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_CORNER2_LON", /* = 85 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_CORNER3_LAT", /* = 86 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_CORNER3_LON", /* = 87 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_CORNER4_LAT", /* = 88 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_CORNER4_LON", /* = 89 */           KLV_TYPE_DOUBLE, CONVERT_ANGLE(-180), CONVERT_ANGLE(180) },
    { "KLV_UAS_PLATFORM_PITCH", /* = 90 */        KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_PLATFORM_ROLL", /* = 91 */         KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_ANGLE_OF_ATTACK", /* = 92 */       KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_SIDESLIP", /* = 93 */              KLV_TYPE_DOUBLE, CONVERT_ANGLE(-90), CONVERT_ANGLE(90) },
    { "KLV_UAS_CORE_ID", /* = 94 */               KLV_TYPE_OTHER },
};

uint64_t KlvGetLength(const uint8_t *pData, uint64_t *pIndex)
{
    if (pData[*pIndex] & 0x80)
    {
        int Bytes = pData[(*pIndex)++] & 0x7F;
        uint64_t Length = 0;

        while (Bytes--)
            Length |= (uint64_t)pData[(*pIndex)++] << (Bytes * 8);

        return Length;
    }
    else
        return pData[(*pIndex)++];
}

void KlvNewData(const uint8_t *pData, int Length)
{
    // Get the length of the whole shebang
    uint64_t i = 16, DataLength = KlvGetLength(pData, &i) + i;

    // As long as there's more data to read out
    while (i < DataLength)
    {
        // Grab the key and the length of the tag's data
        uint8_t Key = pData[i++];
        uint64_t KeyLength = KlvGetLength(pData, &i);

        // Clip the length to the number of bytes remaining
        KeyLength = MIN(KeyLength, DataLength - i);

        // Pass the data to the KLV tree
        KlvTreeSetValue(Key, KeyLength, &pData[i]);

        // Now increment the array index by the data size
        i += KeyLength;
    }

}// KlvNewData


double KlvGetValueDouble(KlvUasDataElement_t Element, int *pResult)
{
    // If this is a valid key
    if (Element < KLV_UAS_NUM_ELEMENTS)
    {
        // Decide what to do based on the data type
        switch (TagInfo[Element].Type)
        {
        case KLV_TYPE_DOUBLE:
            return KlvTreeGetValueDouble(Element, TagInfo[Element].Min, TagInfo[Element].Max, pResult);

        case KLV_TYPE_UINT:
            return KlvTreeGetValueUInt(Element, pResult);

        case KLV_TYPE_INT:
            return KlvTreeGetValueInt(Element, pResult);

        default:
            break;
        }
    }

    *pResult = 0;
    return 0;

}// KlvGetValueDouble

int64_t KlvGetValueInt(KlvUasDataElement_t Element, int *pResult)
{
    // If this is a valid key
    if (Element < KLV_UAS_NUM_ELEMENTS)
    {
        // Decide what to do based on the data type
        switch (TagInfo[Element].Type)
        {
        case KLV_TYPE_DOUBLE:
        {
            double Value = KlvTreeGetValueDouble(Element, TagInfo[Element].Min, TagInfo[Element].Max, pResult);

            // Treat the data as invalid if it doesn't fit in an int64_t
            if ((Value > (double)0x7FFFFFFFFFFFFFFFLL) || (Value < (double)0x8000000000000000LL))
                break;
            else if (Value >= 0)
                return Value + 0.5f;
            else
                return Value - 0.5f;
        }

        case KLV_TYPE_UINT:
        {
            uint64_t Value = KlvTreeGetValueUInt(Element, pResult);

            // Treat the data as invalid if it doesn't fit in an int64_t
            if (Value > 0x7FFFFFFFFFFFFFFFULL)
                break;
            else
                return Value;
        }

        case KLV_TYPE_INT:
            return KlvTreeGetValueInt(Element, pResult);

        default:
            break;
        }
    }

    *pResult = 0;
    return 0;

}// KlvGetValueInt

uint64_t KlvGetValueUInt(KlvUasDataElement_t Element, int *pResult)
{
    // If this is a valid key
    if (Element < KLV_UAS_NUM_ELEMENTS)
    {
        // Decide what to do based on the data type
        switch (TagInfo[Element].Type)
        {
        case KLV_TYPE_DOUBLE:
        {
            double Value = KlvTreeGetValueDouble(Element, TagInfo[Element].Min, TagInfo[Element].Max, pResult);

            // Treat the data as invalid if it doesn't fit in a uint64_t
            if ((Value > (double)0xFFFFFFFFFFFFFFFFULL) || (Value < 0))
                break;
            else if (Value > 0)
                return Value + 0.5f;
        }

        case KLV_TYPE_UINT:
            return KlvTreeGetValueUInt(Element, pResult);

        case KLV_TYPE_INT:
        {
            int64_t Value = KlvTreeGetValueInt(Element, pResult);

            // Treat the data as invalid if it doesn't fit in a uint64_t
            if (Value < 0)
                break;
            else
                return Value;
        }

        default:
            break;
        }
    }

    *pResult = 0;
    return 0;

}// KlvGetValueUInt

const char *KlvGetValueString(KlvUasDataElement_t Element)
{
    const char *pValue = 0;

    // If this is a valid key
    if ((Element < KLV_UAS_NUM_ELEMENTS) && (TagInfo[Element].Type == KLV_TYPE_STRING))
        pValue = KlvTreeGetValueString(Element);

    return pValue;

}// KlvGetValueString


void KlvPrintData(void)
{
    int Result, i;
    uint32_t Length;

    // Loop through all of the different tags we know about
    for (i = 0; i < KLV_UAS_NUM_ELEMENTS; i++)
    {
        // If we found one of these elements
        if (KlvTreeHasKey(i))
        {
            // Grab the length of this tag
            KlvTreeGetValue(i, &Length);

            // Print the key, enumeration name, and length
            printf("Key %3d (%-32s), length: %d, value: ", i, TagInfo[i].Name, Length);

            // Switch on tag type
            switch (TagInfo[i].Type)
            {
            // Decode this tag as a double and print
            case KLV_TYPE_DOUBLE:
                printf("%lf\n", KlvTreeGetValueDouble((KlvUasDataElement_t)i, TagInfo[i].Min, TagInfo[i].Max, &Result));
                break;

            // Decode this tag as an unsigned int and print
            case KLV_TYPE_UINT:
                printf("%" PRIu64 "\n", KlvTreeGetValueUInt((KlvUasDataElement_t)i, &Result));
                break;

            // Decode this tag as a signed int and print
            case KLV_TYPE_INT:
                printf("%" PRId64 "\n", KlvTreeGetValueInt((KlvUasDataElement_t)i, &Result));
                break;

            // Decode this tag as a string and print
            case KLV_TYPE_STRING:
                printf("%s\n", KlvGetValueString((KlvUasDataElement_t)i));
                break;

            // Print anything else as a hexdump
            default:
            {
                uint32_t Length, j;
                const uint8_t *pData = KlvTreeGetValue((KlvUasDataElement_t)i, &Length);

                // 
                for (j = 0; j < Length; j++)
                    printf("%02x ", pData[j]);
                printf("\n");
                break;
            }
            };
        }
    }

}// KlvPrintData

KlvTag_t *KlvCreateTag(void)
{
    KlvTag_t *pTag = (KlvTag_t *)calloc(1, sizeof(KlvTag_t)), *pHead = pHeadTag;

    // As long as we have a pointer to a tag and its next sibling, keep iterating
    while (pHead && pHead->pNext) { pHead = pHead->pNext; }

    // If we have a valid tag pointer, attach the new node as its sibling
    if (pHead) pHead->pNext = pTag;
    
    // Return a pointer to the new tag
    return pTag;

}// KlvCreateTag

KlvTag_t *KlvFindTag(uint8_t Key)
{
    // Start at the head tag
    KlvTag_t *pHead = pHeadTag;

    // As long as we have a valid tag pointer
    while (pHead)
    {
        // If this is the one we're looking for, stop looping
        if (pHead->Key == Key)
            break;
        // Otherwise, move down to the next element in the list
        else
            pHead = pHead->pNext;
    }

    // Return a pointer to the given tag, or NULL if no result
    return pHead;

}// KlvFindTag

int KlvTreeSetValue(uint8_t Key, uint32_t Length, const uint8_t *pData)
{
    KlvTag_t *pTag = KlvFindTag(Key);

    // If we found an existing tag or are able to create a new one
    if (pTag || (pTag = KlvCreateTag()))
    {
        // Copy in the key and length, and also try to allocate enough space for the data
        pTag->Key = Key;
        pTag->Length = Length;
        pTag->pData = (uint8_t *)realloc(pTag->pData, Length);

        // If we have a good data pointer
        if (pTag->pData)
        {
            // If we don't have a valid head element yet, install this one
            if (pHeadTag == NULL)
                pHeadTag = pTag;

            // Copy in the incoming data and return 1 to indicate success
            memcpy(pTag->pData, pData, Length);
            return 1;
        }
    }

    // No dice - return 0
    return 0;
    
}// KlvTreeSetValue

int KlvTreeHasKey(uint8_t Key)
{
    // Return 1 if a tag with this key was parsed, or 0 if not
    return (KlvFindTag(Key) != NULL);

}// KlvTreeHasKey

double KlvTreeGetValueDouble(uint8_t Key, double Min, double Max, int *pResult)
{
    // Try to grab the right tag from our linked list
    KlvTag_t *pTag = KlvFindTag(Key);
    double Value = 0;

    // Check for valid tag and data array
    if (pTag && pTag->pData)
    {
        // Compute the inverse scale for this element
        double Scale = (Max - Min) / (pow(2, pTag->Length * 8));
        int Index = 0;

        // Default result is success
        *pResult = 1;

        // If this is an asymmetrical value, we have to decode as unsigned and convert
        if (Min + Max != 0)
        {
            // Switch on tag length
            switch (pTag->Length)
            {
            // Use the appropriate Protogen function to get a value
            case 1: Value = float64ScaledFrom1UnsignedBytes(pTag->pData,   &Index, Min, Scale); break;
            case 2: Value = float64ScaledFrom2UnsignedBeBytes(pTag->pData, &Index, Min, Scale); break;
            case 3: Value = float64ScaledFrom3UnsignedBeBytes(pTag->pData, &Index, Min, Scale); break;
            case 4: Value = float64ScaledFrom4UnsignedBeBytes(pTag->pData, &Index, Min, Scale); break;
            case 5: Value = float64ScaledFrom5UnsignedBeBytes(pTag->pData, &Index, Min, Scale); break;
            case 6: Value = float64ScaledFrom6UnsignedBeBytes(pTag->pData, &Index, Min, Scale); break;
            case 7: Value = float64ScaledFrom7UnsignedBeBytes(pTag->pData, &Index, Min, Scale); break;
            case 8: Value = float64ScaledFrom8UnsignedBeBytes(pTag->pData, &Index, Min, Scale); break;

            // Unhandled length: no dice
            default:
                *pResult = 0;
                break;
            }
        }
        else
        {
            // Switch on tag length
            switch (pTag->Length)
            {
            // Use the appropriate Protogen function to get a value
            case 1: Value = float64ScaledFrom1SignedBytes(pTag->pData,   &Index, Scale); break;
            case 2: Value = float64ScaledFrom2SignedBeBytes(pTag->pData, &Index, Scale); break;
            case 3: Value = float64ScaledFrom3SignedBeBytes(pTag->pData, &Index, Scale); break;
            case 4: Value = float64ScaledFrom4SignedBeBytes(pTag->pData, &Index, Scale); break;
            case 5: Value = float64ScaledFrom5SignedBeBytes(pTag->pData, &Index, Scale); break;
            case 6: Value = float64ScaledFrom6SignedBeBytes(pTag->pData, &Index, Scale); break;
            case 7: Value = float64ScaledFrom7SignedBeBytes(pTag->pData, &Index, Scale); break;
            case 8: Value = float64ScaledFrom8SignedBeBytes(pTag->pData, &Index, Scale); break;

            // Unhandled length: no dice
            default:
                *pResult = 0;
                break;
            }
        }
    }
    // No tag means a bogus value, so zero out the result flag
    else
        *pResult = 0;

    return Value;

}// KlvTreeGetValueDouble

int64_t KlvTreeGetValueInt(uint8_t Key, int *pResult)
{
    // Try to grab the right tag from our linked list
    KlvTag_t *pTag = KlvFindTag(Key);
    int64_t Value = 0;

    // Check for valid tag and data array
    if (pTag && pTag->pData)
    {
        int Index = 0;

        // Default result is success
        *pResult = 1;

        // Switch on tag length
        switch (pTag->Length)
        {
        // Use the appropriate Protogen function to get a value
        case 1: Value = int8FromBytes(pTag->pData,    &Index); break;
        case 2: Value = int16FromBeBytes(pTag->pData, &Index); break;
        case 3: Value = int24FromBeBytes(pTag->pData, &Index); break;
        case 4: Value = int32FromBeBytes(pTag->pData, &Index); break;
        case 5: Value = int40FromBeBytes(pTag->pData, &Index); break;
        case 6: Value = int48FromBeBytes(pTag->pData, &Index); break;
        case 7: Value = int56FromBeBytes(pTag->pData, &Index); break;
        case 8: Value = int64FromBeBytes(pTag->pData, &Index); break;

        // Unhandled length: no dice
        default:
            *pResult = 0;
            break;
        }
    }
    // No tag means a bogus value, so zero out the result flag
    else
        *pResult = 0;

    return Value;

}// KlvTreeGetValueInt

uint64_t KlvTreeGetValueUInt(uint8_t Key, int *pResult)
{
    // Try to grab the right tag from our linked list
    KlvTag_t *pTag = KlvFindTag(Key);
    uint64_t Value = 0;

    // Check for valid tag and data array
    if (pTag && pTag->pData)
    {
        int Index = 0;

        // Default result is success
        *pResult = 1;

        // Switch on tag length
        switch (pTag->Length)
        {
        // Use the appropriate Protogen function to get a value
        case 1: Value = uint8FromBytes(pTag->pData,    &Index); break;
        case 2: Value = uint16FromBeBytes(pTag->pData, &Index); break;
        case 3: Value = uint24FromBeBytes(pTag->pData, &Index); break;
        case 4: Value = uint32FromBeBytes(pTag->pData, &Index); break;
        case 5: Value = uint40FromBeBytes(pTag->pData, &Index); break;
        case 6: Value = uint48FromBeBytes(pTag->pData, &Index); break;
        case 7: Value = uint56FromBeBytes(pTag->pData, &Index); break;
        case 8: Value = uint64FromBeBytes(pTag->pData, &Index); break;

        // Unhandled length: no dice
        default:
            *pResult = 0;
            break;
        }
    }
    // No tag means a bogus value, so zero out the result flag
    else
        *pResult = 0;

    return Value;

}// KlvTreeGetValueInt

const char *KlvTreeGetValueString(uint8_t Key)
{
    // If we can find the right tag, just cast its value data to a string and return
    KlvTag_t *pTag = KlvFindTag(Key);

    // If this is a valid tag with a valid data pointer
    if (pTag && pTag->pData)
    {
        // If the string is not null terminated
        if (pTag->pData[pTag->Length - 1] != 0)
        {
            // Add a null byte to the end
            pTag->pData = (uint8_t *)realloc(pTag->pData, pTag->Length + 1);
            pTag->pData[pTag->Length++] = 0;
        }

        // Return a C string
        return (const char *)pTag->pData;
    }
    else
        return NULL;

}// KlvTreeGetValueString

const uint8_t *KlvTreeGetValue(uint8_t Key, uint32_t *pLength)
{
    // If we can find the right tag, just cast its value data to a string and return
    KlvTag_t *pTag = KlvFindTag(Key);

    // If this is a valid tag with a valid data pointer
    if (pTag && pTag->pData)
    {
        // Fill out the length and return the data pointer
        *pLength = pTag->Length;
        return pTag->pData;
    }
    else
    {
        *pLength = 0;
        return NULL;
    }

}

void KlvTreePrint(void)
{
    KlvTag_t *pTag = pHeadTag;

    while (pTag)
    {
        int i;

        printf("TAG: Key = 0x%02x, Length = %d, Value = { ", pTag->Key, pTag->Length);

        for (i = 0; i < pTag->Length; i++)
            printf("0x%02x%s", pTag->pData[i], (i < pTag->Length - 1) ? ", " : " }\n");

        pTag = pTag->pNext;
    }

}
