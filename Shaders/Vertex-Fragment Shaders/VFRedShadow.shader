﻿Shader "HolisticVF/VFRedShadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
		// draw to screen
        Pass
        {
            Tags {"LightMode"="ForwardBase"}
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc" 
            #include "UnityLightingCommon.cginc" 

			// stuff to accept shadows
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata {
			    float4 vertex : POSITION;
			    float3 normal : NORMAL;
			    float4 texcoord : TEXCOORD0;
			};

            struct v2f
            {
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR0; 
				// this has to be pos for shadow receiving
                float4 pos : SV_POSITION;
				SHADOW_COORDS(1)
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;
				//o.diff = 1;
				TRANSFER_SHADOW(o)
                return o;
            }
            
            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed shadow = SHADOW_ATTENUATION(i);
				col.rgb *= i.diff;
				col.rgb = shadow < 0.3 ? fixed3(col.r, 0, 0) : col.rgb;
                col *= i.diff;
                return col;
            }
            ENDCG
        }

		// cast a shadow
		Pass
		{
			Tags {"LightMode"="ShadowCaster"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				V2F_SHADOW_CASTER;
			};

			v2f vert(appdata v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}

			ENDCG
		}
    }
}