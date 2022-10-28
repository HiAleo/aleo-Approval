import coin_a.aleo;

program approval.aleo;
record proposal:
  owner as address.private;
  gates as u64.private;
  
  first as address.private;
  second as address.private;
  steps as u64.private;           // Total steps in the procedure. But this field is reserved to keep generic. In our demo, only 2 steps is required. 
  money as u64.private;           
  user as address.private;        // Recipient of money
  status as u64.private;          // How many approvers accept

function propose:
  input r0 as address.private;    // first approver 
  input r1 as address.private;    // second approver
  input r2 as u64.private;        // number of approvers
  input r3 as u64.private;        // amount of money 
  input r4 as address.private;    // recipient of money 
  
  // assert r2 in [1, 4]
  is.eq r2 1u64 into r5;
  is.eq r2 2u64 into r6;
  is.eq r2 3u64 into r7;
  is.eq r2 4u64 into r8;
  
  or r5 r6 into r9;
  or r9 r7 into r10;
  or r10 r8 into r11;
  
  assert.eq r11 true;
  
  // This record belongs to the first approver
  cast r0 0u64 r0 r1 r2 r3 r4 0u64 into r12 as proposal.record;

  // This record belongs to the recipient
  cast r4 0u64 r0 r1 r2 r3 r4 0u64 into r13 as proposal.record;

  output r12 as proposal.record;
  output r13 as proposal.record;
  
// This function is called by the first approver
function approval_0:
  input r0 as proposal.record;
  input r1 as u64.private;             // 0-accept, others-reject

  // self.caller must be the first approver
  assert.eq self.caller r0.first;

  // current status must be 0
  assert.eq r0.status 0u64;
  
  // We denote reject status as 10 here.
  is.eq r1 0u64 into r2;
  ternary r2 1u64 10u64 into r3;
  
  cast r0.user 0u64 r0.first r0.second r0.steps r0.money r0.user r3 into r4 as proposal.record;
  cast r0.second 0u64 r0.first r0.second r0.steps r0.money r0.user r3 into r5 as proposal.record;
  output r4 as proposal.record;
  output r5 as proposal.record;

// This funtion is called by the second approver
function approval_1:
  input r0 as proposal.record;
  input r1 as u64.private;            // 0-accept, others-reject

  // self.caller must be the second approver
  assert.eq self.caller r0.second;

  // current status must be 1, which denotes 1 approver has approved.
  assert.eq r0.status 1u64;
  
  // We denote reject status as 10 here.
  is.eq r1 0u64 into r2;
  ternary r2 2u64 10u64 into r3;
  
  cast r0.user 0u64 r0.first r0.second r0.steps r0.money r0.user r3 into r4 as proposal.record;
  output r4 as proposal.record;

// The recipient can get money by the proposal.record. 
function get_money:
  input r0 as proposal.record;

  // self.caller must be user of the proposal.record.
  assert.eq self.caller r0.user;
  // the status must be the proposal.record.steps, which indicates all approved
  assert.eq r0.status r0.steps;
    
  // We assume the asset is coin_a here.
  call coin_a.aleo/mint r0.user r0.money into r1;
  output r1 as coin_a.aleo/coin_a.record;
