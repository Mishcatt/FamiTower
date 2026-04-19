bgPalettes:
    ; Background Palette
    ; Level 1
    .byte $0F, $0C, $10, $20 ; jeans_bg, gray, white
    .byte $0F, $0C, $10, $00 ; jeans_bg, gray, dark_gray
    ; Level 2
    .byte $0F, $0C, $10, $20 ; jeans_bg, gray, white
    .byte $0F, $0C, $10, $00 ; jeans_bg, gray, dark_gray
    ; Level 3
    .byte $0F, $00, $20, $31 ; dark_gray, white, sky
    .byte $0F, $31, $16, $09 ; sky, red, grass
    ; Level 4
    .byte $0F, $09, $16, $3D ; grass, red, light_gray
    .byte $0F, $24, $33, $37 ; pink, lilac, beige

spritePalettes:
    ; Sprite Palette
    .byte $0F, $38, $20, $00 ; yellow, white, gray
    .byte $0F, $11, $20, $27 ; light_blue, white, orange
    .byte $0f, $38, $20, $16 ; yellow, white, red
    .byte $0f, $38, $1D, $12 ; yellow, black, blue
