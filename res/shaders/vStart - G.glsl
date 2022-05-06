attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition, light2Position, light3Position;

varying vec3 fN, fV, fL, fL2, fL3;


void main()
{

    vec4 vpos = vec4(vPosition, 1.0);
    vec4 vnorm = vec4(vNormal, 0.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    fN = (ModelView * vnorm).xyz;
    fV = -pos;   
    fL = LightPosition.xyz - pos;
    fL2 = light2Position.xyz;
    fL3 = light3Position.xyz - pos;
    
    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}