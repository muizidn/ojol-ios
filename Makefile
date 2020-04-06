xconfig:
	rm -rf temp/*.xconfig
	mkdir -p temp
	fastlane run create_xconfig

xctemplate:
	bash scripts/xctemplate.sh

gendoc:
	git branch -D gh-pages || true
	git checkout -b gh-pages
	bundle exec jazzy
	git add docs && git commit -m "update docs"
	echo "Docs generated. Done!"

screenshoot:
	fastlane snapshot
	
genproj:
	swiftgen
	xcodegen
	pod install

setuprome:
	mkdir -p ~/.aws
	touch ~/.aws/credentials
	echo "[default]" >> ~/.aws/credentials
	echo "aws_access_key_id = $(AWS_ACCESS_KEY_ID)" >> ~/.aws/credentials
	echo "aws_secret_access_key = $(AWS_SECRET_ACCESS_KEY)" >> ~/.aws/credentials

	touch ~/.aws/config
	echo "[default]" >> ~/.aws/config
	echo "region = ap-southeast-1" >> ~/.aws/config
