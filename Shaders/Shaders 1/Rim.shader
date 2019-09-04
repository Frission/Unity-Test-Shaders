Shader "Holistic/Rim"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
		_RimColor("Rim Color", Color) = (0.5, 0, 0.5, 1)
		_RimPower("Rim Power", Range(1,8)) = 3.0
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("Normal", 2D) = "bump" {}
        //_Glossiness ("Smoothness", Range(0,1)) = 0.5
        //_Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        //#pragma surface surf Standard fullforwardshadows
		#pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        //#pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
			float3 worldPos;
        };

        //half _Glossiness;
        //half _Metallic;
        fixed4 _Color;
		fixed4 _RimColor;
		half _RimPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;	
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            //o.Metallic = _Metallic;
            //o.Smoothness = _Glossiness;
            o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

			// rim here
			half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
			// cutoff
			o.Emission = _RimColor.rgb * (rim > 0.7 ? pow(rim,_RimPower) : 0);

			// rainbow
			//o.Emission = _RimColor.rgb * (rim > 0.7 ? fixed3(1,0,1) : (rim > 0.5 ? fixed3(0.2,0,1) : 0));

			// world height
			//o.Emission = (rim > 0.5 ? (frac(IN.worldPos.y * 30 * 0.5) > 0.4 ? fixed3(1, 0, 1) * rim : fixed3(0.2, 0, 1) * rim) : 0);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
