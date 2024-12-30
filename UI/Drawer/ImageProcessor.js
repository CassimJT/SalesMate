function makeImageRound(image, width, height) {
    console.log("Processing....")
    const canvas = new Canvas(width, height);
    const ctx = canvas.getContext("2d");

    // Draw the circular mask
    ctx.beginPath();
    ctx.arc(width / 2, height / 2, width / 2, 0, 2 * Math.PI);
    ctx.clip();

    // Draw the image into the circular area
    ctx.drawImage(image, 0, 0, width, height);

    // Return the resulting image as a data URL
    return canvas.toDataURL();
}
