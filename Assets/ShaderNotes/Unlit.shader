Shader "CC/Unlit"
{
    Properties
    { 
        _Color        ("_Color" , Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }
        LOD 300
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"        
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

        CBUFFER_START(UnityPerMaterial)
            half4 _Color;
        CBUFFER_END

            struct VertexInput
            {
                float4 posOS   : POSITION;           
                float3 normal : NORMAL; 
            };

            struct VertexOutput
            {
                float4 posCS    : SV_POSITION;
                float3 posWS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
            };            

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
                o.normalWS = TransformObjectToWorldNormal(v.normal);
                o.posWS = TransformObjectToWorld(v.posOS.xyz);
                o.posCS = TransformObjectToHClip(v.posOS.xyz);
                return o;
            }

            half4 frag(VertexOutput input) : SV_Target
            {
                half3 color = _Color;

                half ndotl = dot(normalize(input.normalWS), GetMainLight().direction);
                ndotl = ndotl*0.5+0.5;
                
                return float4(color*ndotl, 1);
            }
            ENDHLSL
        }
    }
}