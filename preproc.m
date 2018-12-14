%% original data orig.jpg
a = prnist([0:9], [1:40:1000]

%% put objects in a square box with aspect ratio 1
%% add rows/columns to make images square step1.jpg
obj1 = im_box(a, 0, 1)

%%  rotate images to same orientation step2.jpg
obj2 = im_rotate(obj1)

%% resize images to 128 x 128 pixels step3.jpg
obj3 = im_resize(obj2, [128, 128])

%% create empty box around objects
%% add rows/columns and keep image square step4.jpg
obj4 = im_box(obj3, 1, 0)

