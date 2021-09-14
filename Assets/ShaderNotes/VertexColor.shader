Shader "CC/VertexColor"
{
    Properties
    {
         [Toggle(Multiply_Alpha)] _Multiply_Alpha("Multiply_Alpha", Int) = 0
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

            #pragma shader_feature Multiply_Alpha
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"            

            struct VertexInput
            {
                float4 posOS   : POSITION;
                float3 normal : NORMAL;
                float4 vertexColor : COLOR;
            };

            struct VertexOutput
            {
                float4 posCS : SV_POSITION;
                float3 posWS : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float4 vertexColor : COLOR;
            };            

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
                o.vertexColor = v.vertexColor;
                o.worldNormal = TransformObjectToWorldNormal(v.normal);
                o.posWS = TransformObjectToWorld(v.posOS.xyz);
                o.posCS = TransformObjectToHClip(v.posOS.xyz);
                return o;
            }

            half4 frag(VertexOutput i) : SV_Target
            {
                half3 col = i.vertexColor.xyz;
                #ifdef Multiply_Alpha
                    col*= i.vertexColor.a;
                #endif

                half ndotl = dot(normalize(i.worldNormal), GetMainLight().direction);
                ndotl = ndotl*0.5+0.5;
                return float4(col*ndotl, 1);
            }
            ENDHLSL
        }
    }
}