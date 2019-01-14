samplesPerClass = 50;

digits = prnist([0:9], [1:samplesPerClass]);

heights = [];
widths = [];
for i=1:(samplesPerClass*10)
    crt_im = data2im(digits(i));
    crt_size = size(crt_im);
    heights = [heights, crt_size(1)];
    widths = [widths, crt_size(2)];
end

width  = pow2(floor(log2(mean(widths))));
height = pow2(floor(log2(mean(heights))));

