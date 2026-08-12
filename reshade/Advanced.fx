#include "ReShadeUI.fxh"
uniform float3 ColorRed < __UNIFORM_SLIDER_FLOAT3
  ui_min = 0.0; ui_max = 1.0;
  ui_label = "Red Tint";
  ui_category = "Tint Correction";
  ui_tooltip = "Adjust The Value Of Red Tint";
> = float3(0.800, 0.200, 0.000);
uniform float3 ColorGreen < __UNIFORM_SLIDER_FLOAT3
  ui_min = 0.0; ui_max = 1.0;
  ui_label = "Green Tint";
  ui_category = "Tint Correction";
  ui_tooltip = "Adjust The Value Of Green Tint";
> = float3(0.200, 0.655, 0.000);
uniform float3 ColorBlue < __UNIFORM_SLIDER_FLOAT3
  ui_min = 0.0; ui_max = 1.0;
  ui_label = "Blue Tint";
  ui_category = "Tint Correction";
  ui_tooltip = "Adjust The Value Of Blue Tint";
> = float3(0.200, 0.000, 0.900);
uniform float Strength < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.0; ui_max = 1.0;
  ui_label = "Strength";
  ui_category = "Tint Correction";
  ui_tooltip = "Adjust The Effect Strength";
> = 0.500;
#include "ReShade.fxh"
float3 ColorPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
  const float3x3 ColorMatrix = float3x3(ColorRed, ColorGreen, ColorBlue);
  color = lerp(color, mul(ColorMatrix, color), Strength);
  return saturate(color);
}
uniform float SharpStrength < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.1; ui_max = 3.0;
  ui_label = "Strength";
  ui_category = "Sharpness";
  ui_tooltip = "Strength Of The Sharpening";
> = 3.00;
uniform float SharpClamp < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.0; ui_max = 1.0; ui_step = 0.005;
  ui_label = "Limit";
  ui_category = "Sharpness";
  ui_tooltip = "Limits Maximum Amount Of Sharpening A Pixel Receives";
> = 0.020;
uniform int Pattern <
  ui_type = "combo";
  ui_items =	"Fast" "\0"
  "Normal" "\0"
  "Wider"	"\0"
  "Pyramid shaped" "\0";
  ui_label = "Pattern Samples";
  ui_category = "Sharpness";
  ui_tooltip = "Choose A Pattern Sampling Method - Fast Is Faster But Slightly Lower Quality - Normal Is Normal - Wider Is Less Sensitive To Noise But Also To Fine Details - Pyramid Has A Slightly More Aggressive Look";
> = 1;
uniform float OffsetBias < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.0; ui_max = 6.0;
  ui_label = "Offset";
  ui_category = "Sharpness";
  ui_tooltip = "Offset Adjusts The Radius Of The Sampling Pattern";
> = 0.960;
#include "ReShade.fxh"
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
  return saturate(OutputColor);
}
uniform int Mode <
  ui_type = "combo";
  ui_label = "Mode";
  ui_category = "Curve Adjustment";
  ui_items = "Luma\0Chroma\0Both Luma & Chroma\0";
  ui_tooltip = "Choose Any One To Apply It";
> = 0;
uniform int Formula <
  ui_type = "combo";
  ui_label = "Formula";
  ui_category = "Curve Adjustment";
  ui_items = "Sine\0Abs split\0Smoothstep\0Exp formula\0Simplified Catmull-Rom (0,0,1,1)\0Perlins Smootherstep\0Abs add\0Techicolor Cinestyle\0Parabola\0Half-circles\0Polynomial split\0";
  ui_tooltip = "Adjust The Contrast S-Curve";
> = 2;
uniform float Contrast < __UNIFORM_SLIDER_FLOAT1
  ui_label = "Contrast";
  ui_category = "Curve Adjustment";
  ui_min = -1.0; ui_max = 1.0;
  ui_tooltip = "Adjust The Contrast Strength";
> = 0.42;
#include "ReShade.fxh"
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
    float3 color = luma + x;
    ColorInput.rgb = lerp(ColorInput.rgb, color, ContrastBlend);
  }
  else
  {
    float3 color = x;
    ColorInput.rgb = lerp(ColorInput.rgb, color, ContrastBlend);
  }
  return ColorInput;
}
uniform float3 ColorStrength < __UNIFORM_COLOR_FLOAT3
  ui_label = "Color Strength";
  ui_tooltip = "Higher Means Darker & More Intense Colors";
  ui_category = "Color Correction - Regular";
> = float3(0.2, 0.2, 0.2);
uniform float Brightness < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.5; ui_max = 1.5;
  ui_label = "Brightness";
  ui_category = "Color Correction - Regular";
  ui_tooltip = "Adjust Brightness";
> = 1.50;
uniform float Saturation < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.0; ui_max = 1.5;
  ui_label = "Saturation";
  ui_category = "Color Correction - Regular";
  ui_tooltip = "Adjust The Saturation Level";
> = 0.810;
uniform float Strength1 < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.0; ui_max = 1.0;
  ui_label = "Strength";
  ui_category = "Color Correction - Regular";
  ui_tooltip = "Adjust The Strength Of The Color Correction";
> = 0.613;
#include "ReShade.fxh"
float3 TechnicolorPass(float4 vpos : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float3 color = saturate(tex2D(ReShade::BackBuffer, texcoord).rgb);
  float3 temp = 1.0 - color;
  float3 target = temp.grg;
  float3 target2 = temp.bbr;
  float3 temp2 = color * target;
  temp2 *= target2;
  temp = temp2 * ColorStrength;
  temp2 *= Brightness;
  target = temp.grg;
  target2 = temp.bbr;
  temp = color - target;
  temp += temp2;
  temp2 = temp - target2;
  color = lerp(color, temp2, Strength1);
  color = lerp(dot(color, 0.333), color, Saturation);
  return color;
}
uniform float Exposure < __UNIFORM_SLIDER_FLOAT1
  ui_min = -1.0; ui_max = 1.0;
  ui_label = "Exposure";
  ui_category = "Color Correction - Advanced";
  ui_tooltip = "Adjust Exposure";
> = -0.340;
uniform float Gamma < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.0; ui_max = 2.0;
  ui_label = "Gamma";
  ui_category = "Color Correction - Advanced";
  ui_tooltip = "Adjust Midtones - 1.0 Is Neutral - This Setting Does Exactly The Same As The One In Lift Gamma Gain + Only With Less Control";
> = 1.0;
uniform float Bleach < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.0; ui_max = 1.0;
  ui_label = "Bleach";
  ui_category = "Color Correction - Advanced";
  ui_tooltip = "Brightens The Shadows & Fades The Colors";
> = 0.590;
uniform float Defog < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.0; ui_max = 1.0;
  ui_label = "Tint Remover";
  ui_category = "Color Correction - Advanced";
  ui_tooltip = "How Much Of The Color Tint To Remove";
> = 0.0;
uniform float3 FogColor < __UNIFORM_COLOR_FLOAT3
  ui_label = "Tint Color";
  ui_category = "Color Correction - Advanced";
  ui_tooltip = "Choose Which Tint Color To Remove";
> = float3(0.309803922, 0.02745098, 0.549019608);
#include "ReShade.fxh"
float3 TonemapPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
  float3 color = saturate(tex2D(ReShade::BackBuffer, texcoord).rgb);
  color = saturate(color - Defog * FogColor * 2.55);
  color *= pow(2.0f, Exposure);
  color = pow(color, Gamma);
  const float3 coefLuma = float3(0.2126, 0.7152, 0.0722);
  float lum = dot(coefLuma, color);
  float L = saturate(10.0 * (lum - 0.45));
  float3 A2 = Bleach * color;
  float3 result1 = 2.0f * color * lum;
  float3 result2 = 1.0f - 2.0f * (1.0f - lum) * (1.0f - color);
  float3 newColor = lerp(result1, result2, L);
  float3 mixRgb = A2 * newColor;
  color += ((1.0f - A2) * mixRgb);
  float3 middleGray = dot(color, (1.0 / 3.0));
  float3 diffColor = color - middleGray;
  return color;
}
technique Advanced
{
  pass ColorPass {VertexShader = PostProcessVS;PixelShader = ColorPass;}
  pass TonemapPass {VertexShader = PostProcessVS;PixelShader = TonemapPass;}
  pass CurvesPass {VertexShader = PostProcessVS;PixelShader = CurvesPass;}
  pass LumaSharpen {VertexShader = PostProcessVS;PixelShader = LumaSharpenPass;}
  pass Technicolor2 {VertexShader = PostProcessVS;PixelShader = TechnicolorPass;}
}