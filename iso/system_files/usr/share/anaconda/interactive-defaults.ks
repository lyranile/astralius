lang en_US.UTF-8
keyboard --xlayouts='us'
ostreecontainer --url=__IMAGE_REF__:__IMAGE_TAG__ --transport=containers-storage --no-signature-verification
%include /usr/share/anaconda/post-scripts/install-configure-upgrade.ks
%include /usr/share/anaconda/post-scripts/install-flatpaks.ks
%include /usr/share/anaconda/post-scripts/secureboot-enroll-key.ks
