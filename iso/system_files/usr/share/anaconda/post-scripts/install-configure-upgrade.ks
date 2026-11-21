%post --erroronfail
bootc switch --mutate-in-place --transport registry __IMAGE_REF__:__IMAGE_TAG__
%end
