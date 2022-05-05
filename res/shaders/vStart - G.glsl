attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition, light2Position;

varying vec3 Nvec, Evec, Lvec, Lvec2;


void main()
{

    vec4 vpos = vec4(vPosition, 1.0);
    vec4 vnorm = vec4(vNormal, 0.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    Nvec = (ModelView * vnorm).xyz;
    Evec = -pos;   
    Lvec = LightPosition.xyz - pos;
    Lvec2 = light2Position.xyz;
    
    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}