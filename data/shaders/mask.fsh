#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec4 playerPos;
uniform float playerView;
uniform vec4 texSize;
uniform vec4 canvasSize;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 vertPosition;

bool inSideCircle()
{
    vec4 dist = vertPosition - playerPos;

    return sqrt(dist.x*dist.x + dist.y*dist.y) <= playerView;
}

void main()
{
    if (texture)
        gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor;
    else
        gl_FragColor = vertColor;
}