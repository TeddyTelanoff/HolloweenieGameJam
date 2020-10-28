#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D playerMask;
uniform vec2 playerPos;
uniform float playerView;
uniform vec2 texSize;
uniform float viewWidth;
uniform float viewHeight;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec4 vertPosition;

bool inSideCircle()
{
    // return vertPosition.x >= playerPos.x - playerView && vertPosition.x <= playerPos.x + playerView &&
    //     vertPosition.y >= playerPos.y - playerView && vertPosition.y <= playerPos.y + playerView;

    // return texture2D(texture, vertTexCoord.st + vec2(playerPos.x / texSize.x, playerPos.y / texSize.y)) == vec4(0, 0, 0, 1);

    float dx = (playerPos.x - vertPosition.x);
    float dy = (playerPos.y - vertPosition.y);
    return sqrt(dx*dx + dy*dy) < playerView;
}

void main()
{
    if (inSideCircle())
    {
        if (vertTexCoord.st == vec2(0) || true)
            gl_FragColor = vertColor;
        else
            gl_FragColor = texture2D(texture, vertTexCoord.st);
    }
}