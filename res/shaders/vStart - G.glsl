attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;

varying vec3 fN;
varying vec3 fL;
varying vec3 fV;


void main()
{

    vec4 vpos = vec4(vPosition, 1.0);
    vec4 vnormal = vec4(vNormal, 0.0);

    // Transform vertex position into eye coordinates


    fN = (ModelView * vnormal).xyz;
    fV = - (ModelView * vpos).xyz; //notice the negative sign
    fL = LightPosition.xyz - (ModelView * vpos).xyz;
    
    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}