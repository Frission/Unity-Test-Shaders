Shader "Holistic6/BlendTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
		// invert colors
		Blend OneMinusDstColor Zero
		Pass {
			SetTexture [_MainTex] { combine texture }
		}
    }

}
