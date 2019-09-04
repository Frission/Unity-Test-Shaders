Shader "HolisticVF/ColourVF"
{
    SubShader
    {        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float4 color : COLOR;
            };

            v2f vert (appdata v)
            {
                v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
                o.vertex = UnityObjectToClipPos(v.vertex);
				/*o.color.r = v.vertex.x * 0.2;
				o.color.g = saturate(-v.vertex.x * 0.2);
				o.color.b = (v.vertex.z < 0 ? -v.vertex.z * 0.2 : v.vertex.z * 0.2) * 0.8;*/
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col;
				UNITY_INITIALIZE_OUTPUT(fixed4, col);
				col.r = i.vertex.x / 1000;
				col.g = i.vertex.y / 1000;
                return col;
            }
            ENDCG
        }
    }
}
