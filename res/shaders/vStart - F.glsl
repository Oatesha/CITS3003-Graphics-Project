attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;
float a;
float b;
float c;

//Implement part F from the week 8 lectures
uniform vec3 pos;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;


    // The vector to the light from the vertex    
    vec3 fL = LightPosition.xyz - pos;
    
    //find distance of the vector to calculate the attenuation factor
    float distLightVector = length(fL);


    //attenuation with 1/a+bd+cd^2 not sure if this is too quickly becoming dark but It seemed to be a happy middle ground compared to having all of the coefficients 1
    a = 1.0;
    b = 0.5;
    c = 0.5; 
    float attenuation = (1.0/(a + (b * distLightVector) + (c * (distLightVector * distLightVector))));

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( fL );   
    vec3 V = normalize( -pos );   
    vec3 H = normalize( L + V );  

    // Transform vertex normal into eye coordinates
    vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    //implement attenuation factor
    color.rgb = (attenuation * (globalAmbient  + ambient + diffuse + specular));
    color.a = 1.0;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
