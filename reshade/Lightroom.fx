#ifndef ENABLE_HISTOGRAM
#define ENABLE_HISTOGRAM	0
#endif
#ifndef HISTOGRAM_BINS_NUM
#define HISTOGRAM_BINS_NUM 128
#endif
uniform bool LightroomEnableLUT <
  ui_label = "Enable LUT Overlay";
  ui_tooltip = "This Displays A Neutral LUT Onscreen + All Color Adjustments Of This Shader & Consecutive Ones Are Applied To It - Taking A Screenshot & Using The Cropped LUT With The TuningPalette Will Reproduce All Changes Of This Shader - To Make Sure That All Color Changes Of Your Current Preset Are Saved + Put Lightroom As Early In The Technique Chain As Possible - Putting Grain + Sharpening + Bloom Etc After Lightroom.fx Will Break The LUT";
  ui_category = "LUT";
> = false;
uniform int LightroomLUTTileSize <
  ui_type = "drag";
  ui_min = 8; ui_max = 64;
  ui_label = "LUT Tile Size";
  ui_tooltip = "This Controls The XY Size Of Tiles Of The LUT (Which Is Accuracy In Red/Green Channel)";
  ui_category = "LUT";
> = 16;
uniform int LightroomLUTTileCount <
  ui_type = "drag";
  ui_min = 8; ui_max = 64;
  ui_label = "LUT Tile Count";
  ui_tooltip = "This Controls The Amount Of Tiles Of The LUT (Which Is Accuracy In Blue Channel) - Be Aware That Tile Size XY * Tile Amount Is The Width Of The LUT & If This Value Is Larger Than Your Resolution Width + The LUT Won't Fit On Your Screen";
  ui_category = "LUT";
> = 16;
uniform int LightroomLUTScroll <
  ui_type = "drag";
  ui_min = 0; ui_max = 5;
  ui_label = "LUT Scroll";
  ui_tooltip = "If Your LUT Size Exceeds Your Screen Width + Set This To 0 + Take Screenshot + Set It To 1 + Take Screenshot Etc Until You Reach The End Of Your LUT & Assemble The Screenshots Like A Panorama - If Your LUT Fits The Screen Size However + Leave It At 0";
  ui_category = "LUT";
> = 0;
uniform bool LightroomEnableCurveDisplay <
  ui_label = "Enable Luma Curve Display";
  ui_tooltip = "This Enables A Small Overlay With A Luma Curve So You Can Monitor Changes Made By Exposure + Levels Etc";
  ui_category = "Debug";
> = false;
uniform bool LightroomEnableClippingDisplay <
  ui_label = "Enable Black/White Clipping Mask";
  ui_tooltip = "This Shows Where Colors Reach #000000 Black Or #ffffff White + Helpful For Adjusting Levels Properly - NOTE: Any Shader That Operates After Lightroom In ReShade Technique List Can Change Final Color Levels Afterwards So Either Put Lightroom Last In Line Or Take This With A Grain Of Salt";
  ui_category = "Debug";
> = false;
#if(ENABLE_HISTOGRAM == 1)
uniform bool LightroomEnableHistogram <
  ui_label = "Enable Histogram";
  ui_tooltip = "This Enables A Small Overlay With A Histogram For Monitoring Purposes - For Higher Performance + Open Shader & Set HISTOGRAM_BINS_NUM To A Lower Value";
  ui_category = "Histogram";
> = false;
uniform int LightroomHistogramSamples <
  ui_type = "drag";
  ui_min = 32; ui_max = 96;
  ui_label = "Histogram Samples";
  ui_tooltip = "The Amount Of Samples + 20 Means 20x20 Samples Distributed On The Screen - Higher Means A More Accurate Histogram Depiction & Less Temporal Noise";
  ui_category = "Histogram";
> = 20;
uniform float LightroomHistogramHeight <
  ui_type = "drag";
  ui_step = 1;
  ui_min = 5.0; ui_max = 50.0;
  ui_label = "Histogram Curve Height";
  ui_tooltip = "Raises The Histogram Curve If The Values Are Highly Distributed & Not Visible Very Well";
  ui_category = "Histogram";
> = 15;
uniform float LightroomHistogramSmoothness <
  ui_type = "drag";
  ui_min = 1.0; ui_max = 10.00;
  ui_label = "Histogram Curve Smoothness";
  ui_tooltip = "Smoothens The Histogram Curve For A More Temporally Coherent Result - Note That Raising This Falsifies The Histogram Data";
  ui_category = "Histogram";
> = 5.00;
#endif
uniform float LightroomRedHueshift <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Red       Hue Control";
  ui_tooltip = "Magenta <= ... Red ... => Orange";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomOrangeHueshift <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Orange    Hue Control";
  ui_tooltip = "Red <= ... Orange ... => Yellow";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomYellowHueshift <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Yellow    Hue Control";
  ui_tooltip = "Orange <= ... Yellow ... => Green";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomGreenHueshift <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Green     Hue Control";
  ui_tooltip = "Yellow <= ... Green ... => Aqua";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomAquaHueshift <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Aqua      Hue Control";
  ui_tooltip = "Green <= ... Aqua ... => Blue";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomBlueHueshift <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Blue      Hue Control";
  ui_tooltip = "Aqua <= ... Blue ... => Magenta";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomMagentaHueshift <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Magenta   Hue Control";
  ui_tooltip = "Blue <= ... Magenta ... => Red";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomRedExposure <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Red       Exposure";
  ui_tooltip = "Exposure Control Of Red Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomOrangeExposure <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Orange    Exposure";
  ui_tooltip = "Exposure Control Of Orange Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomYellowExposure <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Yellow    Exposure";
  ui_tooltip = "Exposure Control Of Yellow Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomGreenExposure <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Green     Exposure";
  ui_tooltip = "Exposure Control Of Green Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomAquaExposure <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Aqua      Exposure";
  ui_tooltip = "Exposure Control Of Aqua Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomBlueExposure <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Blue      Exposure";
  ui_tooltip = "Exposure Control Of Blue Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomMagentaExposure <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Magenta   Exposure";
  ui_tooltip = "Exposure Control Of Magenta Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomRedSaturation <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Red       Saturation";
  ui_tooltip = "Saturation Control Of Red Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomOrangeSaturation <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Orange    Saturation";
  ui_tooltip = "Saturation Control Of Orange Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomYellowSaturation <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Yellow    Saturation";
  ui_tooltip = "Saturation Control Of Yellow Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomGreenSaturation <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Green     Saturation";
  ui_tooltip = "Saturation Control Of Green Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomAquaSaturation <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Aqua      Saturation";
  ui_tooltip = "Saturation Control Of Aqua Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomBlueSaturation <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Blue      Saturation";
  ui_tooltip = "Saturation Control Of Blue Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomMagentaSaturation <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Magenta   Saturation";
  ui_tooltip = "Saturation Control Of Magenta Colors";
  ui_category = "Palette";
> = 0.00;
uniform float LightroomGlobalBlackLevel <
  ui_type = "drag";
  ui_min = 0; ui_max = 512;
  ui_step = 1;
  ui_label = "Global Black Level";
  ui_tooltip = "Scales Input HSL Value - Everything Darker Than This Is Mapped To Black";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalWhiteLevel <
  ui_type = "drag";
  ui_min = 0; ui_max = 512;
  ui_step = 1;
  ui_label = "Global White Level";
  ui_tooltip = "Scales Input HSL Value";
  ui_category = "Curves";
> = 255.00;
uniform float LightroomGlobalExposure <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Exposure";
  ui_tooltip = "Global Exposure Control";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalGamma <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Gamma";
  ui_tooltip = "Global Gamma Control";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalBlacksCurve <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Blacks Curve";
  ui_tooltip = "Global Blacks Curve Control";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalShadowsCurve <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Shadows Curve";
  ui_tooltip = "Global Shadows Curve Control";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalMidtonesCurve <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Midtones Curve";
  ui_tooltip = "Global Midtones Curve Control";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalHighlightsCurve <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Highlights Curve";
  ui_tooltip = "Global Highlights Curve Control";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalWhitesCurve <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Whites Curve";
  ui_tooltip = "Global Whites Curve Control";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalContrast <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Contrast";
  ui_tooltip = "Global Contrast Control";
  ui_category = "Curves";
> = 0.00;
uniform float LightroomGlobalSaturation <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Saturation";
  ui_tooltip = "Global Saturation Control";
  ui_category = "Color & Saturation";
> = 0.00;
uniform float LightroomGlobalVibrance <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global Vibrance";
  ui_tooltip = "Global Vibrance Control";
  ui_category = "Color & Saturation";
> = 0.00;
uniform float LightroomGlobalTemperature <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global White Balance: Temperature";
  ui_tooltip = "Global Temperature Control";
  ui_category = "Color & Saturation";
> = 0.00;
uniform float LightroomGlobalTint <
  ui_type = "drag";
  ui_min = -1.00; ui_max = 1.00;
  ui_label = "Global White Balance: Tint";
  ui_tooltip = "Global Tint Control";
  ui_category = "Color & Saturation";
> = 0.00;
uniform bool LightroomEnableVignette <
  ui_label = "Enable Vignette Effect";
  ui_tooltip = "This Enables A Vignette Effect (Corner Darkening)";
  ui_category = "Vignette";
> = false;
uniform bool LightroomVignetteShowRadii <
  ui_label = "Show Vignette Inner & Outer Radius";
  ui_tooltip = "This Makes The Inner & Outer Radius Setting Visible - Vignette Intensity Builds Up From Green (No Vignetting) To Red (Full Vignetting)";
  ui_category = "Vignette";
> = false;
uniform float LightroomVignetteRadiusInner <
  ui_type = "drag";
  ui_min = 0.00; ui_max = 2.00;
  ui_label = "Inner Vignette Radius";
  ui_tooltip = "Anything Closer To The Screen Center Than This Is Not Affected By Vignette";
  ui_category = "Vignette";
> = 0.00;
uniform float LightroomVignetteRadiusOuter <
  ui_type = "drag";
  ui_min = 0.00; ui_max = 3.00;
  ui_label = "Outer Vignette Radius";
  ui_tooltip = "Anything Farther From The Screen Center Than This Gets Fully Vignette'd";
  ui_category = "Vignette";
> = 1.00;
uniform float LightroomVignetteWidth <
  ui_type = "drag";
  ui_min = 0.00; ui_max = 1.00;
  ui_label = "Vignette Width";
  ui_tooltip = "Higher Values Stretch The Vignette Horizontally";
  ui_category = "Vignette";
> = 0.00;
uniform float LightroomVignetteHeight <
  ui_type = "drag";
  ui_min = 0.00; ui_max = 1.00;
  ui_label = "Vignette Height";
  ui_tooltip = "Higher Values Stretch The Vignette Vertically";
  ui_category = "Vignette";
> = 0.00;
uniform float LightroomVignetteAmount <
  ui_type = "drag";
  ui_min = 0.00; ui_max = 1.00;
  ui_label = "Vignette Amount";
  ui_tooltip = "Intensity Of Vignette Effect";
  ui_category = "Vignette";
> = 1.00;
uniform float LightroomVignetteCurve <
  ui_type = "drag";
  ui_min = 0.00; ui_max = 10.00;
  ui_label = "Vignette Curve";
  ui_tooltip = "Curve Of Gradient Between Inner & Outer Radius - 1.0 Means Linear";
  ui_category = "Vignette";
> = 1.00;
uniform int LightroomVignetteBlendMode <
  ui_type = "combo";
  ui_items = "Multiply\0Subtract\0Screen\0LumaPreserving\0";
  ui_tooltip = "Select Between Different Ways Of Applying Vignette";
  ui_label = "Vignette Blend Mode";
  ui_category = "Vignette";
> = 1;
#define RESHADE_QUINT_COMMON_VERSION_REQUIRE 200
#include "Common.fxh"
#if(ENABLE_HISTOGRAM == 1)
texture2D HistogramTex			{ Width = HISTOGRAM_BINS_NUM;   Height = 1;  			Format = RGBA16F;  	};
sampler2D sHistogramTex 		{ Texture = HistogramTex; };
#endif
texture2D LUTTexInternal			{ Width = 4096;   Height = 64;  			Format = RGBA8;  	};
sampler2D sLUTTexInternal 		{ Texture = LUTTexInternal; };
void VsLightroom(in uint id : SV_VertexID, out float4 position : SV_Position, out float2 uv : TEXCOORD0, out nointerpolation float huefactors[7] : TEXCOORD1)
{
  uv.x = (id == 2) ? 2.0 : 0.0;
  uv.y = (id == 1) ? 2.0 : 0.0;
  position = float4(uv * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
  static const float originalHue[8] = {0.0,0.0833333333333,0.1666666666666,0.3333333333333,0.5,0.6666666666666,0.8333333333333,1.0};
  huefactors[0] 	= (LightroomRedHueshift     > 0) ? lerp(originalHue[0], originalHue[1], LightroomRedHueshift) 	: lerp(originalHue[7], originalHue[6], -LightroomRedHueshift);
  huefactors[1] 	= (LightroomOrangeHueshift  > 0) ? lerp(originalHue[1], originalHue[2], LightroomOrangeHueshift)  : lerp(originalHue[1], originalHue[0], -LightroomOrangeHueshift);
  huefactors[2]	= (LightroomYellowHueshift  > 0) ? lerp(originalHue[2], originalHue[3], LightroomYellowHueshift)  : lerp(originalHue[2], originalHue[1], -LightroomYellowHueshift);
  huefactors[3] 	= (LightroomGreenHueshift   > 0) ? lerp(originalHue[3], originalHue[4], LightroomGreenHueshift)   : lerp(originalHue[3], originalHue[2], -LightroomGreenHueshift);
  huefactors[4] 	= (LightroomAquaHueshift    > 0) ? lerp(originalHue[4], originalHue[5], LightroomAquaHueshift) 	: lerp(originalHue[4], originalHue[3], -LightroomAquaHueshift);
  huefactors[5] 	= (LightroomBlueHueshift    > 0) ? lerp(originalHue[5], originalHue[6], LightroomBlueHueshift) 	: lerp(originalHue[5], originalHue[4], -LightroomBlueHueshift);
  huefactors[6]	= (LightroomMagentaHueshift > 0) ? lerp(originalHue[6], originalHue[7], LightroomMagentaHueshift) : lerp(originalHue[6], originalHue[5], -LightroomMagentaHueshift);
}
struct CurvesStruct
{
  float2 levels;
  float exposure;
  float gamma;
  float contrast;
  float blacks;
  float shadows;
  float midtones;
  float highlights;
  float whites;
};
struct PaletteStruct
{
  float hue[7];
  float saturation[7];
  float exposure[7];
};
struct VignetteStruct
{
  float2 ratio;
  float2 radii;
  float amount;
  float curve;
  int blend;
  bool debug;
};
CurvesStruct SetupCurves()
{
  CurvesStruct Curves;
  Curves.levels = float2(LightroomGlobalBlackLevel, LightroomGlobalWhiteLevel) * rcp(255.0);
  Curves.exposure = exp2(LightroomGlobalExposure);
  Curves.gamma = exp2(-LightroomGlobalGamma);
  Curves.contrast = LightroomGlobalContrast;
  Curves.blacks = exp2(-LightroomGlobalBlacksCurve);
  Curves.shadows = exp2(-LightroomGlobalShadowsCurve);
  Curves.midtones = exp2(-LightroomGlobalMidtonesCurve);
  Curves.highlights = exp2(-LightroomGlobalHighlightsCurve);
  Curves.whites = exp2(-LightroomGlobalWhitesCurve);
  return Curves;
}
PaletteStruct SetupPalette()
{
  PaletteStruct Palette;
  Palette.hue[0] = LightroomRedHueshift;
  Palette.hue[1] = LightroomOrangeHueshift;
  Palette.hue[2] = LightroomYellowHueshift;
  Palette.hue[3] = LightroomGreenHueshift;
  Palette.hue[4] = LightroomAquaHueshift;
  Palette.hue[5] = LightroomBlueHueshift;
  Palette.hue[6] = LightroomMagentaHueshift;
  Palette.saturation[0] = LightroomRedSaturation;
  Palette.saturation[1] = LightroomOrangeSaturation;
  Palette.saturation[2] = LightroomYellowSaturation;
  Palette.saturation[3] = LightroomGreenSaturation;
  Palette.saturation[4] = LightroomAquaSaturation;
  Palette.saturation[5] = LightroomBlueSaturation;
  Palette.saturation[6] = LightroomMagentaSaturation;
  Palette.exposure[0] = LightroomRedExposure;
  Palette.exposure[1] = LightroomOrangeExposure;
  Palette.exposure[2] = LightroomYellowExposure;
  Palette.exposure[3] = LightroomGreenExposure;
  Palette.exposure[4] = LightroomAquaExposure;
  Palette.exposure[5] = LightroomBlueExposure;
  Palette.exposure[6] = LightroomMagentaExposure;
  return Palette;
}
VignetteStruct SetupVignette()
{
  VignetteStruct Vignette;
  Vignette.ratio = float2(LightroomVignetteWidth,LightroomVignetteHeight);
  Vignette.radii = float2(LightroomVignetteRadiusInner, LightroomVignetteRadiusOuter);
  Vignette.amount = LightroomVignetteAmount;
  Vignette.curve = LightroomVignetteCurve;
  Vignette.blend = LightroomVignetteBlendMode;
  Vignette.debug = LightroomVignetteShowRadii;
  return Vignette;
}
float3 RgbToHcv(in float3 RGB)
{
  RGB = saturate(RGB);
  float Epsilon = 1e-10;
  float4 P = (RGB.g < RGB.b) ? float4(RGB.bg, -1.0, 2.0/3.0) : float4(RGB.gb, 0.0, -1.0/3.0);
  float4 Q = (RGB.r < P.x) ? float4(P.xyw, RGB.r) : float4(RGB.r, P.yzx);
  float C = Q.x - min(Q.w, Q.y);
  float H = abs((Q.w - Q.y) / (6 * C + Epsilon) + Q.z);
  return float3(H, C, Q.x);
}
float3 RgbToHsl(in float3 RGB)
{
  float3 HCV = RgbToHcv(RGB);
  float L = HCV.z - HCV.y * 0.5;
  float S = HCV.y / (1.0000001 - abs(L * 2 - 1));
  return float3(HCV.x, S, L);
}
float3 HslToRgb(in float3 HSL)
{
  HSL = saturate(HSL);
  float3 RGB = saturate(float3(abs(HSL.x * 6.0 - 3.0) - 1.0,2.0 - abs(HSL.x * 6.0 - 2.0),2.0 - abs(HSL.x * 6.0 - 4.0)));
  float C = (1 - abs(2 * HSL.z - 1)) * HSL.y;
  return (RGB - 0.5) * C + HSL.z;
}
float LinearStep(float lower, float upper, float value)
{
  return saturate((value-lower)/(upper-lower));
}
float3 GetFunctionGraph(float2 coords, float F, float3 origcolor, float thickness)
{
  F -= coords.y;
  float DistanceField = abs(F) / length(float2(ddx(F) / ddx(coords.x), -1.0));
  return lerp(origcolor, 1 - origcolor, smoothstep(qUINT::PixelSize.y*thickness, 0.0, DistanceField));
}
float3 GetVignette(float3 color, float2 uv, VignetteStruct v)
{
  float2 vign_uv = uv * 2 - 1;
  vign_uv -= vign_uv * v.ratio;
  float vign_gradient = length(vign_uv);
  float vignette = LinearStep(v.radii.x, v.radii.y, vign_gradient);
  vignette = pow(vignette, v.curve + 1e-6) * v.amount;
  color = (v.blend == 0) ? color * saturate(1 - vignette) : color;
  color = (v.blend == 1) ? saturate(color - vignette.xxx) : color;
  color = (v.blend == 2) ? 1 - (1 - color) * (vignette + 1) : color;
  color = (v.blend == 3) ? color * saturate(lerp(1 - vignette * 2 , 1, dot(color, 0.333))) : color;
  if(v.debug)
  {
    float2 radii_sdf = abs(vign_gradient - v.radii);
    radii_sdf *= qUINT::PixelSize.yy / fwidth(radii_sdf);
    radii_sdf = saturate(1 - 200 * radii_sdf);
    color = lerp(color, float3(0.0,1.0,0.0), radii_sdf.x);
    color = lerp(color, float3(1.0,0.0,0.0), radii_sdf.y);
  }
  return color;
}
float Curves(in float x, in CurvesStruct c)
{
  x = LinearStep(c.levels.x, c.levels.y, x);
  x = saturate(pow(x * c.exposure, c.gamma));
  float blacks_mult   	= smoothstep(0.25, 0.00, x);
  float shadows_mult  	= smoothstep(0.00, 0.25, x) * smoothstep(0.50, 0.25, x);
  float midtones_mult 	= smoothstep(0.25, 0.50, x) * smoothstep(0.75, 0.50, x);
  float highlights_mult  	= smoothstep(0.50, 0.75, x) * smoothstep(1.00, 0.75, x);
  float whites_mult  		= smoothstep(0.75, 1.00, x);
  x = pow(x, exp2(blacks_mult * c.blacks
    + shadows_mult * c.shadows
    + midtones_mult * c.midtones
    + highlights_mult * c.highlights
    + whites_mult * c.whites
    - 1));
  x = lerp(x, x * x * (3 - 2 * x), c.contrast);
  return saturate(x);
}
void DrawLUT(inout float3 color, in float2 vpos, in float tile_size, in float tile_amount, in float scroll)
{
  float2 pixelcoord = vpos.xy;
  pixelcoord.x += scroll * BUFFER_WIDTH;
  if(pixelcoord.x < tile_size * tile_amount && pixelcoord.y < tile_size)
  {
    color.rg = frac(pixelcoord.xy / tile_size) - 0.5 / tile_size;
    color.rg /= 1.0 - rcp(tile_size);
    color.b  = floor(pixelcoord.x / tile_size)/(tile_amount - 1);
    color.rgb = floor(color.rgb * 255.0) / 255.0;
  }
}
void DrawLUT4096x64(inout float3 color, in float2 vpos)
{
  color.rgb = vpos.xyx / 64.0;
  color.rg = frac(color.rg) - 0.5 / 64.0;
  color.rg /= 1.0 - 1.0 / 64.0;
  color.b = floor(color.b) / (64.0 - 1);
}
void ReadLUT4096x64(inout float3 color)
{
  float4 lut_coord;
  lut_coord.xyz = color.rgb * 63.0;
  lut_coord.xy = (lut_coord.xy + 0.5) / float2(4096.0, 64.0);
  lut_coord.x += floor(lut_coord.z) / 64.0;
  lut_coord.z = frac(lut_coord.z);
  lut_coord.w = lut_coord.x + 0.015625;
  color.rgb = lerp(tex2D(sLUTTexInternal, lut_coord.xy).rgb, tex2D(sLUTTexInternal, lut_coord.wy).rgb, lut_coord.z);
}
float3 Palette(in float3 hsl_color, in PaletteStruct p, in float huefactors[7])
{
  float huemults[7] =
  {
    max(saturate(1.0 - abs((hsl_color.x -  0.0/12) * 12.0)),
    saturate(1.0 - abs((hsl_color.x - 12.0/12) * 6.0))),
    saturate(1.0 - abs((hsl_color.x -  1.0/12) * 12.0)),
    max(saturate(1.0 - abs((hsl_color.x -  2.0/12) * 12.0)) * step(hsl_color.x,2.0/12.0),
    saturate(1.0 - abs((hsl_color.x -  2.0/12) * 6.0)) * step(2.0/12.0,hsl_color.x)),
    saturate(1.0 - abs((hsl_color.x -  4.0/12) * 6.0)),
    saturate(1.0 - abs((hsl_color.x -  6.0/12) * 6.0)),
    saturate(1.0 - abs((hsl_color.x -  8.0/12) * 6.0)),
    saturate(1.0 - abs((hsl_color.x - 10.0/12) * 6.0))
  };
  float3 tcolor = 0;
  for(int i=0; i < 7; i++)
    tcolor += huemults[i] * HslToRgb(float3(huefactors[i], saturate(hsl_color.y + hsl_color.y * p.saturation[i]), hsl_color.z * exp2(sqrt(hsl_color.y) * p.exposure[i] * (1 - hsl_color.z) * hsl_color.y)));
  return tcolor;
}
#if(ENABLE_HISTOGRAM == 1)
void PsHistogramGenerate(float4 vpos : SV_Position, float2 uv : TEXCOORD, out float4 res : SV_Target0)
{
  res = 0;float4 coord = 0;
  coord.z = rcp(LightroomHistogramSamples);
  float2 histogram_data = float2(HISTOGRAM_BINS_NUM, vpos.x) / LightroomHistogramSmoothness;
  [loop]
  for(int x = 0; x < LightroomHistogramSamples; x++)
  {
    coord.y = 0;
    [loop]
    for(int y = 0; y < LightroomHistogramSamples; y++)
    {
      res.xyz += saturate(1.0 - abs(tex2Dlod(qUINT::SBackBufferTex,coord).xyz * histogram_data.xxx - histogram_data.yyy));
      coord.y += coord.z;
    }
    coord.x += coord.z;
  }
  res.xyz /= LightroomHistogramSmoothness;
}
#endif
void PsProcessLUT(float4 vpos : SV_Position, float2 uv : TEXCOORD0, nointerpolation float huefactors[7] : TEXCOORD1, out float4 color : SV_Target0)
{
  const CurvesStruct CurvesInst = SetupCurves();
  const PaletteStruct PaletteInst = SetupPalette();
  DrawLUT4096x64(color.rgb, vpos.xy);
  color.a = 1;
  color.r = Curves(color.r, CurvesInst);
  color.g = Curves(color.g, CurvesInst);
  color.b = Curves(color.b, CurvesInst);
  float3 hsl_color = RgbToHsl(color.rgb);
  color.rgb = LightroomGlobalTemperature > 0 ? lerp(color.rgb, HslToRgb(float3(0.06111, 1.0, hsl_color.z)), LightroomGlobalTemperature) : lerp(color.rgb, HslToRgb(float3(0.56111, 1.0, hsl_color.z)), -LightroomGlobalTemperature);
  color.rgb = LightroomGlobalTemperature > 0 ? lerp(color.rgb, HslToRgb(float3(0.31111, 1.0, hsl_color.z)), LightroomGlobalTint) : lerp(color.rgb, HslToRgb(float3(0.81111, 1.0, hsl_color.z)), -LightroomGlobalTint);
  hsl_color = RgbToHsl(color.rgb);
  hsl_color.y = saturate(hsl_color.y + hsl_color.y * LightroomGlobalSaturation);
  hsl_color.y = pow(hsl_color.y,exp2(-LightroomGlobalVibrance));
  hsl_color = saturate(hsl_color);
  color.rgb = Palette(hsl_color, PaletteInst, huefactors);
}
void PsApplyLUT(float4 vpos : SV_Position, float2 uv : TEXCOORD0, nointerpolation float huefactors[7] : TEXCOORD1, out float4 color : SV_Target0)
{
  color = tex2D(qUINT::SBackBufferTex, uv);
  if(LightroomEnableLUT)
    DrawLUT(color.rgb, vpos.xy, LightroomLUTTileSize, LightroomLUTTileCount, LightroomLUTScroll);
  ReadLUT4096x64(color.rgb);
}
void PsDisplayStatistics(float4 vpos : SV_Position, float2 uv : TEXCOORD0, nointerpolation float huefactors[7] : TEXCOORD1, out float4 res : SV_Target0)
{
  const CurvesStruct CurvesInst = SetupCurves();
  const VignetteStruct Vignette = SetupVignette();
  float4 color = tex2D(qUINT::SBackBufferTex,uv);
  if(LightroomEnableVignette) color.rgb = GetVignette(color.rgb, uv, Vignette);
  float2 vposfbl = float2(vpos.x, BUFFER_HEIGHT-vpos.y);
  float2 vposfbl_n = vposfbl / 255.0;
  color.rgb = (LightroomEnableClippingDisplay && dot(color.rgb, 1.0) >= 3.0) ? float3(1.0,0.0,0.0) : color.rgb;
  color.rgb = (LightroomEnableClippingDisplay && dot(color.rgb, 1.0) <= 0.0) ? float3(0.0,0.0,1.0) : color.rgb;
  #if(ENABLE_HISTOGRAM == 1)
  if(LightroomEnableHistogram || LightroomEnableCurveDisplay)
  {
    float luma_curve = Curves(vposfbl_n.x, CurvesInst);
    float3 histogram = tex2Dlod(sHistogramTex, vposfbl_n.xyxy).xyz / (LightroomHistogramSamples * LightroomHistogramSamples) * LightroomHistogramHeight;
    if(all(saturate(-vposfbl_n * vposfbl_n + vposfbl_n)))
    {
      color.rgb = LightroomEnableHistogram ? vposfbl_n.yyy < histogram.xyz : color.rgb;
      color.rgb = LightroomEnableCurveDisplay ? GetFunctionGraph(vposfbl_n.xy, luma_curve, color.rgb, 20.0) : color.rgb;
    }
  }
  #else
  if(LightroomEnableCurveDisplay)
  {
    float luma_curve = Curves(vposfbl_n.x, CurvesInst);
    if(all(saturate(-vposfbl_n * vposfbl_n + vposfbl_n)))
      color.rgb = LightroomEnableCurveDisplay ? GetFunctionGraph(vposfbl_n.xy, luma_curve, color.rgb, 20.0) : color.rgb;
  }
  #endif
  res.xyz = color.xyz;
  res.w = 1.0;
}
technique Lightroom
< ui_tooltip = "                      >> qUINT::Lightroom <<\n\n"
"Lightroom Is A Color Grading Toolbox That Offers A Multitude\n"
"Of Features Commonly Found In Color Grading Software - \n"
"You Can Do Deep Color Modifications + Adjust Contrast & Levels + \n"
"Tweak Color Balance + View A Histogram & Bake The CC Into A 3D LUT - \n"
"Lightroom Is Written By Marty McFly / Pascal Gilcher"; >
{
  pass PProcessLUT
  {
    VertexShader = VsLightroom;
    PixelShader = PsProcessLUT;
    RenderTarget = LUTTexInternal;
  }
  pass PApplyLUT
  {
    VertexShader = VsLightroom;
    PixelShader = PsApplyLUT;
  }
  #if(ENABLE_HISTOGRAM == 1)
  pass PHistogramGenerate
  {
    VertexShader = PostProcessVS;
    PixelShader = PsHistogramGenerate;
    RenderTarget = HistogramTex;
  }
  #endif
  pass PHistogram
  {
    VertexShader = VsLightroom;
    PixelShader = PsDisplayStatistics;
  }
}