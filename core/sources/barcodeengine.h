#ifndef BARCODEENGINE_H
#define BARCODEENGINE_H

#include <QObject>
#include <QtMultimedia>
#include <QMediaCaptureSession>
#include <QVideoSink>
#include <QVideoFrame>
#include <QImage>
#include <QPermission>
#include <QImage>
#include <ZXingCpp.h>
#include <ImageView.h>
#include "Barcode.h"
#include "ReaderOptions.h"
#include <ReadBarcode.h>
#include <DecodeHints.h>
#include <qimage.h>
#include <QVideoFrameFormat>
#include <opencv2/opencv.hpp>
#include <QtConcurrent>


class BarcodeEngine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString barcode READ getBarcode WRITE setBarcode NOTIFY barcodeChanged FINAL)

public:
    explicit BarcodeEngine(QObject *parent = nullptr);

public slots:
    void processVideoFrames(const QVideoFrame &frame);

    void setVideoSink(QVideoSink *sink);

    void processImage(QImage preview);

    QString getBarcode() const;
    void setBarcode(const QString &newBarcode);

    QImage adjustBrightnessAndContrast(const QImage& img);

    QImage sharpenImage(const QImage& img);

    QImage convertFrameToQImage(const QVideoFrame &frame);

signals:
    void barcodeDetected(const QString &barcodeText);

    void barcodeChanged();
    //void stockBarcodeChanged();

private:
    QVideoSink *videoSink = nullptr;

    int frameCounter = 0;

    int frameToSkip = 3;

    QString barcode;

    QImage image;

    QImage matToQImage(const cv::Mat &mat);

    cv::Mat qImageToMat(const QImage &image);

    bool m_processing = false;
};

#endif // BARCODEENGINE_H
