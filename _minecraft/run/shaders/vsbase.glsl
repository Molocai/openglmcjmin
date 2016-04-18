varying vec3 normal;
varying vec3 vertex_to_light_vector;
varying vec4 color;

uniform float elapsed;
uniform mat4 invertView;
uniform mat4 viewMatrix;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
	//Couleur
	color = gl_Color;

	// Vague classe
	vec4 vertex = gl_Vertex;
	vertex = gl_ModelViewMatrix * vertex; //par rapport à la cam
	vec4 vectWorld = invertView * vertex; // on a la model matrix (espace monde)
	
	float periode = 2;
	float hauteur = 0.5;
	float offset = sin(elapsed + vectWorld.x / periode) * hauteur;
	float offset2 = sin(elapsed + vectWorld.y / (3 * periode)) * hauteur;
	vertex = gl_Vertex;

	if (color.b > 0.8)
		vertex.z += offset + offset2;

	// if (color.b > 0.8)
	gl_Position = gl_ModelViewProjectionMatrix * vertex;


	

	// Vague chelou
	// vec4 vertex = gl_Vertex;

	// vertex = invertView * gl_ModelViewMatrix * vertex;
	// vertex.z += sin(vertex.y + elapsed / 5) * 0.5;

	// Transforming The Vertex
	// gl_Position = gl_ProjectionMatrix * viewMatrix * vertex;

	// Transforming The Normal To ModelView-Space
	normal = gl_NormalMatrix * gl_Normal; 

	//Direction lumiere
	vertex_to_light_vector = vec3(gl_LightSource[0].position);
}

