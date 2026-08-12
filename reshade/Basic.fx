#include "ReShadeUI.fxh"
#include "ReShade.fxh"
uniform float LightIntensity < __UNIFORM_SLIDER_FLOAT1
  ui_min = -0.400; ui_max = 0.400;
  ui_label = "Intensity";
  ui_tooltip = "Adjust Light Intensity + Plus For Stronger Intensity & Minus For Weaker Intensity";
  ui_category = "Color Correction";
> = 0.050;
uniform float DarkLevel < __UNIFORM_SLIDER_FLOAT1
  ui_min = -0.400; ui_max = 0.400;
  ui_label = "Levels";
  ui_tooltip = "Adjust Darkness + Minus For Brighter & Plus For Darker";
  ui_category = "Color Correction";
> = 0.087;
uniform float Color < __UNIFORM_SLIDER_FLOAT1
  ui_min = -1.0; ui_max = 1.0;
  ui_label = "Saturation";
  ui_tooltip = "Adjust Saturation + Minus For Pale Colors & Plus For Vivid Colors";
  ui_category = "Color Correction";
> = 0.000;
uniform float Sharpness < __UNIFORM_SLIDER_FLOAT1
  ui_min = -1.0; ui_max = 1.0;
  ui_label = "Sharpness";
  ui_tooltip = "Adjust Sharpness";
  ui_category = "Color Correction";
> = 0.725000;
#define HighlightClipping 0
#define Saturation (0.000  + Color)
#define Exposure 0.100
#define Bleach 0.000
#define Defog 0.100
#define FogColor float3(0.070000,0.04000,0.070000)
#define SphericalAmount 0.150
#define CurveHeight 0.3000
#define CurveSlope 0.500000
#define LOvershoot 0.003000
#define LComprLow 0.167000
#define LComprHigh 0.334000
#define DOvershoot 0.009000
#define DComprLow 0.450000
#define DComprHigh 0.700000
#define ScaleLim 0.100000
#define ScaleCs 0.056000
#define PmP 0.700000A
#define Amount -1.000000
#define Center float2(0.500000,0.500000)
#define Radius 2.000000
#define Ratio 0.500000
#define Slope 2
#define Type 0
#include "ReShade.fxh"
float4 VignettePass(float4 vpos : SV_Position, float2 tex : TexCoord) : SV_Target
{
  float4 ColorVal = tex2D(ReShade::BackBuffer, tex);
  if (Type == 0)
  {
    float2 DistanceXy = tex - Center;
    DistanceXy *= float2((BUFFER_RCP_HEIGHT / BUFFER_RCP_WIDTH), Ratio);
    DistanceXy /= Radius;
    float distance = dot(DistanceXy, DistanceXy);
    ColorVal.rgb *= (1.0 + pow(distance, Slope * 0.5) * Amount);
  }
  if (Type == 1)
  {
    tex = -tex * tex + tex;
    ColorVal.rgb = saturate(((BUFFER_RCP_HEIGHT / BUFFER_RCP_WIDTH)*(BUFFER_RCP_HEIGHT / BUFFER_RCP_WIDTH) * Ratio * tex.x + tex.y) * 4.0) * ColorVal.rgb;
  }
  if (Type == 2)
  {
    tex = -tex * tex + tex;
    ColorVal.rgb = saturate(tex.x * tex.y * 100.0) * ColorVal.rgb;
  }
  if (Type == 3)
  {
    tex = abs(tex - 0.5);
    float tc = dot(float4(-tex.x, -tex.x, tex.x, tex.y), float4(tex.y, tex.y, 1.0, 1.0));
    tc = saturate(tc - 0.495);
    ColorVal.rgb *= (pow((1.0 - tc * 200), 4) + 0.25);
  }
  if (Type == 4)
  {
    tex = abs(tex - 0.5);
    float tc = dot(float4(-tex.x, -tex.x, tex.x, tex.y), float4(tex.y, tex.y, 1.0, 1.0));
    tc = saturate(tc - 0.495) - 0.0002;
    ColorVal.rgb *= (pow((1.0 - tc * 200), 4) + 0.0);
  }
  if (Type == 5)
  {
    tex = abs(tex - 0.5);
    float tc = tex.x * (-2.0 * tex.y + 1.0) + tex.y;
    tc = saturate(tc - 0.495);
    ColorVal.rgb *= (pow((-tc * 200 + 1.0), 4) + 0.25);
  }
  if (Type == 6)
  {
    float tex_xy = dot(float4(tex, tex), float4(-tex, 1.0, 1.0));
    ColorVal.rgb = saturate(tex_xy * 4.0) * ColorVal.rgb;
  }
  return ColorVal;
}
#define Gamma 0.800
float3 TonemapPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float3 ColorVal = tex2D(ReShade::BackBuffer, texcoord).rgb;
  ColorVal = saturate(ColorVal - Defog * FogColor * 2.55);
  ColorVal *= pow(2.0f, Exposure);
  ColorVal = pow(ColorVal, Gamma);
  const float3 CoefLuma = float3(0.2126, 0.7152, 0.0722);
  float lum = dot(CoefLuma, ColorVal);
  float L = saturate(10.0 * (lum - 0.45));
  float3 A2 = Bleach * ColorVal;
  float3 result1 = 2.0f * ColorVal * lum;
  float3 result2 = 1.0f - 2.0f * (1.0f - lum) * (1.0f - ColorVal);
  float3 newColor = lerp(result1, result2, L);
  float3 mixRGB = A2 * newColor;
  ColorVal += ((1.0f - A2) * mixRGB);
  float3 MiddleGray = dot(ColorVal, (1.0 / 3.0));
  float3 DiffColor = ColorVal - MiddleGray;
  ColorVal = (ColorVal + DiffColor * Saturation) / (1 + (DiffColor * Saturation));
  return ColorVal;
}
#define RGBGain float3(0.750000+LightIntensity,0.750000+LightIntensity,0.90000+LightIntensity)
#define RGBGamma float3(1.000000,1.000000,1.020000)
#define RGBLift float3(1.046000-DarkLevel,1.027000-DarkLevel,1.009000-DarkLevel)
float3 NyukNyang(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float3 ColorVal = tex2D(ReShade::BackBuffer, texcoord).rgb;
  ColorVal = ColorVal * (1.5 - 0.5 * RGBLift) + 0.5 * RGBLift - 0.5;
  ColorVal = saturate(ColorVal);
  ColorVal *= RGBGain;
  ColorVal = pow(abs(ColorVal), 1.0 / RGBGamma);
  return saturate(ColorVal);
}
#define BlackPoint 0
#define WhitePoint 255
float3 LevelsPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float BlackPointFloat = BlackPoint / 255.0;
  float WhitePointFloat = WhitePoint == BlackPoint ? (255.0 / 0.00025) : (255.0 / (WhitePoint - BlackPoint));
  float3 ColorVal = tex2D(ReShade::BackBuffer, texcoord).rgb;
  ColorVal = ColorVal * WhitePointFloat - (BlackPointFloat *  WhitePointFloat);
  if (HighlightClipping)
  {
    float3 ClippedColors;
    ClippedColors = any(ColorVal > saturate(ColorVal))
      ? float3(1.0, 0.0, 0.0)
      : ColorVal;
    ClippedColors = all(ColorVal > saturate(ColorVal))
      ? float3(1.0, 1.0, 0.0)
      : ClippedColors;
    ClippedColors = any(ColorVal < saturate(ColorVal))
      ? float3(0.0, 0.0, 1.0)
      : ClippedColors;
    ClippedColors = all(ColorVal < saturate(ColorVal))
      ? float3(0.0, 1.0, 1.0)
      : ClippedColors;
    ColorVal = ClippedColors;
  }
  return ColorVal;
}
float3 SphericalPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float3 ColorVal = tex2D(ReShade::BackBuffer, texcoord).rgb;
  float3 SignedColor = ColorVal.rgb * 2.0 - 1.0;
  float3 SphericalColor = sqrt(1.0 - SignedColor.rgb * SignedColor.rgb);
  SphericalColor = SphericalColor * 0.5 + 0.5;
  SphericalColor *= ColorVal.rgb;
  ColorVal.rgb += SphericalColor.rgb * SphericalAmount;
  ColorVal.rgb *= 0.95;
  return ColorVal.rgb;
}
#define Contrast 0.650000 + Color
#define Formula 4
#define Mode 1
float4 CurvesPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float4 ColorInput = tex2D(ReShade::BackBuffer, texcoord);
  float3 LumCoeff = float3(0.2126, 0.7152, 0.0722);
  float ContrastBlend = Contrast;
  const float PI = 3.1415927;
  float luma = dot(LumCoeff, ColorInput.rgb);
  float3 chroma = ColorInput.rgb - luma;
  float3 x;
  if (Mode == 0)
    x = luma;
  else if (Mode == 1)
    x = chroma,
    x = x * 0.5 + 0.5;
  else
    x = ColorInput.rgb;
  if (Formula == 0)
  {
    x = sin(PI * 0.5 * x);
    x *= x;
  }
  if (Formula == 1)
  {
    x = x - 0.5;
    x = (x / (0.5 + abs(x))) + 0.5;
  }
  if (Formula == 2)
  {
    x = x*x*(3.0 - 2.0*x);
  }
  if (Formula == 3)
  {
    x = (1.0524 * exp(6.0 * x) - 1.05248) / (exp(6.0 * x) + 20.0855);
  }
  if (Formula == 4)
  {
    x = x * (x * (1.5 - x) + 0.5);
    ContrastBlend = Contrast * 2.0;
  }
  if (Formula == 5)
  {
    x = x*x*x*(x*(x*6.0 - 15.0) + 10.0);
  }
  if (Formula == 6)
  {
    x = x - 0.5;
    x = x / ((abs(x)*1.25) + 0.375) + 0.5;
  }
  if (Formula == 7)
  {
    x = (x * (x * (x * (x * (x * (x * (1.6 * x - 7.2) + 10.8) - 4.2) - 3.6) + 2.7) - 1.8) + 2.7) * x * x;
  }
  if (Formula == 8)
  {
    x = -0.5 * (x*2.0 - 1.0) * (abs(x*2.0 - 1.0) - 2.0) + 0.5;
  }
  if (Formula == 9)
  {
    float3 XStep = step(x, 0.5);
    float3 XStepShift = (XStep - 0.5);
    float3 ShiftedX = x + XStepShift;
    x = abs(XStep - sqrt(-ShiftedX * ShiftedX + ShiftedX)) - XStepShift;
    ContrastBlend = Contrast * 0.5;
  }
  if (Formula == 10)
  {
    float3 a = float3(0.0, 0.0, 0.0);
    float3 b = float3(0.0, 0.0, 0.0);
    a = x * x * 2.0;
    b = (2.0 * -x + 4.0) * x - 1.0;
    x = (x < 0.5) ? a : b;
  }
  if (Mode == 0)
  {
    x = lerp(luma, x, ContrastBlend);
    ColorInput.rgb = x + chroma;
  }
  else if (Mode == 1)
  {
    x = x * 2.0 - 1.0;
    float3 ColorVal = luma + x;
    ColorInput.rgb = lerp(ColorInput.rgb, ColorVal, ContrastBlend);
  }
  else
  {
    float3 ColorVal = x;
    ColorInput.rgb = lerp(ColorInput.rgb, ColorVal, ContrastBlend);
  }
  return ColorInput;
}
#define Vibrance 0.211000
#define VibranceRGBBalance float3(1.000000,0.000000,0.000000)
#define VibranceLuma 0
float3 VibrancePass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float3 ColorVal = tex2D(ReShade::BackBuffer, texcoord).rgb;
  float3 CoefLuma = float3(0.212656, 0.715158, 0.072186);
  float luma = dot(CoefLuma, ColorVal);
  float MaxColor = max(ColorVal.r, max(ColorVal.g, ColorVal.b));
  float MinColor = min(ColorVal.r, min(ColorVal.g, ColorVal.b));
  float ColorSaturation = MaxColor - MinColor;
  float3 CoeffVibrance = float3(VibranceRGBBalance * Vibrance);
  ColorVal = lerp(luma, ColorVal, 1.0 + (CoeffVibrance * (1.0 - (sign(CoeffVibrance) * ColorSaturation))));
  return ColorVal;
}
#define OffsetBias 0.500000
#define Pattern 1
#define SharpClamp 0.500000
#define SharpStrength (1.00000 +  Sharpness)
#define ShowSharpen 0
#define CoefLuma float3(0.2126, 0.7152, 0.0722)
float3 LumaSharpenPass(float4 position : SV_Position, float2 tex : TEXCOORD) : SV_Target
{
  float3 ori = tex2D(ReShade::BackBuffer, tex).rgb;
  float3 SharpStrengthLuma = (CoefLuma * SharpStrength);
  float3 BlurOri;
  if (Pattern == 0)
  {
    BlurOri  = tex2D(ReShade::BackBuffer, tex + (BUFFER_PIXEL_SIZE / 3.0) * OffsetBias).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex + (-BUFFER_PIXEL_SIZE / 3.0) * OffsetBias).rgb;
    BlurOri /= 2;
    SharpStrengthLuma *= 1.5;
  }
  if (Pattern == 1)
  {
    BlurOri  = tex2D(ReShade::BackBuffer, tex + float2(BUFFER_PIXEL_SIZE.x, -BUFFER_PIXEL_SIZE.y) * 0.5 * OffsetBias).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex - BUFFER_PIXEL_SIZE * 0.5 * OffsetBias).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex + BUFFER_PIXEL_SIZE * 0.5 * OffsetBias).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex - float2(BUFFER_PIXEL_SIZE.x, -BUFFER_PIXEL_SIZE.y) * 0.5 * OffsetBias).rgb;
    BlurOri *= 0.25;
  }
  if (Pattern == 2)
  {
    BlurOri  = tex2D(ReShade::BackBuffer, tex + BUFFER_PIXEL_SIZE * float2(0.4, -1.2) * OffsetBias).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex - BUFFER_PIXEL_SIZE * float2(1.2, 0.4) * OffsetBias).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex + BUFFER_PIXEL_SIZE * float2(1.2, 0.4) * OffsetBias).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex - BUFFER_PIXEL_SIZE * float2(0.4, -1.2) * OffsetBias).rgb;
    BlurOri *= 0.25;
    SharpStrengthLuma *= 0.51;
  }
  if (Pattern == 3)
  {
    BlurOri  = tex2D(ReShade::BackBuffer, tex + float2(0.5 * BUFFER_PIXEL_SIZE.x, -BUFFER_PIXEL_SIZE.y * OffsetBias)).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex + float2(OffsetBias * -BUFFER_PIXEL_SIZE.x, 0.5 * -BUFFER_PIXEL_SIZE.y)).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex + float2(OffsetBias * BUFFER_PIXEL_SIZE.x, 0.5 * BUFFER_PIXEL_SIZE.y)).rgb;
    BlurOri += tex2D(ReShade::BackBuffer, tex + float2(0.5 * -BUFFER_PIXEL_SIZE.x, BUFFER_PIXEL_SIZE.y * OffsetBias)).rgb;
    BlurOri /= 4.0;
    SharpStrengthLuma *= 0.666;
  }
  float3 sharp = ori - BlurOri;
#if 0
  float SharpLuma = dot(sharp, SharpStrengthLuma);
  SharpLuma = clamp(SharpLuma, -SharpClamp, SharpClamp);
#else
  float4 SharpStrengthLumaClamp = float4(SharpStrengthLuma * (0.5 / SharpClamp),0.5);
  float SharpLuma = saturate(dot(float4(sharp,1.0), SharpStrengthLumaClamp));
  SharpLuma = (SharpClamp * 2.0) * SharpLuma - SharpClamp;
#endif
  float3 OutputColor = ori + SharpLuma;
  if (ShowSharpen)
  {
    OutputColor = saturate(0.5 + (SharpLuma * 4.0)).rrr;
  }
  return saturate(OutputColor);
}
technique Basic
{
  pass LighterBrighter { VertexShader = PostProcessVS; PixelShader = NyukNyang;}
  pass Tonemap {VertexShader = PostProcessVS;PixelShader = TonemapPass;}
  pass SphericalTonemap {VertexShader = PostProcessVS; PixelShader = SphericalPass;}
  pass PostSharpening {VertexShader = PostProcessVS; PixelShader = LumaSharpenPass;}
  pass { VertexShader = PostProcessVS; PixelShader = VignettePass; }
}