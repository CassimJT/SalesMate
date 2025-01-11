function func() {
    if (camera.torchMode === Camera.TorchOff) {
                camera.torchMode = Camera.TorchOn;
                console.log("Torch turned on.");
            } else {
                camera.torchMode = Camera.TorchOff;
                console.log("Torch turned off.");
            }
}
