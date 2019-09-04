Shader "Holistic/BumpedEnvironment" 
{
    Properties {
        _myColor ("Color", Color) = (1,1,1,1)
        _myRange ("Intensity", Range(0,5)) = 1
		_myScale("Texture Scale", Range(0,5)) = 1
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}
		_myEmissionTex("Emission Texture", 2D) = "black" {}
		_myCubeMultiplier("Emission Intensity", Range(0,2)) = 0.5
		_myNormal("Normal", 2D) = "bump" {}
		_myNormalMultiplier("Normal Intensity", Range(0,5)) = 1
        _myCube ("Cube", CUBE) = "white" {}
    }
    SubShader {

      CGPROGRAM
        #pragma surface surf Lambert
        
        fixed4 _myColor;
        half _myRange;
		half _myScale;
        sampler2D _myDiffuse;
        samplerCUBE _myCube;
		sampler2D _myEmissionTex;
		sampler2D _myNormal;
		half _myCubeMultiplier;
		half _myNormalMultiplier;

        struct Input {
            float2 uv_myDiffuse;
			float2 uv_myNormal;
			float3 worldRefl; INTERNAL_DATA
        };
        
        void surf (Input IN, inout SurfaceOutput o) 
		{
			IN.uv_myDiffuse *= _myScale;
			IN.uv_myNormal *= _myScale;
			fixed3 endColor = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
			endColor = endColor * _myColor * _myRange;			
            o.Albedo = endColor;

			float3 normal = UnpackNormal(tex2D(_myNormal, IN.uv_myNormal));
			normal.xy = normal.xy * _myNormalMultiplier;
			o.Normal = normal;

            //o.Emission = (tex2D (_myEmissionTex, IN.uv_myDiffuse) * _myCubeMultiplier).rgb;
			o.Emission = texCUBE(_myCube, WorldReflectionVector(IN, o.Normal)).rgb;
        }
      
      ENDCG
    }
    Fallback "Diffuse"
  }
