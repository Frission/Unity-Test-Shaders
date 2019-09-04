/*
	struct SurfaceOutput
	{
		fixed3 Albedo;  // diffuse color
		fixed3 Normal;  // tangent space normal, if written
		fixed3 Emission; 
		half Specular;  // specular power in 0..1 range
		fixed Gloss;    // specular intensity
		fixed Alpha;    // alpha for transparency
	}
*/

Shader "Holistic/HelloShader" {
	
	Properties {
	    _myColour ("Example Colour", Color) = (1,1,1,1)
		_myEmission ("Example Emission", Color) = (1,1,1,1)
	}
	
	SubShader {
		
		CGPROGRAM
			#pragma surface surf Lambert

			struct Input {
				float2 uvMainTex;
			};

			fixed4 _myColour;
			fixed4 _myEmission;
			
			void surf (Input IN, inout SurfaceOutput o)
			{
			    o.Albedo = _myColour.rgb;
				o.Emission = _myEmission.rgb;
			}
		
		ENDCG
	}
	
	FallBack "Diffuse"
}