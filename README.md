Dev: [![Codacy Badge](https://app.codacy.com/project/badge/Grade/6ccdfa5c43424960a00ef5a16541a2e1)](https://www.codacy.com/manual/pegasus.ict/BashBox?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=pegasusict/BashBox&amp;utm_campaign=Badge_Grade)

# BashBox - A BASH Framework

This is my attempt at building a framework for BASH.

## Acknowledgements:

ini parser: [Ruediger Meier](https://github.com/rudimeier/)

### Updates:

 - 2020-07-02: A complete overhaul has begun
   - decided to change my function library into a framework due to benefits.
 - 2019-11-04: new autoloading system, inspired on PHP's autoloader.


### Functionality:

| Functionality         | Status  | Progress | Remarks                             |
|-----------------------|:-------:|---------:|-------------------------------------|
| module autoloader     | alpha   |      10% | rewritten autoloader; needs testing |
| module install/update | planned |      10% | depends: git                        |
| logging               |  alpha  |      10% | rewritten, needs new tests          |
| ini parsing           |  alpha  |      50% |                                     |
| apt-get               |  alpha  |      50% |                                     |
| git                   |  draft  |      50% |                                     |
| exit codes            |   dev   |      40% |                                     |
| date/time             |   beta  |       -- |                                     |
| file content          | partial |          |                                     |
| templating            | planned |          |                                     |
| filesystem            | partial |          |                                     |
| temp dirs/files       |         |          |                                     |
| mutex (lock files)    |         |          |                                     |
| RSA keys              |         |          |                                     | 
