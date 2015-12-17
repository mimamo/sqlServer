select * from gltran where PerPost = '201210'

select DrTot,CuryDrTot,CrTot,CuryCrTot,CtrlTot,CuryCtrlTot,Status,PerPost,* from Batch where Module='GL' and BatNbr='000028' 
select CrAmt,CuryCrAmt,DrAmt,CuryDrAmt,Posted,PerPost,* from GLTran where Module='GL' and BatNbr='000028'

update batch set ctrltot=1220, curyctrltot=1220, status='U' where batnbr='000027' and module='GL'


select SUM(dramt) as dramt, SUM(curydramt) as curydramt, SUM(cramt) as cramt, SUM(curycramt) as curycramt from GLTran where Module = 'GL' and BatNbr = '000001'


/*
select acct, sub, ytdbal11, BegBal, * from AcctHist where acct <= '3500'  and YtdBal11 <> 0 and FiscYr = '2011' 


select * from CuryAcct where FiscYr = '2012'

update CuryAcct 
set CuryYtdBal00 = 0, YtdBal00 = 0 
where FiscYr = '2012'


select acct, sub, ytdbal11, BegBal, * from AcctHist where Acct = '1041'

--- remove batch load that hasn't been posted
delete from Batch where Module='GL' and BatNbr = '000028' and PerPost = '201210'
delete from GLTran where Module='GL' and BatNbr = '000028' and PerPost = '201210'

*/