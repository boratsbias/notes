# Backpropagation Applied to Handwritten Zip Code Recognition (1989)

**Authors:** Yann LeCun, B. Boser, J. S. Denker, D. Henderson, R. E. Howard, W. Hubbard, L. D. Jackel
**Area:** Computer Vision, Deep Learning
**Link:** [Neural Computation](https://direct.mit.edu/neco/article/1/4/541/5515/Backpropagation-Applied-to-Handwritten-Zip-Code)

## The problem with hand-engineered features

Pre-1989 systems for handwriting recognition required a domain expert to manually design features: stroke detectors, curve templates, aspect ratio measurements. Each feature was a brittle heuristic, tuned for a narrow task and failing to transfer across writing styles. This paper asks whether a network trained end-to-end with backpropagation can learn useful representations automatically from raw pixel data, without any feature engineering.

## Local receptive fields and weight sharing

The architecture introduces two structural constraints. **Local receptive fields** connect each neuron only to a small spatial patch of the input image, forcing each unit to specialize in local stroke patterns and edges rather than global statistics. This encodes the prior that nearby pixels are more relevant to each other than distant ones and dramatically reduces the number of weights compared to a fully connected layer.

**Weight sharing** extends this further: every neuron in a feature map uses the same filter weights, regardless of its position in the image. The same edge detector is applied at every spatial location. This reduces parameters by a factor equal to the number of positions and encodes translation invariance directly into the network structure. A digit written in the top-left corner activates the same filters as one written in the bottom-right. Together, these two constraints are the defining characteristics of a convolutional layer.

## End-to-end training

The network was trained on 7,291 digit images from US Postal Service zip codes with no hand-crafted intermediate targets. Backpropagation propagated the error signal through all layers, including the feature extraction stages, allowing the filters to specialize for the actual distribution of handwritten strokes. Test error reached approximately 1%, far below what contemporary rule-based systems achieved on the same data.

## Results and impact

This paper is the direct precursor to LeNet-5, which extended the architecture with deeper feature hierarchies and subsampling layers and became the blueprint for modern convolutional networks. The demonstration that constrained weight-sharing architectures could be trained end-to-end established the template for CNN-based computer vision.
