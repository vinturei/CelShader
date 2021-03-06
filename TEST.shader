﻿Shader ".Test/Test"
{
	Properties
	{
		_Color ("Main colour", Color) = (1,1,1,1)
		_MainTex ("Main texture", 2D) = "white" {}
		_UnlitStrength ("Unlit Strength", Range(0.0,1.0)) = 0.5
	}
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
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		fixed4 _Color;
		sampler2D _MainTex;
		float _UnlitStrength;
		float4 _LightColor0;

		v2f vert (appdata IN)
		{
			v2f OUT;
			OUT.pos = UnityObjectToClipPos(IN.vertex);
			OUT.normal = mul(float4(IN.normal, 0.0), unity_ObjectToWorld).xyz;
			OUT.texcoord = IN.texcoord;
			return OUT;
		}

		fixed4 frag (v2f IN) : COLOR
		{
			fixed4 texColor = tex2D(_MainTex, IN.texcoord);

			float3 normalDirection = normalize(IN.normal);
			float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);			

			float3 diffuse = _LightColor0.rgb * max(_UnlitStrength, dot(normalDirection, lightDirection));

			return _Color * texColor * float4(diffuse, 1);
		}

		ENDCG
		}
	}
}