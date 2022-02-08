import cv2
images = [cv2.imread(f"letters/letter{i+1}.png") for i in range(58) if i+1 != 27]


resized = [cv2.copyMakeBorder(im, 0, 12-im.shape[0], 0, 8-im.shape[1], cv2.BORDER_CONSTANT, 0) for im in images]

im = cv2.hconcat(resized)
im = cv2.copyMakeBorder(im, 0, 0, 0, 8)

cv2.imwrite("letters.png", im)