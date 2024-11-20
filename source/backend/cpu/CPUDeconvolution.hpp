//
//  CPUDeconvolution.hpp
//  MNN
//
//  Created by MNN on 2018/07/20.
//  Copyright © 2018, Alibaba Group Holding Limited
//

#ifndef CPUDeconvolution_hpp
#define CPUDeconvolution_hpp

#include "CPUConvolution.hpp"
#include "compute/CommonOptFunction.h"
#include "compute/StrassenMatmulComputor.hpp"
#include "compute/GemmInt8Executor.hpp"
#include "core/TensorUtils.hpp"
namespace MNN {
class CPUDeconvolutionBasic : public CPUConvolution {
public:
    CPUDeconvolutionBasic(const Tensor *input, const Op *convOp, Backend *b);
    virtual ~CPUDeconvolutionBasic() = default;
    virtual ErrorCode onResize(const std::vector<Tensor *> &inputs, const std::vector<Tensor *> &outputs) override;

protected:
    int mSrcCount;
    std::vector<float> mPostParameters;
};

class CPUDeconvolutionCommon : public CPUDeconvolutionBasic {
public:
    CPUDeconvolutionCommon(const Tensor *input, const Op *convOp, Backend *b, bool dynamicWeight);
    virtual ~CPUDeconvolutionCommon();

protected:
    std::shared_ptr<Tensor> mBias;
    bool mDynamicWeight;
};

class CPUDeconvolutionOrigin : public CPUDeconvolutionBasic {
public:
    CPUDeconvolutionOrigin(const Tensor *input, Tensor *weight, const Op *convOp, Backend *b, bool ModeInt8);
    virtual ~CPUDeconvolutionOrigin() = default;
    virtual ErrorCode onExecute(const std::vector<Tensor *> &inputs, const std::vector<Tensor *> &outputs) override;
    virtual ErrorCode onResize(const std::vector<Tensor *> &inputs, const std::vector<Tensor *> &outputs) override;

private:
    std::shared_ptr<StrassenMatrixComputor> mMatMul;
    std::shared_ptr<GemmInt8Executor> mDeconvInt8Exe;
    std::vector<std::pair<std::function<void(uint8_t*, int)>, int>> mPostFunctions;
    std::shared_ptr<Tensor> mTempOutput;
    std::shared_ptr<CPUConvolution::ResourceInt8> mResource;
};

class CPUDeconvolution : public CPUDeconvolutionCommon {
public:
    CPUDeconvolution(const Tensor *input, const Op *convOp, Backend *b, bool dynamicWeight);
    virtual ~CPUDeconvolution();
    virtual ErrorCode onExecute(const std::vector<Tensor *> &inputs, const std::vector<Tensor *> &outputs) override;
    virtual ErrorCode onResize(const std::vector<Tensor *> &inputs, const std::vector<Tensor *> &outputs) override;

    struct Param {
        int outputCount;
        int srcCount;
        int fh;
        int fw;
    };
private:
    Param mParam;
    std::shared_ptr<Tensor> mWeight;
    std::shared_ptr<Tensor> mWeightTransformCache;
    std::vector<Tensor *> mTempInputs;
    std::shared_ptr<CPUDeconvolutionOrigin> mOrigin;
};
} // namespace MNN
#endif /* CPUDeconvolution_hpp */
