# bumblebee
An Amazon Lambda function which extracts csv data from given html file.  
Specifically used to convert [Baseball-Reference.com](https://www.baseball-reference.com/)'s html data into csv.

## how to use
Place html in the lambda function's relevant s3 bucket and let `main.rb` work.  
Practically it'll be the best to set up event trigger in s3 bucket so that placing a file triggers lambda function.

## deploy
```
$ docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --deployment
$ sam package --template-file template.yaml \
--output-template-file packaged-template.yaml \
--s3-bucket <YourBucketName>
$ sam deploy --template-file packaged-template.yaml \
--stack-name baseballReference \
--capabilities CAPABILITY_IAM
```
