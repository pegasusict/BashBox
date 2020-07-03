[![Codacy Badge](https://app.codacy.com/project/badge/Grade/6ccdfa5c43424960a00ef5a16541a2e1)](https://www.codacy.com/manual/pegasus.ict/BashBox?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=pegasusict/BashBox&amp;utm_campaign=Badge_Grade)

# BashBox - A BASH v4+ Framework

This is my attempt at building a framework for BASH.

## Acknowledgements:

ini parser: [Ruediger Meier](https://github.com/rudimeier/)

### Updates:

 - 2020-07-02: A complete overhaul has begun
   - decided to change my function library into a framework due to benefits.
 - 2019-11-04: new autoloading system, inspired on PHP's autoloader.


### Functionality:

| Functionality         | Status  | Progr. | Remarks                             |
|-----------------------|:-------:|:------:|-------------------------------------|
| apt-get               |  alpha  |    50% |                                     |
| arg parsing           |  alpha  |    50% |                                     |
| cfg parsing           |  alpha  |    50% |                                     |
| date/time             |  beta   |     -- | needs to be expanded                |
| exit codes            |   dev   |    40% |                                     |
| file content          |  beta   |        | needs to be expanded                |
| filesystem            |  beta   |        | needs to be expanded                |
| ftp                   | planned |        |                                     |
| git                   |  draft  |    50% |                                     |
| header                |  alpha  |    50% | generates comment blocks            |
| ini parsing           |  alpha  |    50% |                                     |
| logging               |  alpha  |    10% | rewritten, needs new tests          |
| LXC                   |  beta   |        |                                     |
| module autoloader     | alpha   |    10% | rewritten autoloader; needs testing |
| module install/update | planned |    10% | depends: git                        |
| mutex (lock files)    |  alpha  |        |                                     |
| net                   |  beta   |        | dns check, cycle connections        |
| RSA keys              |  alpha  |        |                                     | 
| sed                   | planned |        | advanced stream parsing/editing     | 
| SSH                   | planned |        |                                     | 
| SSH FS                | planned |        | (also known as fish of sftp)        | 
| temp dirs/files       |  alpha  |        |                                     |
| templating            | planned |        |                                     |
| terminal              |  beta   |        |                                     |
| user interfacing      |  alpha  |        |                                     |
| variable manipulation |  beta   |        |                                     |
