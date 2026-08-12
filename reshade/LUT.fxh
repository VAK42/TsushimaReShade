#ifndef flutTextureName
#define flutTextureName "Color.png"
#endif
#ifndef flutTileSizeXy
#define flutTileSizeXy 64
#endif
#ifndef flutTileAmount
#define flutTileAmount 64
#endif
#ifndef flutLUTAmount
#define flutLUTAmount 61
#endif
#include "ReShadeUI.fxh"
uniform int FlutLUTSelector <
  ui_type = "combo";
  ui_items="No Color Grade\0(50's Post Card)\0(300)\0Alien\0Batman VS Superman\0Book of Eli\0Brannan - Instagram\0Breaking Bad\0Captain America: Civil War\0Casino Royal - BW\0Casino Royal 2- BW\0The Conjuring\0Dark Age\0Dark Science Fiction\0Diesel Punk\0Drive\0Early Bird - Instagram\0(50's Filmstock)\0Fuel\0Game of Thrones\0Gone Girl\0Grand Budapest Hotel\0Gravity\0Guardians of the Galaxy\0Harry Poter\0HDR - Instagram\0House of Cards\0Indiana Jones\0Inglorious Bastards\0Inkwell - Instagram\0Interstellar\0Lo-Fi - Instagram\0Lord Kelvin - Instagram\0Lord of the Ring\0Mad Max: Fury Road\0Matrix\0Minority Report\0Mision Impossible\0Moonrise Kingdom\0Nashville - Instagram\0Noir I\0Noir II\0Noir III\0Nuclear Desert\0Post Apocalypse\0Prometheus\0The Revenant\0The Ring\0Saving Private Ryan\0Sky Fall\0Star Wars: The Force Awakens\0Suicide Squad\0Sutro - Instagram\0Teal Cold\0Tron\0Vintage Seventys\0Vintage Warm\0Walden - Instagram\0The Walking Dead\0Washed Light - Instagram\0";
  ui_label = "The LUT to Use";
  ui_tooltip = "The LUT To Use For Color Transformation - 'Neutral' Doesn't Do Any Color Transformation";
> = 0;
uniform float FlutAmountChroma < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.00; ui_max = 1.00;
  ui_label = "LUT Chroma Amount";
  ui_tooltip = "Intensity Of Color/Chroma Change Of The LUT";
> = 1.00;
uniform float FlutAmountLuma < __UNIFORM_SLIDER_FLOAT1
  ui_min = 0.00; ui_max = 1.00;
  ui_label = "LUT Luma Amount";
  ui_tooltip = "Intensity Of Luma Change Of The LUT";
> = 1.00;
#include "ReShade.fxh"
texture texMultiLUT < source = flutTextureName; > { Width = flutTileSizeXy*flutTileAmount; Height = flutTileSizeXy * flutLUTAmount; Format = RGBA8; };
sampler	SamplerMultiLUT { Texture = texMultiLUT; };
void PsMultiLUTApply(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 res : SV_Target0)
{
  float4 color = tex2D(ReShade::BackBuffer, texcoord.xy);
  float2 texelsize = 1.0 / flutTileSizeXy;
  texelsize.x /= flutTileAmount;
  float3 lutcoord = float3((color.xy*flutTileSizeXy-color.xy+0.5)*texelsize.xy,color.z*flutTileSizeXy-color.z);
  lutcoord.y /= flutLUTAmount;
  lutcoord.y += (float(FlutLUTSelector)/ flutLUTAmount);
  float lerpfact = frac(lutcoord.z);
  lutcoord.x += (lutcoord.z-lerpfact)*texelsize.y;
  float3 lutcolor = lerp(tex2D(SamplerMultiLUT, lutcoord.xy).xyz, tex2D(SamplerMultiLUT, float2(lutcoord.x+texelsize.y,lutcoord.y)).xyz,lerpfact);
  color.xyz = lerp(normalize(color.xyz), normalize(lutcolor.xyz), FlutAmountChroma) *
    lerp(length(color.xyz),    length(lutcolor.xyz),    FlutAmountLuma);
  res.xyz = color.xyz;
  res.w = 1.0;
}
technique MultiLUT
{
  pass MultiLUTApply
  {
    VertexShader = PostProcessVS;
    PixelShader = PsMultiLUTApply;
  }
}