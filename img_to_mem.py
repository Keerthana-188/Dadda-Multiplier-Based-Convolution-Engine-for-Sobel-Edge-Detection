from PIL import Image
import numpy as np

img = Image.open("Dog_OG.png")
img = img.convert("L")  # grayscale

pixels = np.array(img)

with open("image_32.mem", "w") as f:
    for row in pixels:
        for pixel in row:
            f.write(f"{pixel:02x}\n")

print("image_32.mem generated")
print("Image size:", pixels.shape)
