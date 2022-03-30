UPLOAD FROM SMARTPHONE TO PC
TRANSMITT PROTOCOL;
```json
//SCAN QR CODE AND GET IP AND SCODE
//io channel 'request'
{//phone->pc
    "type":"upload",
    "uuid" : "ss",
    "scode":"1234",
    "filename":"file.docx",
    "size": "1000",//byte
    "deviceid": "Marc's Laptop",
}
//io channel 'response'
{//pc->phone
    "type":"accepted",
    "uuid":"s",
    "task_id":"0000"
}
//io channel 'task'
{//phone->pc
    "type":"transfer",
    "uuid":"0000",
    "data" : "000000000000000000000000000000000"//byte
}
//io channel 'response'
{//pc->phone
    "type":"validate",
    "uuid":"0000",//byte
}
//close connexion

```