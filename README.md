num4mechaequation
=================
数値計算による力学的な方程式類を解くFFI

## decscription ##

詳細は、https://siranovel.github.io/mydocs/num4phyequation/num4mechaequation 

## Demo ##

## VS. ##

## Requirement ##

ruby num4simdiffライブラリ

## Usage ##

sample/spec内の各ファイル参照

## install ##

From rubygems:  
~~~
    [sudo] gem install num4mechaequ
~~~

Install via Gemfile:  
~~~
source "https://rubygems.pkg.github.com/siranovel" do
    gem "num4mechaequ"
end
~~~

or from the git repository on github:  
~~~
    git clone https://github.com/siranovel/num4mechaequation.git  
    cd num4mechaequation  
    jruby -S gem build num4mechaequ.gemspec
    jruby -S gem install num4mechaequ
~~~

## Contribution ##

## Licence ##
[MIT](LICENSE)

## Author ##

[siranovel](https://github.com/siranovel)
