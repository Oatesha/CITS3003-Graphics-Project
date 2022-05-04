varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

varying vec3 fN;
varying vec3 fL;
varying vec3 fV;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform float Shininess;

//PART G implement per fragment shading 
void main()
{
	vec3 N = normalize(fN);
	vec3 L = normalize(fL);
    vec3 V = normalize(fV);

    float distToLight = length(fL);
	float atten = 1.0/(0.5 + 0.1*distToLight + 0.1*(distToLight*distToLight));

	vec3 H = normalize(L+V);
	vec3 ambient = AmbientProduct;

	float Kd = max(dot(L,N),0.0);
	vec3 diffuse = (Kd * DiffuseProduct);

	float Ks = pow(max(dot(N,H),0.0), Shininess);
	vec3 specular = (Ks * SpecularProduct);

	if(dot(L,N) < 0.0)
	{
		specular = vec3(0.0,0.0,0.0);
	}

	vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
	
    vec4 color = atten  * vec4(globalAmbient + ambient + diffuse, 1.0);

    gl_FragColor = color * texture2D( texture, texCoord) + vec4(specular, 1.0);
}