precision mediump float;

uniform float uTime;

varying vec2 vUv;

#define PI 3.141592653589793

// 随机数
float random (vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

// 旋转
vec2 rotate (vec2 uv, float rotation, vec2 mid) {
  return vec2(
    cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
    cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
  );
}

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+10.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

// 柏林噪声
float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

// Classic Perlin noise, periodic variant
float pnoise(vec2 P, vec2 rep)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, rep.xyxy); // To create noise with explicit period
  Pi = mod289(Pi);        // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

void main(){
  // 1
  // float strength = vUv.x;

  // 2
  // float strength = vUv.y;

  // 3
  // float strength = 1.0 - vUv.y;

  // 4
  // float strength = 1.0 - vUv.y;

  // 5
  // float strength = vUv.y * 10.0;

  // 6
  // float strength = mod(vUv.y * 10.0, 1.0);

  // 7
  // float strength = mod(vUv.y * 10.0, 1.0);
  // strength = step(0.5, strength);

  // 8
  // float strength = mod(vUv.y * 10.0, 1.0);
  // strength = step(0.8, strength);

  // 9
  // float strength = mod(vUv.x * 10.0, 1.0);
  // strength = step(0.8, strength);

  // 10
  // float xBar = mod(vUv.x * 10.0, 1.0);
  // float yBar = mod(vUv.y * 10.0, 1.0);
  // float strength = step(0.8, xBar) + step(0.8, yBar);

  // 11
  // float xBar = mod(vUv.x * 10.0, 1.0);
  // float yBar = mod(vUv.y * 10.0, 1.0);
  // float strength = step(0.8, xBar) * step(0.8, yBar);

  // 12
  // float xBar = mod(vUv.x * 10.0, 1.0);
  // float yBar = mod(vUv.y * 10.0, 1.0);
  // float strength = step(0.4, xBar) * step(0.8, yBar);

  // 13
  // float xBar = step(0.4, mod(vUv.x * 10.0, 1.0));
  // xBar *= step(0.8, mod(vUv.y * 10.0 + 0.2, 1.0));
  // float yBar = step(0.8, mod(vUv.x * 10.0 + 0.2, 1.0));
  // yBar *= step(0.4, mod(vUv.y * 10.0, 1.0));
  // float strength = xBar + yBar;

  // 14
  // float strength = abs(vUv.x - 0.5);

  // 15
  // float strength = min(abs(vUv.x - 0.5) , abs(vUv.y - 0.5));

  // 16
  // float strength = max(abs(vUv.x - 0.5) , abs(vUv.y - 0.5));

  // 17
  // float strength = step(0.2, max(abs(vUv.x - 0.5) , abs(vUv.y - 0.5)));

  // 18
  // float square1 = step(0.4, max(abs(vUv.x - 0.5) , abs(vUv.y - 0.5)));
  // float square2 = 1.0 - step(0.5, max(abs(vUv.x - 0.5) , abs(vUv.y - 0.5)));
  // float strength = square1 * square2;

  // 19
  // float strength = floor(vUv.x * 10.0) / 10.0 * floor(vUv.y * 10.0) / 10.0;

  // 20
  // float strength = random(vUv);

  // 21
  // vec2 randoms = vec2(
  //   floor(vUv.x * 10.0) / 10.0, 
  //   floor(vUv.y * 10.0 + vUv.x * 5.0) / 10.0
  // );
  // float strength = random(randoms);

  // 22
  // float strength = distance(vUv, vec2(0.0, 0.0));

  // 23
  // float strength = distance(vUv, vec2(0.0, 0.0));

  // 24
  // float strength = 1.0 - distance(vUv, vec2(0.5, 0.5));

  // 25
  // float strength =  0.01 / distance(vUv, vec2(0.5, 0.5));

  // 26
  // float strength = 1.0 - distance(vUv, vec2(0.5, 0.5));

  // 27
  // vec2 lengthUv = vec2(
  //   vUv.x * 0.1 + 0.45, 
  //   vUv.y * 0.1 + 0.45
  // );
  // float strength = 0.01 / distance(lengthUv, vec2(0.5, 0.5));

  // 28
  // vec2 lengthUvX = vec2(
  //   vUv.x * 0.1 + 0.45, 
  //   vUv.y * 0.5 + 0.25
  // );
  // float lightX = 0.01 / distance(lengthUvX, vec2(0.5, 0.5));
  // vec2 lengthUvY = vec2(
  //   vUv.x * 0.5 + 0.25, 
  //   vUv.y * 0.1 + 0.45
  // );
  // float lightY = 0.01 / distance(lengthUvY, vec2(0.5, 0.5));
  // float strength = lightX * lightY;

  // 29
  // vec2 rotateUv = rotate(vUv, PI / 4.0, vec2(0.5));

  // vec2 lengthUvX = vec2(
  //   rotateUv.x * 0.1 + 0.45, 
  //   rotateUv.y * 0.5 + 0.25
  // );
  // float lightX = 0.01 / distance(lengthUvX, vec2(0.5, 0.5));
  // vec2 lengthUvY = vec2(
  //   rotateUv.x * 0.5 + 0.25, 
  //   rotateUv.y * 0.1 + 0.45
  // );
  // float lightY = 0.01 / distance(lengthUvY, vec2(0.5, 0.5));
  // float strength = lightX * lightY;

  // 30
  // float lightX = step(0.2, distance(vUv, vec2(0.5, 0.5)));
  // float strength = lightX;

  // 31
  // float strength = step(0.2, distance(vUv, vec2(0.5, 0.5)));

  // 32
  // float strength = 1.0 - step(0.01, abs(distance(vUv, vec2(0.5, 0.5)) - 0.25));

  // 33
  // vec2 wavedUv = vec2(
  //   vUv.x,
  //   vUv.y + sin(vUv.x * 30.0) * 0.1
  // );
  // float strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5, 0.5)) - 0.25));

  // 34
  // vec2 wavedUv = vec2(
  //   vUv.x + sin(vUv.y * 100.0) * 0.1,
  //   vUv.y + sin(vUv.x * 100.0) * 0.1
  // );
  // float strength = 1.0 - step(0.01, abs(distance(wavedUv, vec2(0.5, 0.5)) - 0.25));

  // 35
  // float angel = atan(vUv.x - 0.5, vUv.y - 0.5);
  // float strength = angel;

  // 36
  // float strength = abs(cnoise(vUv * 10.0));

  // 37
  // float strength = 1.0 - abs(cnoise(vUv * 10.0));

  // 38
  // float strength = sin(cnoise(vUv * 10.0) * 40.0);
  
  // 39
  // float strength = step(0.9, sin(cnoise(vUv * 10.0) * 20.0));

  // 40
  float strength = step(0.9, sin(cnoise(vUv * 10.0 + uTime) * 20.0));

  vec3 color = vec3(0.0);
  vec3 uvColor = vec3(vUv, 1.0);
  vec3 mixColor = mix(color, uvColor, strength);

  gl_FragColor = vec4(mixColor, 1.0);
}