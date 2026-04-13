.zeropage
    buttons1:    .res 1
    buttons2:    .res 1
    previousButtons1: .res 1
    previousButtons2: .res 1
    tempButtons1: .res 1
    tempButtons2: .res 1

    currentState: .res 1
    tempAddr: .res 2
    stateTemp1: .res 1

    softPPUCTRL:   .res 1
    softPPUMASK:   .res 1

    dmaflag:    .res 1
    drawflag:   .res 1
    ppuflag:    .res 1
    nmiflag:    .res 1

    xscroll:    .res 1
    yscroll:    .res 1

    playerX: .res 1
    playerY: .res 1 ; 0x0F
    playerMaxYleft: .res 1 ; 0x10
    playerMaxY: .res 1
    playerMaxYright: .res 1
    playerGroundCollision: .res 1
    playerPreviousCollision: .res 1
    playerVelocityY: .res 1 ; used for gravity calculation
    playerTempVelocityY: .res 1 ; used for player position
    playerVelocityX: .res 1
    playerTempVelocityX: .res 1
    playerSize: .res 1
    playerStomp: .res 1
    playerDirection: .res 1

    currentCenter: .res 1
    currentMapColumn: .res 1 ; 32
    currentColumnDestructible: .res 1
    currentColumnDestructionOffset: .res 1
    lastCollisionColumn: .res 1

    currentRenderColumn: .res 1 ; 0x1F
    tempRenderColumn: .res 1 ; 0x20
    currentRenderRow: .res 1
    currentRenderNametableAddress: .res 1
    tempRenderNametableAddress: .res 1

    currentDrawingColumn: .res 1

    tempColumnAddress: .res 1
    tempColorAddress: .res 1
    tempMapAddress: .res 1
    tempDrawAddressOffset: .res 1

    drawingLoop1: .res 1
    drawingLoop2: .res 1

    statusbarState: .res 1
    drawStatusbar1Flag: .res 1
    drawStatusbar2Flag: .res 1

    logoWaveStep: .res 1

    temp1: .res 1
    temp2: .res 1
    temp2a: .res 1
    temp3: .res 1
    temp3a: .res 1 ; 0x2F
    temp3b: .res 1 ; 0x30
    temp4: .res 1
    temp4a: .res 1

    collisionTimer: .res 1

    dmcCounter: .res 1
    dmcTemp: .res 1
    dmcIRQenable: .res 1
    