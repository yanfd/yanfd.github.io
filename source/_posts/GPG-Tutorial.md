---
title: GPG Tutorial
date: 2023-12-05 23:01:41
tags: tech
cover: https://p.ipic.vip/mn2fgp.webp
---

### GPG 加密解密简明教程

大家都知道，互联网上充斥着大量的明文传输方式，可以说绝对是不安全地带。那么，我们如何保证在不安全的互联网中更可靠的传输重要数据呢？个人认为最好的方式之一就是使用 GPG 工具进行加密。此文只是简单介绍了 GPG 的常规用法，重在推广和普及 GPG 加密工具，详细的使用请参见 GPG 手册。

#### 名词解释

RSA / DSA / ElGamal : 是指加密算法

GPG :（全称 GnuPG ) 是一款非对称加密(PGP)的免费软件，非对称加密方式简单讲就是指用公钥加密文件，用私钥解密文件。如果你想给谁发送加密信息，首先你要得到他的公钥，然后通过该公钥加密后传给他，对方利用自已的私钥就可解密并读取文件了。

    # 配置文件介绍
    GPG 配置文件目录:~/.gnupg
    ~/.gnupg/gpg.conf – 配置文件
    ~/.gnupg/trustdb.gpg – 信任库
    ~/.gnupg/pubring.gpg – 公钥库
    ~/.gnupg/secring.gpg – 私钥库

#### 基本操作

- 生成密钥对

  gpg --gen-key

生成过程中会让你选择加密方式，一般选 (1) RSA and RSA (default) 就可以了，然后还需要选择加密位数、过期日期及输入姓名，邮件地址，备注，Passphrase(访问密码）等信息。最后你就可以干点别的事，比如上上网，玩玩游戏什么的，以便让机器生成一些随机数，回头你就可以看到密钥对已经生成完毕。

- 传播公钥：
  导出公钥:生成后你可以把公钥中公钥库中导出来，以便传播给你的朋友。

    gpg --export --armor mykeyID > gpgkey.pub.asc # mykeyID 部分可以用 name 或 mail 地址代替

    

注： - -armor 表示加内容转换成可见的 ASCII 码输出,否则是二进制不可见内容。
现在你可以把导出的公钥通过 Email 等途径发送给你的朋友了，或者你也可以不导出公钥直接上传公钥到密钥服务器。

    gpg --keyserver keyserverAddress --send mykeyID

注： --keyserver 可以不加，默认为 keys.gnupg.net
然后只要把公钥 ID 和服务器地址告诉给朋友就可以了，朋友可以通过搜索你的 公钥 ID ，Email 地址或名字来获取并导入你的公钥，如下：

    gpg --keyserver keyserverAddress --search-keys keyid/name/Email

比如搜索我的：

    gpg --keyserver keyserver.ubuntu.com --search-keys rikulu

- 导入朋友的公钥

当你获得朋友的公钥文件后，你首先需要导入公钥到公钥库

    gpg --import gpgkey.pub.asc

或直接从公钥服务器导入

gpg --keyserver keyserverAddress --recv-keys pubkeyID

#### 私钥备份与密钥回收

- 密钥的导出和导入:以便用来备份密钥或导入到其它机器上。
  导出

    gpg -oa seckey.asc --export-secret-keys mykeyID

导入

gpg --import seckey.asc

- 密钥回收:当您的密钥对生成之后，您应该立即做一个公钥回收证书，如果您忘记了您的私钥的口令或者您的私钥丢失或者被盗窃，您可以发布这个证书来声明以前的公钥不再有效。
  生成回收证书

    gpg --output revoke.asc --gen-revoke mykeyID

导入回收证书

    gpg --import revoke.asc

发送回收证书到服务器，声明原 GPG Key 作废

    gpg --keyserver keyserverAddress --send mykeyID

#### 列出机器中保存的所有密钥

列出所有公钥

    gpg -k

列出所有私钥

    gpg -K

#### 常规使用

- 非对称文件加密与解密：

加密：当你导入完好友的公钥后，就可以用朋友的公钥加密文件了，

    gpg -e -r username filename (-r 表示指定用户)

解密：上面的操作会生成 filename.gpg 加密文件，之后你可以把此文件发送给好友了，对方就可以用自已的密钥来解密文件了。

    gpg -d filename.gpg

- 对称加密与解密： 有时候没有得到对方的公钥，而且资料不是太重要，此时还可以使用简单的对称加密方式(加密及解密都使用相同的密钥/密码)，加密过程中提示输出对称密钥/密码，注意:此密码是临时用的密码,不要设置和自己的私钥保护密码一样，以防别人猜测及盗用!

加密

    gpg --symmetric filename

解密

    gpg -d filename.gpg

- 对文件签名

数字签名

    gpg -o doc.sig -s doc

其中doc是原文件，doc.sig包含了原文件和签名，是二进制的。这个命令会要求你输入你的私钥的密码句。

    gpg -o doc.sig -ser name doc 既签名又加密

文本签名

    gpg -o doc.sig --clearsign doc

这样产生的doc.sig同样包含原文件和签名，其中签名是文本的，而原文件不变。
分离式签名

gpg -o doc.sig -ab doc

doc.sig仅包括签名，分离式签名的意思是原文件和签名是分开的。
b 表示分离式签名detach-sign
验证签名

gpg --verify doc.sig [doc]

---

转载自

<u>*作者: riku*</u> 

本文采用CC BY-NC-SA 2.5协议 授权

