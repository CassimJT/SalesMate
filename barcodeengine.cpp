#include "barcodeengine.h"
#include <algorithm>
#include <qdebug.h>
#include <qimage.h>
#include <qlogging.h>
#include <qmediadevices.h>
#include <qvideoframe.h>
#include <qvideoframeformat.h>
#include <qvideosink.h>

BarcodeEngine::BarcodeEngine(QObject *parent)
    : QObject{parent}
    ,videoSink(new QVideoSink(this))

{
    //the costractor
    barcode = "";

}

/**
 * @brief BarcodeEngine::processVideoFrames
 * @param frames
 * this methode is ersponsible for processing the the videos frames
 */
void BarcodeEngine::processVideoFrames(const QVideoFrame &frames)
{
    //
    QVideoFrame video_frame = frames;
    frameCounter++;
    if(frameCounter % (frameToSkip + 1) != 0) {
        return;
    }
    //chacking if the frames are valide
    if (frames.isValid()) {
        if(video_frame.map(QVideoFrame::ReadOnly)) {
            //convet the frma to gray scale
        }

    } else {
        qDebug() << "Frames not Valide";
    }
}
/**
 * @brief BarcodeEngine::setVideoSink
 * @param sink
 * this methode receives video frames from the qmlside
 */
void BarcodeEngine::setVideoSink(QVideoSink *sink)
{
    if(sink) {
        videoSink = sink;
        connect(videoSink, &QVideoSink::videoFrameChanged, this, &BarcodeEngine::processVideoFrames);
    }
}
/**
 * @brief BarcodeEngine::processImage
 * @param id
 * @param preview
 *
 */
void BarcodeEngine::processImage(QImage preview)
{
    // Define scanner area dimensions relative to the input image
    const qreal parentWidth = preview.width();
    const qreal parentHeight = preview.height();
    const qreal barCodeWidth = parentWidth * 0.9;
    const qreal barcodeHeight = 142;

    // Step 1: Calculate crop rectangle
    QRect cropRect;

    // Calculate crop rectangle dimensions, enforcing minimum width and height
    int cropWidth = (barCodeWidth / parentWidth * preview.width());
    int cropHeight = (barcodeHeight / parentHeight * preview.height());

    // Set the crop rectangle and center it
    cropRect.setWidth(cropWidth);
    cropRect.setHeight(cropHeight);
    cropRect.moveCenter(QPoint(preview.width() / 2, preview.height() / 2)); // Center the crop area
    // Step 2: Crop the image
    preview = preview.copy(cropRect);

    // Step 3: Resize the image if still too small after cropping
    /* if (preview.width() < 800 || preview.height() < 200) {
        preview = preview.scaled(800, 200, Qt::KeepAspectRatio, Qt::SmoothTransformation);
    }*/

    qDebug() << "Processing cropped and resized image - Height:" << preview.height() << "Width:" << preview.width();

    // Step 4: Convert image to grayscale if not already
    if(preview.format() != QImage::Format_Grayscale8) {
        preview = preview.convertToFormat(QImage::Format_Grayscale8);
    }
    //preview = sharpenImage(preview);
    //preview = adjustBrightnessAndContrast(preview);

    // Step 5: Wrap QImage data into ZXing::ImageView
    ZXing::ImageView imageView(
        preview.bits(),
        preview.width(),
        preview.height(),
        ZXing::ImageFormat::Lum // Grayscale format
        );

    // Step 6: Set decoding hints
    ZXing::DecodeHints hints;
    hints.setTryHarder(true); // Maximize decoding effort
    hints.setFormats(ZXing::BarcodeFormat::EAN13 | ZXing::BarcodeFormat::EAN8 | ZXing::BarcodeFormat::UPCA); // Focus on expected formats

    // Step 7: Decode the barcode
    ZXing::Result result = ZXing::ReadBarcode(imageView, hints);

    // Step 8: Handle the result
    if (result.isValid()) {
        qDebug() << "Decoded content:" << QString::fromStdString(result.text());
        qDebug() << "Format:" << QString::fromStdString(ZXing::ToString(result.format()));
        setBarcode(QString::fromStdString(result.text()));
    } else {
        qDebug() << "No barcode detected.";
    }
}
/**
 * @brief BarcodeEngine::getBarcode
 * @return the barcode
 */
QString BarcodeEngine::getBarcode() const
{
    return barcode;
}
/**
 * @brief BarcodeEngine::setBarcode
 * @param newBarcode
 * set the barcode after being processed
 */
void BarcodeEngine::setBarcode(const QString &newBarcode)
{
    if (barcode == newBarcode) {
        emit barcodeChanged(); //emiting a signal when barcode alreday have a value = newBarcode
        return;
    }

    barcode = newBarcode;
    emit barcodeChanged();
}
/**
 * @brief BarcodeEngine::adjustBrightnessAndContrast
 * @param img
 * @return a shappeded image for easy procssing by zxing
 */
QImage BarcodeEngine::adjustBrightnessAndContrast(const QImage &img)
{
    QImage gray = img.convertToFormat(QImage::Format_Grayscale8);
    uchar* data = gray.bits();
    int size = gray.width() * gray.height();

    int minVal = 255, maxVal = 0;
    for (int i = 0; i < size; i++) {
        minVal = std::min(minVal, static_cast<int>(data[i]));
        maxVal = std::max(maxVal, static_cast<int>(data[i]));
    }

    double alpha = 255.0 / (maxVal - minVal);
    int beta = -minVal * alpha;

    for (int i = 0; i < size; i++) {
        int newValue = static_cast<int>(data[i] * alpha + beta);
        data[i] = qBound(0, newValue, 255);
    }
    return gray;
}
/**
 * @brief BarcodeEngine::sharpenImage
 * @param img
 * @return shappened image for easy processing by zxing
 */
QImage BarcodeEngine::sharpenImage(const QImage &img)
{
    // Ensure grayscale format
    QImage gray = img.convertToFormat(QImage::Format_Grayscale8);

    QImage sharpened(gray.size(), QImage::Format_Grayscale8);
    const uchar *src = gray.bits();
    uchar *dst = sharpened.bits();
    int width = gray.width();
    int height = gray.height();
    int bytesPerLine = gray.bytesPerLine();

    // Apply Laplacian filter
    for (int y = 1; y < height - 1; ++y) {
        for (int x = 1; x < width - 1; ++x) {
            int center = src[y * bytesPerLine + x];
            int left = src[y * bytesPerLine + x - 1];
            int right = src[y * bytesPerLine + x + 1];
            int up = src[(y - 1) * bytesPerLine + x];
            int down = src[(y + 1) * bytesPerLine + x];

            // Laplacian sharpening formula
            int value = 5 * center - left - right - up - down;
            dst[y * bytesPerLine + x] = qBound(0, value, 255);
        }
    }
    return sharpened;
}
/**
 * @brief BarcodeEngine::convertFrameToQImage
 * @param frame
 * @return The frame as Qimage
 */
QImage BarcodeEngine::convertFrameToQImage(const QVideoFrame &frame)
{

}


