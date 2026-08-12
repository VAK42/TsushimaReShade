#ifndef RESHADE_QUINT_COMMON_VERSION
#define RESHADE_QUINT_COMMON_VERSION 206
#endif
#if RESHADE_QUINT_COMMON_VERSION_REQUIRE > RESHADE_QUINT_COMMON_VERSION
#error "Common.fxh Outdated"
#error "Please Download Update From github.com/martymcmodding/quint"
#endif
#if !defined(RESHADE_QUINT_COMMON_VERSION_REQUIRE)
#error "Incompatible Common.fxh & Shaders"
#error "Do Not Mix Different File Versions"
#endif
#if !defined(__RESHADE__) || __RESHADE__ < 40000
#error "ReShade 4.4+ Is Required To Use This Header File"
#endif
#ifndef RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN
#define RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN 0
#endif
#ifndef RESHADE_DEPTH_INPUT_IS_REVERSED
#define RESHADE_DEPTH_INPUT_IS_REVERSED 1
#endif
#ifndef RESHADE_DEPTH_INPUT_IS_LOGARITHMIC
#define RESHADE_DEPTH_INPUT_IS_LOGARITHMIC 0
#endif
#ifndef RESHADE_DEPTH_LINEARIZATION_FAR_PLANE
#define RESHADE_DEPTH_LINEARIZATION_FAR_PLANE 1000.0
#endif
#ifndef RESHADE_DEPTH_MULTIPLIER
#define RESHADE_DEPTH_MULTIPLIER 1
#endif
#ifndef RESHADE_DEPTH_INPUT_X_SCALE
#define RESHADE_DEPTH_INPUT_X_SCALE 1
#endif
#ifndef RESHADE_DEPTH_INPUT_Y_SCALE
#define RESHADE_DEPTH_INPUT_Y_SCALE 1
#endif
#ifndef RESHADE_DEPTH_INPUT_X_OFFSET
#define RESHADE_DEPTH_INPUT_X_OFFSET 0
#endif
#ifndef RESHADE_DEPTH_INPUT_Y_OFFSET
#define RESHADE_DEPTH_INPUT_Y_OFFSET 0
#endif
#ifndef RESHADE_DEPTH_INPUT_X_PIXEL_OFFSET
#define RESHADE_DEPTH_INPUT_X_PIXEL_OFFSET 0
#endif
#ifndef RESHADE_DEPTH_INPUT_Y_PIXEL_OFFSET
#define RESHADE_DEPTH_INPUT_Y_PIXEL_OFFSET 0
#endif
#if defined(__RESHADE_FXC__)
#if defined(RESHADE_QUINT_EFFECT_DEPTH_REQUIRE)
uniform bool UIReshadeDepthInputIsReversed <
ui_type = "bool";
ui_label = "Depth Input Is Reversed";
> = RESHADE_DEPTH_INPUT_IS_REVERSED;
#else
#define UIReshadeDepthInputIsReversed RESHADE_DEPTH_INPUT_IS_REVERSED
#endif
#endif
namespace qUINT
{
  uniform float FrameTime < source = "frametime"; >;
  uniform int FrameCount < source = "framecount"; >;
  #if defined(__RESHADE_FXC__)
  float2 GetAspectRatio() 	{ return float2(1.0, BUFFER_WIDTH * BUFFER_RCP_HEIGHT); }
  float2 GetPixelSize() 	{ return float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT); }
  float2 GetScreenSize() 	{ return float2(BUFFER_WIDTH, BUFFER_HEIGHT); }
  #define AspectRatio 		GetAspectRatio()
  #define PixelSize 			GetPixelSize()
  #define ScreenSize 		GetScreenSize()
  #else
  static const float2 AspectRatio 	= float2(1.0, BUFFER_WIDTH * BUFFER_RCP_HEIGHT);
  static const float2 PixelSize 		= float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT);
  static const float2 ScreenSize 	= float2(BUFFER_WIDTH, BUFFER_HEIGHT);
  #endif
  texture BackBufferTex : COLOR;
  texture DepthBufferTex : DEPTH;
  sampler SBackBufferTex 	{ Texture = BackBufferTex; 	};
  sampler SDepthBufferTex { Texture = DepthBufferTex; };
  float2 DepthTexUv(float2 uv)
  {
    #if RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN
    uv.y = 1.0 - uv.y;
    #endif
    uv.x /= RESHADE_DEPTH_INPUT_X_SCALE;
    uv.y /= RESHADE_DEPTH_INPUT_Y_SCALE;
    #if RESHADE_DEPTH_INPUT_X_PIXEL_OFFSET
    uv.x -= RESHADE_DEPTH_INPUT_X_PIXEL_OFFSET * BUFFER_RCP_WIDTH;
    #else
    uv.x -= RESHADE_DEPTH_INPUT_X_OFFSET / 2.000000001;
    #endif
    #if RESHADE_DEPTH_INPUT_Y_PIXEL_OFFSET
    uv.y += RESHADE_DEPTH_INPUT_Y_PIXEL_OFFSET * BUFFER_RCP_HEIGHT;
    #else
    uv.y += RESHADE_DEPTH_INPUT_Y_OFFSET / 2.000000001;
    #endif
    return uv;
  }
  float GetDepth(float2 uv)
  {
    float depth = tex2Dlod(SDepthBufferTex, float4(DepthTexUv(uv), 0, 0)).x;
    return depth;
  }
  float LinearizeDepth(float depth)
  {
    depth *= RESHADE_DEPTH_MULTIPLIER;
    #if RESHADE_DEPTH_INPUT_IS_LOGARITHMIC
    const float C = 0.01;
    depth = (exp(depth * log(C + 1.0)) - 1.0) / C;
    #endif
    #if defined(__RESHADE_FXC__)
    depth = UIReshadeDepthInputIsReversed ? 1.0 - depth : depth;
    #else
    #if RESHADE_DEPTH_INPUT_IS_REVERSED
    depth = 1.0 - depth;
    #endif
    #endif
    const float N = 1.0;
    depth /= RESHADE_DEPTH_LINEARIZATION_FAR_PLANE - depth * (RESHADE_DEPTH_LINEARIZATION_FAR_PLANE - N);
    return saturate(depth);
  }
  float LinearDepth(float2 uv)
  {
    float depth = GetDepth(uv);
    depth = LinearizeDepth(depth);
    return depth;
  }
}
void PostProcessVS(in uint id : SV_VertexID, out float4 vpos : SV_Position, out float2 uv : TEXCOORD)
{
  uv.x = (id == 2) ? 2.0 : 0.0;
  uv.y = (id == 1) ? 2.0 : 0.0;
  vpos = float4(uv * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}