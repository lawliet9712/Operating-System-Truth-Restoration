操作系统真相还原

### BOCHS 使用
- Install

linux : 
直接源码安装 bochs 即可
mac-os:
brew install bochs

- Usage 

cd L-OS && bochs -f bochsrc
如果使用报错基本都是因为 bochsrc 配置文件中，某些配置的路径找不到，比如 VGA ，BIOS 等的配置
