import pixie
import random
import strutils
import os

proc getInitials(name: string): string =
  let words = name.strip().split()
  if words.len == 0:
    return ""
  elif words.len == 1:
    return if words[0].len > 0: words[0][0].toUpperAscii().`$` else: ""
  else:
    result = ""
    for word in words:
      if word.len > 0:
        result.add(word[0].toUpperAscii())

proc generateRandomColor(): ColorRGBA =
  result = rgba(
    uint8(rand(256)),
    uint8(rand(256)),
    uint8(rand(256)),
    255
  )

proc createImage(width, height: int): Image =
  result = newImage(width, height)

proc drawBackground(ctx: Context, width, height: float32, color: ColorRGBA) =
  ctx.fillStyle = color
  ctx.fillRect(rect(0, 0, width, height))

proc setupTextProperties(ctx: Context) =
  ctx.fillStyle = rgba(255, 255, 255, 255) # White text
  ctx.font = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
  ctx.fontSize = 200

proc calculateTextPosition(ctx: Context, text: string, width, height: float32): Vec2 =
  let textBounds = ctx.measureText(text)
  result = vec2(
    (width - textBounds.width) / 2,
    (height / 2) + 60
  )

proc drawText(ctx: Context, text: string, position: Vec2) =
  ctx.fillText(text, position)

proc generateInitialsImage(name: string, outputPath: string) =
  let initials = getInitials(name)
  if initials.len == 0:
    raise newException(ValueError, "Invalid input: Unable to generate initials from the given name")
  
  randomize()
  let 
    width = 500
    height = 500
    image = createImage(width, height)
    ctx = newContext(image)
    bgColor = generateRandomColor()
  
  drawBackground(ctx, width.float32, height.float32, bgColor)
  setupTextProperties(ctx)
  let textPosition = calculateTextPosition(ctx, initials, width.float32, height.float32)
  drawText(ctx, initials, textPosition)
  image.writeFile(outputPath)
  echo "Image saved to: ", outputPath

when isMainModule:
  if paramCount() < 1:
    echo "Usage: ./initial_avatar_generator 'john doe'"
    quit(1)
  
  let name = paramStr(1)  
  if name.strip().len == 0:
    echo "Error: Empty name provided"
    quit(1)
  
  let outputPath = "initials_" & name.replace(" ", "_") & ".png"
  
  try:
    generateInitialsImage(name, outputPath)
  except ValueError as e:
    echo "Error: ", e.msg
    quit(1)
  except IOError:
    echo "Error: Unable to save the image"
    quit(1)