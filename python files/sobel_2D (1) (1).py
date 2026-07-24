from PIL import Image
import numpy as np

WIDTH = 30
HEIGHT = 30

with open("DOG_x_32.mem") as f:
    gx = np.array([int(x.strip(),16) for x in f], dtype=np.int32)

with open("DOG_y_32.mem") as f:
    gy = np.array([int(x.strip(),16) for x in f], dtype=np.int32)

mag = gx + gy
mag = np.clip(mag, 0, 255)

img = Image.fromarray(
    mag.reshape(HEIGHT, WIDTH).astype(np.uint8),
    mode="L"
)

img.save("DOG_SOBEL_32.png")

print("DOG_SOBEL_32.png generated")
