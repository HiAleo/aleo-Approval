# approval.aleo

## An approval process Aleo program based on Record for delivery and distribution

It is divided into four steps

1. propose(first, second, steps, money_amount, money_receiver) is called by the initiator to specify a "first and second" approver, the number of approvers, the content of the approval description text, and the coin_a amount to apply, payee and other information. If successful, an approval record will be created and sent to the first approver and payee.
2. approval_0(record, option) is called by the first approver, who checks the proposal.record received in step 1, call approval_0 according to the status information is 0, parameter option=0 means agree, and other values mean reject. If agree, update the record.tatus and build a new proposal record to send to the second approver and the payee who mainly checks the progress according to the record.
3. approval_1 (record, option) is called by the second approver, who checks the proposal.record received in step 2, call approval_1 according to the status information is 1, parameter option=0 means agree, and other values mean reject, If agree, the record.status will be updated and  build a new proposal record to send to the payee, who can use the following steps to get money(coin_a).
4. get_money (record) is called by the payee, who passes the received proposal in step 3 Record to collect money in minutes. If record.status != record.steps means that if the approval is rejected or not completed, it cannot succeed. Otherwise, the record.money_receiver can receive coin_a of the specified amount in the record.money field

### Remark：
Due to the limitation of "MAX_OPERANDS=8", the number of fields in a record cannot exceed 6 (the other two are occupied by owners and gates), so there is no way to create more complex approval records and more approvers. It is expected that Aleo snorkVM will be further empty

## --- ---

## 一个基于Record进行传递分发的审批流Aleo程序

分为四个步骤

  1. propose 由发起人调用，指定一个审批的『第一，第二』审批人，审批人数，审批描述文本内容，申请coin_a款项额度，收款人等信息，成功则创建一个审批Record记录，并发送给第一审批人和收款人。
  2. approval_0(record, option) 由第一审批人调用，他查看在第一步中接收到的 proposal.record ，根据其中的 status 信息为 0，调用approval_0接口进行审批, option=0表示同意，其他数值表示拒绝，如果同意则更新 record.status 构建一个新的 proposal.record 发送给第二审批人和收款人，收款人主要是根据 record 查看进度。
  3. approval_1(record, option) 由第二审批人调用，他查看在第二步中接收到的 proposal.record, 根据其中的 status 信息为 1， 调用approval_1接口进行审批，option=0表示同意，其他数值表示拒绝，如果同意则更新 record.status 构建一个新的 proposal.record 发送给收款人，收款人可以利用下面的步骤来收款了。
  4. get_money(record) 由收款人调用，他传递第三步中的收到的 proposal.record 进行mint收款，如果record.status != record.steps则表示该审批被否决或者尚未结束，则无法成功，否则就可以接收到 record.money 字段指定额度的 coin_a
  
### 注:
   由于受到 『MAX_OPERANDS = 8』的限制，一个record中的字段数量无法超过6（另两个被owner和gates占据），所以没有办法建立更复杂的审批Record和更多的审批人数，期望Aleo snarkVM后继能够进一步提升空间。

## Build Guide
