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
    : QObject{parent},
    barcode(""),
    videoSink(new QVideoSink(this))

{
    //the costractor
}

/**
 * @brief BarcodeEngine::processVideoFrames
 * @param frames
 * this methode is ersponsible for processing the the videos frames
 */
void BarcodeEngine::processVideoFrames(const QVideoFrame &frame)
{
    qDebug() << "processVideoFrames called";

    if (!frame.isValid()) return;

    static bool processing = false;
    if (processing) {
        qDebug() << "Skipping frame - still processing previous";
        return;
    }
    processing = true;

    static int totalFrames = 0;
    totalFrames++;
    int currentFrameNumber = totalFrames;

    QVideoFrame frameCopy = frame;
    if (!frameCopy.map(QVideoFrame::ReadOnly)) {
        processing = false;
        return;
    }

    QtConcurrent::run([this, frameCopy, currentFrameNumber]() mutable {
        QImage image = convertFrameToQImage(frameCopy);
        frameCopy.unmap();  // safe even if crashed earlier

        qDebug() << "[BG Thread] Frame #" << currentFrameNumber
                 << "converted:" << (image.isNull() ? "FAILED" : "SUCCESS")
                 << image.width() << "x" << image.height();

        // Always reset processing, even on failure
        QMetaObject::invokeMethod(this, [this, image, currentFrameNumber]() mutable {
            if (!image.isNull()) {
                qDebug() << "[Main Thread] Frame #" << currentFrameNumber
                         << "ready - size:" << image.width() << "x" << image.height();

                this->processImage(std::move(image));
            } else {
                qDebug() << "[Main Thread] Frame #" << currentFrameNumber << "conversion failed";
            }

            processing = false;
        }, Qt::QueuedConnection);
    });

    qDebug() << "processVideoFrames finished (task scheduled)";
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
    auto startTime = std::chrono::high_resolution_clock::now();

    // Step 1: Calculate crop rectangle
    const qreal parentWidth = preview.width();
    const qreal parentHeight = preview.height();
    const qreal barCodeWidth = parentWidth * 0.9;
    const qreal barcodeHeight = 250;

    QRect cropRect;
    int cropWidth = (barCodeWidth / parentWidth * preview.width());
    int cropHeight = (barcodeHeight / parentHeight * preview.height());
    cropRect.setWidth(cropWidth);
    cropRect.setHeight(cropHeight);
    cropRect.moveCenter(QPoint(preview.width() / 2, preview.height() / 2));

    qDebug() << "Crop rectangle:" << cropRect;

    // Step 2: Crop the image
    preview = preview.copy(cropRect);

    qDebug() << "Processing cropped image - Height:" << preview.height() << "Width:" << preview.width();

    // Step 3: Resize the image (optional, for performance)
    preview = preview.scaled(640, 480, Qt::KeepAspectRatio);

    // Step 4: Convert image to grayscale
    if (preview.format() != QImage::Format_Grayscale8) {
        preview = preview.convertToFormat(QImage::Format_Grayscale8);
    }

    // Step 5: Wrap QImage data into ZXing::ImageView
    ZXing::ImageView imageView(
        preview.bits(),
        preview.width(),
        preview.height(),
        ZXing::ImageFormat::Lum // Grayscale format
        );

    // Step 6: Set decoding hints
    ZXing::ReaderOptions hints;
    hints.setTryHarder(true); // Disable TryHarder for faster decoding
    hints.setFormats(ZXing::BarcodeFormat::EAN13 | ZXing::BarcodeFormat::EAN8 | ZXing::BarcodeFormat::UPCA);

    // Step 7: Decode the barcode
    ZXing::Barcode result = ZXing::ReadBarcode(imageView, hints);

    // Step 8: Handle the result
    if (result.isValid()) {
        qDebug() << "Decoded content:" << QString::fromStdString(result.text());
        qDebug() << "Format:" << QString::fromStdString(ZXing::ToString(result.format()));
        setBarcode(QString::fromStdString(result.text()));
    } else {
        qDebug() << "No barcode detected.";
    }

    auto endTime = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();
    qDebug() << "Processing time:" << duration << "ms";
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
    //grayscale format
    QImage gray = img.convertToFormat(QImage::Format_Grayscale8);

    QImage sharpened(gray.size(), QImage::Format_Grayscale8);
    const uchar *src = gray.bits();
    uchar *dst = sharpened.bits();
    int width = gray.width();
    int height = gray.height();
    int bytesPerLine = gray.bytesPerLine();

    //Laplacian filter
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
    QVideoFrame f(frame);
    if (!f.map(QVideoFrame::ReadOnly)) {
        qDebug() << "Failed to map frame for conversion";
        return QImage();
    }

    int w = f.width();   // 1920 (landscape from sensor)
    int h = f.height();  // 1080

    QVideoFrameFormat::PixelFormat pixelFormat = f.surfaceFormat().pixelFormat();

    if (pixelFormat != QVideoFrameFormat::Format_NV21) {
        qDebug() << "Unsupported format for manual conversion:" << pixelFormat;
        f.unmap();
        return QImage();
    }

    const uchar* yData = f.bits(0);
    const uchar* vuData = f.bits(1);
    int yStride = f.bytesPerLine(0);
    int vuStride = f.bytesPerLine(1);

    // Create landscape RGB image first
    QImage landscape(w, h, QImage::Format_RGB888);
    uchar* rgbData = landscape.bits();
    int rgbStride = landscape.bytesPerLine();

    // Manual NV21 to RGB888 conversion (BT.601 standard)
    for (int y = 0; y < h; ++y) {
        const uchar* yLine = yData + y * yStride;
        const uchar* vuLine = vuData + (y / 2) * vuStride;
        uchar* rgbLine = rgbData + y * rgbStride;

        for (int x = 0; x < w; ++x) {
            int xVu = (x / 2) * 2;  // VU pair index

            uint8_t Y = yLine[x];
            uint8_t V = vuLine[xVu];
            uint8_t U = vuLine[xVu + 1];

            // YUV to RGB conversion formulas (BT.601)
            int r = qBound(0, Y + ((351 * (V - 128)) >> 8), 255);
            int g = qBound(0, Y - ((179 * (V - 128) + 89 * (U - 128)) >> 8), 255);
            int b = qBound(0, Y + ((444 * (U - 128)) >> 8), 255);

            rgbLine[3 * x + 0] = static_cast<uchar>(r);
            rgbLine[3 * x + 1] = static_cast<uchar>(g);
            rgbLine[3 * x + 2] = static_cast<uchar>(b);
        }
    }

    f.unmap();

    // Critical fix: Rotate 90° clockwise to match portrait preview on screen
    QImage portrait = landscape.transformed(QTransform().rotate(90));

    qDebug() << "Manual NV21 → RGB + 90° rotation completed:"
             << w << "x" << h << "→" << portrait.width() << "x" << portrait.height();

    return portrait;
}
/**
 * @brief BarcodeEngine::matToQImage
 * @param mat
 * @return an image from cv::mat
 */
QImage BarcodeEngine::matToQImage(const cv::Mat &mat)
{
    switch (mat.type()) {
    case CV_8UC3: {
        QImage img(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_RGB888);
        return img.rgbSwapped(); // BGR -> RGB
    }
    case CV_8UC4: {
        return QImage(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_ARGB32);
    }
    case CV_8UC1: {
        return QImage(mat.data, mat.cols, mat.rows, mat.step, QImage::Format_Grayscale8);
    }
    default:
        qWarning() << "Unsupported cv::Mat format for conversion:" << mat.type();
        return QImage();
    }
}
/**
 * @brief BarcodeEngine::qImageToMat
 * @param image
 * @return cv::mat from QImage
 */
cv::Mat BarcodeEngine::qImageToMat(const QImage &image)
{
    switch (image.format()) {
    case QImage::Format_RGB888: {
        cv::Mat mat(image.height(), image.width(), CV_8UC3,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        cv::Mat matBGR;
        cv::cvtColor(mat, matBGR, cv::COLOR_RGB2BGR);
        return matBGR;
    }
    case QImage::Format_ARGB32:
    case QImage::Format_ARGB32_Premultiplied:
    case QImage::Format_RGB32: {
        cv::Mat mat(image.height(), image.width(), CV_8UC4,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        cv::Mat matBGR;
        cv::cvtColor(mat, matBGR, cv::COLOR_BGRA2BGR); // Drop alpha
        return matBGR;
    }
    case QImage::Format_Grayscale8: {
        cv::Mat mat(image.height(), image.width(), CV_8UC1,
                    const_cast<uchar*>(image.bits()), image.bytesPerLine());
        return mat.clone();
    }
    default:
        qWarning() << "Unsupported QImage format for conversion:" << image.format();
        return cv::Mat();
    }
}


