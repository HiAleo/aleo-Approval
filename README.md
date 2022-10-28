# approval.aleo

## Overview
This program provides an approval procedure based on Aleo record. In which you can propose an issue, then deliver it to approvers one by one. At last, you can get money with the issued record or else be rejected.

## Steps
1. propose(first, second, steps, money_amount, money_receiver) is called by the initiator to specify a "first and second" approver, the number of approvers, the content of the approval description text, and the coin_a amount to apply, payee and other information. If successful, an approval record will be created and sent to the first approver and payee.
2. approval_0(record, option) is called by the first approver, who checks the proposal.record received in step 1, call approval_0 according to the status information is 0, parameter option=0 means agree, and other values mean reject. If agree, update the record.tatus and build a new proposal record to send to the second approver and the payee who mainly checks the progress according to the record.
3. approval_1 (record, option) is called by the second approver, who checks the proposal.record received in step 2, call approval_1 according to the status information is 1, parameter option=0 means agree, and other values mean reject, If agree, the record.status will be updated and  build a new proposal record to send to the payee, who can use the following steps to get money(coin_a).
4. get_money (record) is called by the payee, who passes the received proposal in step 3 Record to collect money in minutes. If record.status != record.steps means that if the approval is rejected or not completed, it cannot succeed. Otherwise, the record.money_receiver can receive coin_a of the specified amount in the record.money field

### Note：
Due to the limitation of "MAX_OPERANDS=8", the number of fields in a record cannot exceed 6 (the other two are occupied by owners and gates), so there is no way to create more complex approval records and more approvers. It is expected that Aleo snorkVM will be further empty


## 概要
一个基于Record进行传递分发的审批流Aleo程序, 用户可以发起审批, 然后逐个发送到审批者. 通过后就可以获取资金, 否则被拒接.

## 步骤
  1. propose 由发起人调用，指定一个审批的『第一，第二』审批人，审批人数，审批描述文本内容，申请coin_a款项额度，收款人等信息，成功则创建一个审批Record记录，并发送给第一审批人和收款人。
  2. approval_0(record, option) 由第一审批人调用，他查看在第一步中接收到的 proposal.record ，根据其中的 status 信息为 0，调用approval_0接口进行审批, option=0表示同意，其他数值表示拒绝，如果同意则更新 record.status 构建一个新的 proposal.record 发送给第二审批人和收款人，收款人主要是根据 record 查看进度。
  3. approval_1(record, option) 由第二审批人调用，他查看在第二步中接收到的 proposal.record, 根据其中的 status 信息为 1， 调用approval_1接口进行审批，option=0表示同意，其他数值表示拒绝，如果同意则更新 record.status 构建一个新的 proposal.record 发送给收款人，收款人可以利用下面的步骤来收款了。
  4. get_money(record) 由收款人调用，他传递第三步中的收到的 proposal.record 进行mint收款，如果record.status != record.steps则表示该审批被否决或者尚未结束，则无法成功，否则就可以接收到 record.money 字段指定额度的 coin_a
  
### 注:
   由于受到 『MAX_OPERANDS = 8』的限制，一个record中的字段数量无法超过6（另两个被owner和gates占据），所以没有办法建立更复杂的审批Record和更多的审批人数，期望Aleo snarkVM后继能够进一步提升空间。

## Build Guide and Demo
First, build the program.
```bash
aleo build
```

Now assume that user address is "aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq",
the first approver is "aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4",
the second approver is "aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk".

### 1. Propose 
We need add user's address and private_key to program.json.
```bash
    "development": {
        "private_key": "APrivateKey1zkpB3DxLAYtTP2NZ3dZiebXaAJtt7ZSQQ6LMEhVyKy2ynVH",
        "address": "aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq"
    },
```
Run the command.
```bash
aleo run propose "aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4" "aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk" 2u64 100u64 "aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq"

➡️  Outputs

 • {
  owner: aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,
  gates: 0u64.private,
  first: aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,
  second: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private,
  steps: 2u64.private,
  money: 100u64.private,
  user: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  status: 0u64.private,
  _nonce: 3748039912422390871690277358410268566505423656152777624959979017988490974585group.public
}
 • {
  owner: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  gates: 0u64.private,
  first: aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,
  second: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private,
  steps: 2u64.private,
  money: 100u64.private,
  user: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  status: 0u64.private,
  _nonce: 3893043370746969475692258358516755325769654110419007516828834432369957061053group.public
}
```

The first record is owned by the first approver.

### 2. approval_0
We need add the first approver's address and private_key to program.json.
```bash
    "development": {
        "private_key": "APrivateKey1zkp4XPrUCPZLTxTac9kJE7hMYwDQS9xocthq77EkKtsv3sY",
        "address": "aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4"
    },
```
Run the command.

```bash
aleo run approval_0 "{owner: aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private, gates:0u64.private, first:aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,second: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private,steps: 2u64.private,money: 100u64.private,user:aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,status: 0u64.private,_nonce:3748039912422390871690277358410268566505423656152777624959979017988490974585group.public}" 0u64

➡️  Outputs

 • {
  owner: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  gates: 0u64.private,
  first: aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,
  second: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private,
  steps: 2u64.private,
  money: 100u64.private,
  user: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  status: 1u64.private,
  _nonce: 1405448036045437038147659712813702898433870215559354294283132352108474803802group.public
}
 • {
  owner: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private,
  gates: 0u64.private,
  first: aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,
  second: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private,
  steps: 2u64.private,
  money: 100u64.private,
  user: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  status: 1u64.private,
  _nonce: 1584777295271404390346712341524029639827353574055985376649200581200193402648group.public
}
```

The second record is owned by the second approver.

### 3. approval_1
We need add the second approver's address and private_key to program.json.
```bash
    "development": {
        "private_key": "APrivateKey1zkp2p4ieFsUJZ2EkudZEsxJTfw81T3qjdKjdbdWcJWKXapG",
        "address": "aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk"
    },
```
Run the command.

```bash
aleo run approval_1 "{owner: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private, gates: 0u64.private, first:aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,second:aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private, steps: 2u64.private, money: 100u64.private, user: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private, status: 1u64.private,  _nonce: 1584777295271404390346712341524029639827353574055985376649200581200193402648group.public}" 0u64

➡️  Output

 • {
  owner: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  gates: 0u64.private,
  first: aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,
  second: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private,
  steps: 2u64.private,
  money: 100u64.private,
  user: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  status: 2u64.private,
  _nonce: 6699479237227252669430081673879453325257640923053273909992409020631904897419group.public
}
```

Now the output record belongs to the user(recipient). The status is 2 (equals steps), which indicates the propose is approved.

### 4. get_money
We need modify address and private_key in program.json to the user's.
```bash
    "development": {
        "private_key": "APrivateKey1zkpB3DxLAYtTP2NZ3dZiebXaAJtt7ZSQQ6LMEhVyKy2ynVH",
        "address": "aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq"
    },
```
Run the command.

```bash
../aleo run get_money "{  owner: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private, gates: 0u64.private,first:aleo1hf0jutqqeqv2nhazntuted4z99ax873lgfaw623ytqc68z72cqqqa9xeg4.private,second: aleo1f72p3g82eur6x8ysd4u6hl8rmt8un6eelpzrdsvfkp663wf6uuzs2v8cfk.private,steps:2u64.private,money: 100u64.private,user:aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,status: 2u64.private,_nonce:6699479237227252669430081673879453325257640923053273909992409020631904897419group.public}"

➡️  Output

 • {
  owner: aleo1gy9h3a9sywc7p23acd5jjt9suuh663q0fv8uegpgr36je20xf5rsggnarq.private,
  gates: 0u64.private,
  amount: 100u64.private,
  custom1: 1234u64.private,
  _nonce: 4229060545916263684699917783761988423280936890985688009328015233539612670151group.public
}
```
At last, the user get a token valued 100.
