// original link: https://www.shadertoy.com/view/lslXDr

#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;
out vec4 fragColor;
// Written by GLtracy

// math const
const float PI = 3.14159265359;
const float MAX = 10000.0;

// ray intersects sphere
// e = -b +/- sqrt( b^2 - c )
vec2 ray_vs_sphere(vec3 p, vec3 dir, float r) {
    float b = dot(p, dir);
    float c = dot(p, p) - r * r;

    float d = b * b - c;
    if(d < 0.0) {
        return vec2(MAX, -MAX);
    }
    d = sqrt(d);

    return vec2(-b - d, -b + d);
}

// Mie
// g : ( -0.75, -0.999 )
//      3 * ( 1 - g^2 )               1 + c^2
// F = ----------------- * -------------------------------
//      8pi * ( 2 + g^2 )     ( 1 + g^2 - 2 * g * c )^(3/2)
float phase_mie(float g, float c, float cc) {
    float gg = g * g;

    float a = (1.0 - gg) * (1.0 + cc);

    float b = 1.0 + gg - 2.0 * g * c;
    b *= sqrt(b);
    b *= 2.0 + gg;

    return (3.0 / 8.0 / PI) * a / b;
}

// Rayleigh
// g : 0
// F = 3/16PI * ( 1 + c^2 )
float phase_ray(float cc) {
    return (3.0 / 16.0 / PI) * (1.0 + cc);
}

// scatter const
const float R_INNER = 1.0;
const float R = R_INNER + 0.5;

const int NUM_OUT_SCATTER = 8;
const int NUM_IN_SCATTER = 80;

float density(vec3 p, float ph) {
    return exp(-max(length(p) - R_INNER, 0.0) / ph);
}

float optic(vec3 p, vec3 q, float ph) {
    vec3 s = (q - p) / float(NUM_OUT_SCATTER);
    vec3 v = p + s * 0.5;

    float sum = 0.0;
    for(int i = 0; i < NUM_OUT_SCATTER; i++) {
        sum += density(v, ph);
        v += s;
    }
    sum *= length(s);

    return sum;
}

vec3 in_scatter(vec3 o, vec3 dir, vec2 e, vec3 l) {
    const float ph_ray = 0.05;
    const float ph_mie = 0.02;

    const vec3 k_ray = vec3(3.8, 13.5, 33.1);
    const vec3 k_mie = vec3(21.0);
    const float k_mie_ex = 1.1;

    vec3 sum_ray = vec3(0.0);
    vec3 sum_mie = vec3(0.0);

    float n_ray0 = 0.0;
    float n_mie0 = 0.0;

    float len = (e.y - e.x) / float(NUM_IN_SCATTER);
    vec3 s = dir * len;
    vec3 v = o + dir * (e.x + len * 0.5);

    for(int i = 0; i < NUM_IN_SCATTER; i++) {
        float d_ray = density(v, ph_ray) * len;
        float d_mie = density(v, ph_mie) * len;

        n_ray0 += d_ray;
        n_mie0 += d_mie;

#if 0
        vec2 e = ray_vs_sphere(v, l, R_INNER);
        e.x = max(e.x, 0.0);
        if(e.x < e.y) {
            continue;
        }
#endif

        vec2 f = ray_vs_sphere(v, l, R);
        vec3 u = v + l * f.y;

        float n_ray1 = optic(v, u, ph_ray);
        float n_mie1 = optic(v, u, ph_mie);

        vec3 att = exp(-(n_ray0 + n_ray1) * k_ray - (n_mie0 + n_mie1) * k_mie * k_mie_ex);

        sum_ray += d_ray * att;
        sum_mie += d_mie * att;

        v += s;
    }

    float c = dot(dir, -l);
    float cc = c * c;
    vec3 scatter = sum_ray * k_ray * phase_ray(cc) +
        sum_mie * k_mie * phase_mie(-0.78, c, cc);

    return 10.0 * scatter;
}

// angle : pitch, yaw
mat3 rot3xy(vec2 angle) {
    vec2 c = cos(angle);
    vec2 s = sin(angle);

    return mat3( //
    c.y, 0.0, -s.y, //
    s.y * s.x, c.x, c.y * s.x, //
    s.y * c.x, -s.x, c.y * c.x //
    );
}

// ray direction
vec3 ray_dir(float fov, vec2 size, vec2 pos) {
    vec2 xy = pos - size * 0.5;

    float cot_half_fov = tan(radians(90.0 - fov * 0.5));
    float z = size.y * 0.5 * cot_half_fov;

    return normalize(vec3(xy, -z));
}

void main() {
	// default ray dir
    vec3 dir = ray_dir(60.0, iResolution.xy, FlutterFragCoord().xy);

	// default ray origin
    vec3 eye = vec3(0.0, 0.0, 3.0);

	// rotate camera
    mat3 rot = rot3xy(vec2(2.8, iTime * 2.8));
    dir = rot * dir;
    eye = rot * eye;

	// sun light dir
    vec3 l = vec3(0.0, 0.0, 1.0);

    vec2 e = ray_vs_sphere(eye, dir, R);
    if(e.x > e.y) {
        //fragColor = vec4(0.203, 0.211, 0.294, 1.0);
        return;
    }

    vec2 f = ray_vs_sphere(eye, dir, R_INNER);
    e.y = min(e.y, f.x);

    vec3 I = in_scatter(eye, dir, e, l);

    //fragColor = vec4(pow(I, vec3(1.0 / 2.2)), 1.0);

    // 背景色
    vec4 bg = vec4(0.203, 0.211, 0.294, 1.0);
    // 前景
    vec4 fg = vec4( pow( I, vec3( 1.0 / 1.0 ) ), 1.0 );
    fragColor = vec4(1.0) - (vec4(1.0) - fg) * (vec4(1.0) - bg);
}