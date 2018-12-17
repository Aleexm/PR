%% original data
digits = prnist([0:9], [1:40:1000])

%% put objects in a square box with aspect ratio 1
%% add rows/columns to make images square
pdigits = im_box(digits, 0, 1)

%%  rotate images to same orientation
%%obj2 = im_rotate(obj1)

%% resize images to 128 x 128 pixels
pdigits = im_resize(pdigits, [128, 128])

%% create empty box around objects
%% add rows/columns and keep image square
pdigits = im_box(pdigits, 1, 0)

%% iterate over prdatafile, convert to images
%% close images and remove noise
for i = 1:250
    im = data2im(pdigits(i));
    %% commented in order to don't generate 250x2 images
    %% imwrite(im, sprintf('imgs/%s_%d.jpg',"orig",i));
    se = strel('disk',2);
    im = imclose(im, se);
    im = imerode(im,se);
    im = imdilate(im,se);
    %% commented same reasoing as above
    %% imwrite(im, sprintf('imgs/%s_%d.jpg',"proc",i));
    p_imgs{i} = im;
end
