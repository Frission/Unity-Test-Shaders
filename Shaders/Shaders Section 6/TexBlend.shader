Shader "Holistic6/TextureBlend" 
{
    Properties {
        _myColor ("Color", Color) = (1,1,1,1)
        _myRange ("Intensity", Range(0,5)) = 1
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}
		_myEmissionTex("Emission Texture", 2D) = "black" {}
		_myMetallic("Metallic", 2D) = "" {}
		_myNormal("Normal", 2D) = "bump" {}
		_mySpec("Specular", 2D) = "" {}
		_mySmooth ("Smoothness", Range(0.0, 1.0)) = 0.0
		_myNormalMultiplier("Normal Intensity", Range(0,5)) = 1
		_myDecal("Decal Texture", 2D) = "white" {}
		[Toggle] _ShowDecal("Show Decal", float) = 0
    }
    SubShader {

      CGPROGRAM
        #pragma surface surf Standard
        
        fixed4 _myColor;
        half _myRange;
        sampler2D _myDiffuse;
		sampler2D _myEmissionTex;
		sampler2D _myNormal;
		sampler2D _mySpec;
		sampler2D _myMetallic;
		sampler2D _myDecal;
		half _myNormalMultiplier;
		half _mySmooth;
		float _ShowDecal;

        struct Input {
            float2 uv_myDiffuse;
			float2 uv_myNormal;
			float2 uv_mySpec;
			float2 uv_myMetallic;
        };
        
        void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			fixed4 d = tex2D(_myDecal, IN.uv_myDiffuse) * _ShowDecal;
			fixed4 endColor = tex2D(_myDiffuse, IN.uv_myDiffuse);
			endColor = endColor * _myColor * _myRange;			
			o.Albedo = d.r > 0.9 ? d.rgb : endColor.rgb;

			float3 normal = UnpackNormal(tex2D(_myNormal, IN.uv_myNormal));
			normal.xy = normal.xy * _myNormalMultiplier;
			o.Normal = normal;
			o.Occlusion = tex2D(_mySpec, IN.uv_mySpec);
			o.Smoothness = _mySmooth;

            o.Emission = d.r > 0.9 ? 0 : (tex2D (_myEmissionTex, IN.uv_myDiffuse)).rgb;
			o.Metallic = tex2D(_myMetallic, IN.uv_myMetallic);
        }
      
      ENDCG
    }
    Fallback "Diffuse"
  }
