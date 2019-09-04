Shader "Holistic/BasicBlinnPhong" {
	Properties{
			_Colour("Colour", Color) = (1,1,1,1)
			_SpecularPow("Glossiness", Range(1.0, 250.0)) = 48.0

	}
		SubShader{
			Tags{
				"Queue" = "Geometry"
			}


			CGPROGRAM
			#pragma surface surf BasicBlinn

			half _SpecularPow;
		// attenuation = light intensity
		half4 LightingBasicBlinn(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half3 halfway = normalize(lightDir + viewDir);

			half diff = max(0, dot(s.Normal, lightDir));

			// falloff of your specular
			float nh = max(0, dot(s.Normal, halfway));
			// 48 is what unity uses
			float spec = pow(nh, _SpecularPow);
			
			half4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * (_SpecularPow / 48)) * atten; //* _SinTime;
			c.a = s.Alpha;
			return c;
		}

		float4 _Colour;

		struct Input {
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = _Colour.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"

}
