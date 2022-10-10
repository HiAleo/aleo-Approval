import coin_a.aleo;

program approval.aleo;
record proposal:
  owner as address.private;
  gates as u64.private;
  
  first as address.private;
  second as address.private;
  steps as u64.private;           // 审批流的步骤总数（<=4),对应上述四位
  money as u64.private;           // 审批完成的批款
  user as address.private;        // 审批完成后的打款对象
  status as u64.private;          // 审批当前的状态：0进行中，1成功，2失败

function propose:
  input r0 as address.private;    // 第一顺位审批人
  input r1 as address.private;    // 第二顺位审批人
  input r2 as u64.private;        // 审批人个数（<=4)
  input r3 as u64.private;        // 审批金额
  input r4 as address.private;    // 审批流程走完的放款接收人
  
  // 确保 r4是在1~4范围中
  is.eq r2 1u64 into r5;
  is.eq r2 2u64 into r6;
  is.eq r2 3u64 into r7;
  is.eq r2 4u64 into r8;
  
  or r5 r6 into r9;
  or r9 r7 into r10;
  or r10 r8 into r11;
  
  assert.eq r11 true;
  
  // 首先cast给第一顺位审批人
  cast r0 0u64 r0 r1 r2 r3 r4 0u64 into r12 as proposal.record;
  // 也给最后的收款人发放一个记录进行告知
  cast r4 0u64 r0 r1 r2 r3 r4 0u64 into r13 as proposal.record;
  output r12 as proposal.record;
  output r13 as proposal.record;
  
// 由第一顺位审批人调用
function approval_0:
  input r0 as proposal.record;
  input r1 as u64.private;

  // approval_0只能由第一个审批者调用
  assert.eq self.caller r0.first;
  // 确保当前进度为0
  assert.eq r0.status 0u64;
  
  // 比较审批人是否同意，同意则设置状态为0,否则为10，表示终止  
  is.eq r1 0u64 into r2;
  ternary r2 1u64 10u64 into r3;
  
  cast r0.user 0u64 r0.first r0.second r0.steps r0.money r0.user r3 into r4 as proposal.record;
  cast r0.second 0u64 r0.first r0.second r0.steps r0.money r0.user r3 into r5 as proposal.record;
  output r4 as proposal.record;
  output r5 as proposal.record;      

// 由第二顺位审批人调用
function approval_1:
  input r0 as proposal.record;
  input r1 as u64.private;

  // approval_1只能由第二个审批者调用
  assert.eq self.caller r0.second;
  // 确保当前进度为1
  assert.eq r0.status 1u64;
  
  // 比较审批人是否同意，同意则设置状态为2,否则为10，表示终止  
  is.eq r1 0u64 into r2;
  ternary r2 2u64 10u64 into r3;
  
  cast r0.user 0u64 r0.first r0.second r0.steps r0.money r0.user r3 into r4 as proposal.record;
  //cast r0.third 0u64 r0.first r0.second r0.steps r0.money r0.user r3 into r4 as proposal.record;
  output r4 as proposal.record;
  //output r4 as proposal.record;      

// 最终的取款人能够凭借『状态为steps的审批单』去申请coin_a的审批额度
function get_money:
  input r0 as proposal.record;

  // get_money只能由审批中的目标用户调用
  assert.eq self.caller r0.user;
  // 必须是状态为steps，表示全体审批通过
  assert.eq r0.status r0.steps;
    
  // 放款
  call coin_a.aleo/mint r0.user r0.money into r1;
  output r1 as coin_a.aleo/coin_a.record;

