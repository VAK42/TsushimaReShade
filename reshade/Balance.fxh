#pragma once
namespace WhiteBalance
{
  float3 BlackBodyXyz(float temperature)
  {
    float term = 1000.0 / temperature;
    const float4 XcCoefficients[2] =
    {
      float4(-3.0258469, 2.1070379, 0.2226347, 0.240390),
      float4(-0.2661293,-0.2343589, 0.8776956, 0.179910)
    };
    const float4 YcCoefficients[3] =
    {
      float4(-1.1063814,-1.34811020, 2.18555832,-0.20219683),
      float4(-0.9549476,-1.37418593, 2.09137015,-0.16748867),
      float4( 3.0817580,-5.87338670, 3.75112997,-0.37001483)
    };
    float3 xyz;
    float4 xc;
    xc.w = 1.0;
    xc.xyz = term;
    xc.xy *= term;
    xc.x *= term;
    float x = dot(xc, temperature > 4000.0 ? XcCoefficients[0] : XcCoefficients[1]);
    float4 yc;
    yc.w = 1.0;
    yc.xyz = x;
    yc.xy *= x;
    yc.x *= x;
    float y = dot(yc, temperature < 2222.0 ? YcCoefficients[0] : (temperature < 4000.0 ? YcCoefficients[1] : YcCoefficients[2]));
    float3 XYZ;
    XYZ.y = 1.0;
    XYZ.x = XYZ.y / y * x;
    XYZ.z = XYZ.y / y * (1.0 - x - y);
    return XYZ;
  }
  float3x3 ChromaticAdaptation(float3 xyzSrc, float3 xyzDst)
  {
    const float3x3 XyzToLms = float3x3(0.4002, 0.7076, -0.0808,
      -0.2263, 1.1653, 0.0457,
      0,0,0.9182);
    const float3x3 LmsToXyz = float3x3(1.8601 ,  -1.1295, 0.2199,
      0.3612, 0.6388 , -0.0000,
      0, 0, 1.0891);
    float3 LmsSrc = mul(xyzSrc, XyzToLms);
    float3 LmsDst = mul(xyzDst, XyzToLms);
    float3x3 VonKriesTransform = float3x3(LmsDst.x / LmsSrc.x, 0, 0,
      0, LmsDst.y / LmsSrc.y, 0,
      0, 0, LmsDst.z / LmsSrc.z);
    return mul(mul(XyzToLms, VonKriesTransform), LmsToXyz);
  }
  float3 SetWhiteBalance(float3 rgb, float temperature)
  {
    float3 XyzSrc = BlackBodyXyz(6500.0);
    float3 XyzDst = BlackBodyXyz(temperature);
    float3 adjusted = Colorspace::rgb_to_xyz(rgb);
    adjusted = mul(adjusted, ChromaticAdaptation(XyzSrc, XyzDst));
    adjusted = Colorspace::xyz_to_rgb(adjusted);
    adjusted = saturate(adjusted);
    float3 lab = Colorspace::rgb_to_oklab(adjusted);
    lab.yz += float2(INPUT_COLOR_LAB_A, INPUT_COLOR_LAB_B) * 0.05;
    adjusted = Colorspace::oklab_to_rgb(lab);
    adjusted = saturate(adjusted);
    return adjusted;
  }
}