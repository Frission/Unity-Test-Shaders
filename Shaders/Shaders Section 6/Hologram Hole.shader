Shader "Holistic6/Hologram Hole" {
	Properties{
	  _RimColor("Rim Color", Color) = (0,0.5,0.5,0.0)
	  _RimPower("Rim Power", Range(0.5,8.0)) = 3.0
	}
		SubShader
	    {
			Tags { "Queue" = "Geometry-1" }

			Pass {
				ZWrite Off
				ColorMask 0
			}

			Stencil
			{
				Ref 1
				Comp GEqual
				Pass replace
			}

			CGPROGRAM

			#pragma surface surf Standard alpha:fade		

			struct Input {
				float3 viewDir;
				float3 lightDir;
			};

			float4 _RimColor;
			float _RimPower;

			 void surf(Input IN, inout SurfaceOutputStandard o) {
				 half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
				o.Emission = _RimColor.rgb * pow(rim, _RimPower) * 10;
				 o.Alpha = pow(rim, _RimPower);
			 }
			ENDCG
		}
		Fallback "Diffuse"
}