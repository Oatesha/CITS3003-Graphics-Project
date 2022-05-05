varying vec4 color;
varying vec2 texCoord;  
varying vec3 Nvec, Evec, Lvec, Lvec2;

uniform sampler2D texture;
uniform float texScale;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct, AmbientProduct2, DiffuseProduct2, SpecularProduct2;
uniform mat4 ModelView;
uniform float Shininess;
float a;
float b;
float c;
uniform vec4 lightRot;
uniform float radius;

void main()
{
	vec3 N = normalize(Nvec);
	vec3 L = normalize(Lvec);
    vec3 E = normalize(Evec);

	//attenuation less harsh in the form of 1/a+bd+cd^2
    float distLightVector = length(Lvec);
	a = 0.5;
    b = 0.5;
    c = 0.5; 
    float attenuation = (1.0/(a + (b * distLightVector) + (c * (distLightVector * distLightVector))));


	vec3 H = normalize(L+E);
	vec3 ambient = AmbientProduct;

	float Kd = max(dot(L,N),0.0);
	vec3 diffuse = (Kd * DiffuseProduct) * attenuation;

	float Ks = pow(max(dot(N,H),0.0), Shininess);
	vec3 specular = (Ks * SpecularProduct) * attenuation;

	if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 

	vec3 L2 = normalize(Lvec2);	
    vec3 H2 = normalize(L2+E);

	vec3 ambient2 = AmbientProduct2;	
	float Kd2 = max(dot(L2,N),0.0);

	vec3 diffuse2 = (Kd2 * DiffuseProduct2);	
	float Ks2 = pow(max(dot(N,H2),0.0), Shininess);

	vec3 specular2 = (Ks2 * SpecularProduct2);

	//add spotlight
	if (dot(L, normalize(-lightRot.xyz)) < radius) {
		ambient = vec3(0.0, 0.0, 0.0);
		diffuse = vec3(0.0, 0.0, 0.0);
		specular = vec3(0.0, 0.0, 0.0);
	}

	if (dot(L2, N) < 0.0 ) {	
	    specular2 = vec3(0.0, 0.0, 0.0);	
    }
	vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    vec4 color = vec4(globalAmbient + ambient + diffuse + ambient2 + diffuse2, 1.0);

    gl_FragColor = color * texture2D( texture, texCoord * texScale) + vec4(specular + specular2, 1.0);
}