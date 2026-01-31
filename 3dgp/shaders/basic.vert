// VERTEX SHADER

#version 330


// Matrices
uniform mat4 matrixProjection;
uniform mat4 matrixView;
uniform mat4 matrixModelView;


// Materials 
uniform vec3 materialAmbient;
uniform vec3 materialDiffuse;
uniform vec3 materialSpecular;
uniform float shininess;

uniform float quad;


in vec3 aVertex;
in vec3 aNormal;
in vec2 aTexCoord;

out vec2 texCoord0;
out vec4 color;


vec4 position;
vec3 normal;

struct AMBIENT
{
vec3 color;
};
uniform AMBIENT lightAmbient, lightAmbient2, lightAmbient3, lightAmbient4;

struct DIRECTIONAL
{
vec3 direction;
vec3 diffuse;
};
uniform DIRECTIONAL lightDir;

struct POINT
{
vec3 position;
vec3 diffuse;
vec3 specular;
};
uniform POINT lightPoint, lightPoint2, lightPoint3;

vec4 AmbientLight(AMBIENT light)
{
// Calculate Ambient Light
return vec4(materialAmbient * light.color, 1);
}

vec4 DirectionalLight(DIRECTIONAL light)
{
// Calculate Directional Light
vec4 color = vec4(0, 0, 0, 0);
vec3 L = normalize(mat3(matrixView) * light.direction);
float NdotL = dot(normal, L);
color += vec4(materialDiffuse * light.diffuse, 1) * max(NdotL, 0);
return color;
}

vec4 PointLight(POINT light)
{
// Calculate Point Light
vec4 color = vec4(0, 0, 0, 0);
vec3 L = normalize((vec4(light.position,1) * matrixView) - position).xyz;
float NdotL = dot(normal, L);
color += vec4(materialDiffuse * light.diffuse, 1) * max(NdotL, 0);
float dist = length(matrixView * vec4(light.position, 1) - position);
float att = 1 / (quad * dist * dist);
return color*att;
}

void main(void)
{

// calculate position
position = matrixModelView * vec4(aVertex, 1.0);
gl_Position = matrixProjection * position;

normal = normalize(mat3(matrixModelView) * aNormal);

// calculate light
color = vec4(0,0,0,0);
color += AmbientLight(lightAmbient);
color += AmbientLight(lightAmbient2);
color += AmbientLight(lightAmbient3);
color += AmbientLight(lightAmbient4);
color += DirectionalLight(lightDir);
color += PointLight(lightPoint);
color += PointLight(lightPoint2);
color += PointLight(lightPoint3);

texCoord0 = aTexCoord;
}


