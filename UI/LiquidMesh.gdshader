shader_type canvas_item;

uniform vec2 resolution = vec2(0.25,0.75);
uniform vec2 offset = vec2(0.25,0.75);
uniform vec2 e = vec2(0.25,0.75);
uniform vec2 f = vec2(2.0, 4.0);
uniform vec2 g = vec2(0.00,1.00);
uniform float h = 0.5;
uniform float i = 0.0;
uniform float j = 1.0;
uniform float cell_size = 1.0;
uniform vec4 from : source_color;
uniform vec4 to : source_color ;
//背景填充颜色
uniform vec3 backFillColour : source_color = vec3(0.62,1.00,1.00);
//前景填充靠里的颜色
uniform vec3 frontFillInnerColour : source_color = vec3(0.35,1.00,1.00);
//前景填充靠边的颜色
uniform vec3 frontFillOuterColour : source_color = vec3(0.00,0.35,1.00);
//环的颜色
uniform vec3 ringColour : source_color = vec3(0.00,0.16,0.13);
//玻璃罩阴影颜色
uniform vec3 fresnelColour : source_color = vec3(0.00,0.88,1.00);
//内环发光颜色
uniform vec3 innerRingGlowColour : source_color = vec3(0.00,1.00,1.00);
//填充颜色调整
uniform vec4 fillcolour : source_color = vec4(1);
//环的宽度
uniform float ringWidth = 0.15;
//玻璃球与环的间隔
uniform float innerCircleRadiusOffset = 0.0;
//fill_value,填充球体的值
uniform float fill_value : hint_range(0, 1) = 0.25;
uniform float fill_value_x : hint_range(0, 1) = 0.25;
uniform float tolerance : hint_range(0, 1) = 0.25;
varying vec4 modulate;


// 定义函数：计算点到圆弧的距离
float sdArc(in vec2 p, in vec2 sc, in float ra, float rb)
{
    // sc is the sin/cos of the arc's aperture
	//sc 是圆弧孔径的 sin/cos
    p.x = abs(p.x);
    return ((sc.y*p.x>sc.x*p.y) ? length(p-sc*ra) : 
                                  abs(length(p)-ra)) - rb;
}
// 计算2D旋转矩阵
mat2 Get2DRotationMatrix(float angle) {
    float c = cos(angle);
    float s = sin(angle);
	vec2 V1 = vec2(c, -s);
	vec2 V2 = vec2(s, c);
    return mat2(V1,V2);
}
float dot2( in vec2 v ) { return dot(v,v); }

float sdHeart( in vec2 p )
{
    p.x = abs(p.x);

    if( p.y+p.x>j )
        return sqrt(dot2(p-e)) - sqrt(f.x)/f.y;
    return sqrt(min(dot2(p-g),
                    dot2(p-h*max(p.x+p.y,i)))) * sign(p.x-p.y);
}

float sdBox(vec2 p, vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}
vec2 pixelate_uv(vec2 uv, float cellSize)
{
	return round(uv * cellSize) / cellSize ;
}
// Color space conversion from https://godotshaders.com/shader/color-range-swap/
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float el = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + el)), d / (q.x + el), q.x);
}

// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


vec3 color_swap(vec3 source)
{
	// we usually want more granularity the closer we are to the original color
	float _tol = tolerance * tolerance;
	
	//vec4 tex = texture(TEXTURE, UV);
	vec3 source_hsv = rgb2hsv(source.rgb);
	vec3 initial_hsv = rgb2hsv(from.rgb);
	vec3 hsv_shift = rgb2hsv(to.rgb) - initial_hsv;
	
	float hue = initial_hsv.r;
	
	// the .r here represents HUE, .g is SATURATION, .b is LUMINANCE
	if (hue - source_hsv.r >= -_tol && hue - source_hsv.r <= +_tol)
	{
		vec3 final_hsv = source_hsv + hsv_shift;
		source.rgb = hsv2rgb(final_hsv);
	}
	
	return source;
}

void vertex()
{
	modulate = COLOR;
	
}

void fragment() {
// 获取屏幕像素的UV坐标
// Centered, aspect ratio-corrected, normalized pixel coordinates [0.0, 1.0].
    //vec2 uv = ((UV / -0.48)) + vec2(1.038,1.038);
	
	vec2 uv = ((pixelate_uv(UV,cell_size) / -0.48)) + vec2(1.038,1.038);//默认最佳参数
	////调整球体大小和边距，uv=((UV/调整球体大小的参数))+vec2(球体边距参数,球体边距参数)   
	// FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy 其实就是 UV
    vec2 normalizedCenteredUV = (uv - 0.5) * 2.0;
    //vec2 normalizedCenteredUV = ((FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy) - 0.5) * 2.0;
    //{应该是没用的代码，上面这行好像也不起作用，但是不知道怎么改：）
    //float aspectRatio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
    //vec2 uv = vec2(normalizedCenteredUV.x * aspectRatio, normalizedCenteredUV.y);}
    //vec2 p = (FRAGCOORD.xy*2.0-SCREEN_PIXEL_SIZE.xy)/SCREEN_PIXEL_SIZE.y;       
	//p.y+= 0.5;
    // Get circle SDF -> clip 3x circles.
    //获取圆 SDF -> 剪出 3x 圆。        
    //float circleSDF = length(uv);
	//float circleSDF = sdBox(uv,boxB);
	float circleSDF = sdHeart(uv * resolution - offset);
    
    //const float ringWidth = 0.15;//环的宽度
    //const float innerCircleRadiusOffset = 0.0;//玻璃球与环的间隔
    
    float oneMinusRingWidth = 1.0 - ringWidth;
    
    // 2x circles used to generate outer ring.
	//2x 个圆圈用于生成外环。
    
    float circleA = step(circleSDF, 1.0);
    float circleB = step(circleSDF, oneMinusRingWidth);
        
    float ring = circleA - circleB;
    
    // 1x circle used for the actual container/shell (as its mask).
	//1x 用于实际容器/外壳的圆圈（作为其遮罩）。
    
    float fillMaskCircle = step(circleSDF, oneMinusRingWidth - innerCircleRadiusOffset);
    
    // Ring glow.
	//环发光
        
    float ringGlowCircleSDF = circleSDF - 1.0;
    const float innerRingGlowRadiusOffset = 0.15;
    
    float innerRingGlow = ringGlowCircleSDF + innerRingGlowRadiusOffset;    
    float outerRingGlow = ringGlowCircleSDF;   
    
    const float outerRingGlowWidth = 0.01;
    float outerRingGlowPower = 0.8;
    
    const float innerRingGlowWidth = 0.01;
    const float innerRingGlowPower = 1.2;
    
    const float outerRingGlowAnimation = 12.0;
    const float outerRingGlowAnimationRange = 0.2;    
    
    innerRingGlow = pow(innerRingGlowWidth / innerRingGlow, innerRingGlowPower);
    innerRingGlow = clamp(innerRingGlow - fillMaskCircle, 0.0, 1.0); 
    
    outerRingGlowPower += (sin(TIME * outerRingGlowAnimation) * outerRingGlowAnimationRange);
    
    outerRingGlow = pow(outerRingGlowWidth / outerRingGlow, outerRingGlowPower);
    outerRingGlow = clamp(outerRingGlow - fillMaskCircle, 0.0, 1.0);
    
    // Progress/fill. Animated.
	//进度/填充。 动画。
    
    const float fillAnimationFrequency = 4.0;
    const float fillAnimationAmplitude = 0.05;
        
    float fillAnimationPhase = TIME * fillAnimationFrequency;
    
    float fillAnimation = sin(fillAnimationPhase) * fillAnimationAmplitude;
    
    const float waveFrequency = 2.0;
    const float waveAmplitude = 0.05;
    
    const float waveAnimation = 2.0;
    
    // Waves as repeating sine/band offsets to the horizontal gradient.
	//波作为重复正弦/频带偏移到水平梯度。
    
    float frontWavePhase = (TIME * waveAnimation) + uv.x;
    float backWavePhase = (TIME * -waveAnimation) + uv.x;
        
    frontWavePhase *= waveFrequency;
    backWavePhase *= waveFrequency;
        
    const float backWavesPhaseOffset = PI;
    
    float frontWaves = sin(frontWavePhase) * waveAmplitude;
    float backWaves = sin(backWavePhase + backWavesPhaseOffset) * waveAmplitude;
            
    float verticalBand = sin(uv.x + (PI * 0.5)) - 0.3;
    verticalBand = smoothstep(0.1, 0.9, verticalBand);
   
    // Stretch waves up/down near center, synced as they bob up/down.
	//在中心附近向上/向下拉伸波浪，当它们向上/向下摆动时同步。
    
    const float animatedVerticalBandStrength = 0.125;
    float animatedVerticalBand = verticalBand * animatedVerticalBandStrength;
            
    animatedVerticalBand *= sin(TIME * fillAnimationFrequency);
            
    frontWaves += animatedVerticalBand;
    backWaves -= animatedVerticalBand;
    
    // Pinch sides (mask by the vertical gradient band) so they don't move.
	//捏住两侧（用垂直渐变带遮盖），这样它们就不会移动。
    
    fillAnimation *= verticalBand;
            
    // Centered fill progress.居中填充进度。
    // 0.0 = center 中心, -0.5 = bottom 底部, 0.5 = top 顶部.
    
    float fillProgressAnimationFrequency = 1.0;
    float fillProgressAnimationAmplitude = 0.1;
    
    float fillProgress = mix(-0.88,0.88,fill_value);//填充进度
    
    fillProgress += sin((TIME * fillProgressAnimationFrequency) * PI) * fillProgressAnimationAmplitude;
    //fillProgress = (fillProgress - 0.5) * 2.0; 
    
    float frontFill = step(uv.y, (fillAnimation + frontWaves) + fillProgress);
    float backFill = step(uv.y, (-fillAnimation + backWaves) + fillProgress);
    //float fill_x = (1.0 - step(uv.x,  mix(1.0,-.8,fill_value_x)));
	//frontFill *= fill_x;
	//backFill *=  fill_x;
	
    frontFill *= fillMaskCircle;
    backFill *= fillMaskCircle;
    
    // Mask back fill to only parts that would be visible separate from frontFill.
	//仅将背面填充蒙版为与正面填充分开可见的部分。
    
    backFill = clamp(backFill - frontFill, 0.0, 1.0);
    
    float fillMask = 1.0 - (frontFill + backFill);
    fillMask *= fillMaskCircle;
        
    float fill = frontFill + backFill;
    
    // Simple edge glow using radial gradient (circle SDF).
	//使用径向渐变（圆形 SDF）的简单边缘发光。
    
    const float fresnelOffset = 0.01;
    float fresnel = (circleSDF + fresnelOffset) * fillMask;    
    
    const float fresnelPower = 5.0;
    fresnel = clamp(pow(fresnel, fresnelPower), 0.0, 1.0);
    
    const float frontFillFresnelPower = 5.0;
    const float frontFillFresnelOffset = 0.02;
    
    float frontFillFresnel = (circleSDF + frontFillFresnelOffset) * (1.0 - fillMask);
    frontFillFresnel = clamp(pow(frontFillFresnel, frontFillFresnelPower), 0.0, 1.0);
    
    // Specular reflection, drawn (stylized, like a cartoon) as two arcs.
	//镜面反射，绘制（风格化，像卡通）为两条弧线。
        
    float specularArcAngle1 = radians(15.0);
    float specularArcAngle2 = radians(2.0);
    
    float specularArcRotation1 = radians(60.0);
    float specularArcRotation2 = radians(28.0);
    
    vec2 specularArcSC1 = vec2(sin(specularArcAngle1), cos(specularArcAngle1));
    vec2 specularArcSC2 = vec2(sin(specularArcAngle2), cos(specularArcAngle2));
    
    const float specularArcOffset = 0.35;
    const float specularArcWidth = 0.07;
    
    vec2 specularArcUV1 = Get2DRotationMatrix(specularArcRotation1) * uv;
    vec2 specularArcUV2 = Get2DRotationMatrix(specularArcRotation2) * uv;
    
    float specularArc1 = sdArc(specularArcUV1, specularArcSC1, 1.0 - specularArcOffset, specularArcWidth);
    float specularArc2 = sdArc(specularArcUV2, specularArcSC2, 1.0 - specularArcOffset, specularArcWidth);
        
    specularArc1 = step(specularArc1, 0.0);
    specularArc2 = step(specularArc2, 0.0);
    
    const float specularStrength = 0.2;
    float specular = specularArc1 + specularArc2;
    
    specular *= specularStrength;
    
    // Final mask. Can be used as alpha.
	//最后的遮罩。 可以用作透明通道。
    
    float mask = ring + fill + fresnel + specular;
    
    // Per-mask RGB colour.
	//每个蒙版 RGB 颜色。
    
    //const vec3 ringColour = vec3(1.0, 0.9, 0.8);//环的颜色
    
    //const vec3 frontFillInnerColour = vec3(1.0, 0.2, 0.1);//前景填充靠里的颜色
    //const vec3 frontFillOuterColour = vec3(0.0, 0.0, 0.0);//前景填充靠边的颜色
    
    vec3 frontFillColour = mix(frontFillInnerColour, frontFillOuterColour, frontFillFresnel);
    
    //const vec3 backFillColour = vec3(0.5, 0.0, 0.0);//背景填充颜色
    
    const vec3 specularColour = vec3(1.0, 1.0, 0.9);//高光颜色
    //const vec3 fresnelColour = vec3(0.5, 0.0, 0.3);//玻璃罩阴影颜色
    
    //const vec3 innerRingGlowColour = vec3(1.0, 0.3, 0.1);//内环发光颜色
    const vec3 outerRingGlowColour = vec3(1.0, 0.8, 0.1);//外环发光颜色
             
    vec3 rgb =
    
        (ring * ringColour) +
        
        (innerRingGlow * innerRingGlowColour) +
        (outerRingGlow * outerRingGlowColour) +
        
        
        ((frontFill * frontFillColour) +
        (backFill * backFillColour))*fillcolour.rbg +
        (fresnel * fresnelColour) +
        (specular * specularColour);
    
    // Background gradient. Just for presentation.
	//背景渐变。 只是为了演示。
    
    const float backgroundGradientPower = 0.6;
    
    float backgroundGradient = length(normalizedCenteredUV);
    
    backgroundGradient = pow(backgroundGradient, backgroundGradientPower);
    backgroundGradient = smoothstep(0.0, 1.0, backgroundGradient);//第一个参数是背景阴影的亮度
    
    vec3 backgroundGradientInnerColour = vec3(0.13, 0.0, 0.4);
    vec3 backgroundGradientOuterColour = vec3(0.0, 0.0, 0.0);//背景外玻璃颜色
    
    vec3 background = mix(backgroundGradientInnerColour, backgroundGradientOuterColour, backgroundGradient);
    
    // Simply add the background to the composite so far.
    //到目前为止，只需将背景添加到合成中    
    background = clamp(background - (fill + ring), 0.0, 1.0);//背景-（填充+环）,亮度参数1,亮度参数2
         
    const float backgroundStrength = 0.65;//背景强度    
    background *= backgroundStrength;
    
    rgb += background;
    rgb = color_swap(rgb);
    // Output to screen.将颜色输出到屏幕
    
	COLOR = vec4(rgb, mask) * modulate;
}