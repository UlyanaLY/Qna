 every 1.days, at: '19:15 p.m.' do
   runner "DigestDispatchJob.create"
 end

 every 60.minutes do
   rake "ts:index"
 end

