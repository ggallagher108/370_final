//SUN FRAGMENT SHADER

#version 450

in vec4 FragPos;

in vec3 position_eye, normal_eye;

out vec4 fragment_color; // final color of surface

uniform mat4 view_mat;

uniform vec3 lightPos = vec3 (0.0, 0.0, 0.0);

uniform float far_plane;

// fixed point light properties
vec3 Ls = vec3 (1.0, 1.0, 1.0);		// white specular color
vec3 Ld = vec3 (0.7, 0.7, 0.7);		// dull white diffuse light color
vec3 La = vec3 (0.2, 0.2, 0.2);		// grey ambient color
  
// surface reflectance
vec3 Ks = vec3 (1.0, 1.0, 1.0);		// fully reflect specular light
vec3 Kd = vec3 (0.36, 0.05, 0.05);		// orange diffuse surface reflectance
vec3 Ka = vec3 (1.0, 1.0, 1.0);		// fully reflect ambient light
float specular_exponent = 100.0;	// specular 'power'

void main ()
{
	// ambient intensity
	vec3 Ia = La * Ka;

	// diffuse intensity
	// raise light position to eye space
	vec3 light_position_eye = vec3 (view_mat * vec4 (lightPos, 1.0));
	vec3 distance_to_light_eye = light_position_eye - position_eye;
	vec3 direction_to_light_eye = normalize (distance_to_light_eye);
	float dot_prod = dot (direction_to_light_eye, normal_eye);
	dot_prod = max (dot_prod, 0.0);
	vec3 Id = (Ld * Kd * dot_prod) * 15.0f; // final diffuse intensity
	
	// specular intensity
	vec3 surface_to_viewer_eye = normalize (-position_eye);
	
	//vec3 reflection_eye = reflect (-direction_to_light_eye, normal_eye);
	//float dot_prod_specular = dot (reflection_eye, surface_to_viewer_eye);
	//dot_prod_specular = max (dot_prod_specular, 0.0);
	//float specular_factor = pow (dot_prod_specular, specular_exponent);
	
	// blinn
	vec3 half_way_eye = normalize (surface_to_viewer_eye + direction_to_light_eye);
	float dot_prod_specular = max (dot (half_way_eye, normal_eye), 0.0);
	float specular_factor = pow (dot_prod_specular, specular_exponent);
	
	vec3 Is = Ls * Ks * specular_factor; // final specular intensity
	
	// final color
	fragment_color = vec4 (Is + Id + Ia, 1.0);
}
