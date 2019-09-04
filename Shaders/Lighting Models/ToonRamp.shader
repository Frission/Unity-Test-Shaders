Shader "Holistic/ToonRamp" {
	Properties 
	{
		_Color  ("Color", Color) = (1,1,1,1)
		_MainTex("Diffuse", 2D) = "white" {}
		_RampTex ("Ramp Texture", 2D) = "white"{}
		_RampPow("Ramp Power", Range(0.0,8.0)) = 1.0
	}
	
	SubShader 
	{
		
		CGPROGRAM
		#pragma surface surf ToonRamp

		float4 _Color;
		sampler2D _RampTex;
		half _RampPow;
		
		float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float diff = dot (s.Normal, lightDir);
			float h = diff * 0.5 + 0.5;
			float2 rh = h;
			float3 ramp = tex2D(_RampTex, rh).rgb;
			
			float val = pow(ramp, _RampPow);
			float4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (val);
			c.a = s.Alpha;
			return c;
		}

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{			
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color.rgb;
			//float diff = dot(o.Normal, IN.viewDir);
			//float h = diff * 0.5 + 0.5;
			//float2 rh = h;
			//float3 ramp = tex2D(_RampTex, rh).rgb;

			//o.Albedo = ramp * _Color.rgb;
		}
		
		ENDCG
	} 
	
	FallBack "Diffuse"

}
