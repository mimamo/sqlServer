USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAPSPutUnallocatedBatchesIntoPJTRANWK]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kelly Johnson
-- Create date: Aug 28, 2007
-- Description:	This stored procedure will allocate APS batch's.
--				APS batch's are allocated when their data is taken from pjtran and placed
--				into PJTRANWK.  The stored procedure is going to look in pjtran
--				for batch_id's it has not allocated before, it will then allocate them
--				then it will update xAPSAllocatedBatchID with the allocated batch_id's
--				xAPSAllocatedBatchID holds previously allocated batch_id's to use as a check
--				so we do not allocate those batches again.
--
--	Modified:
--				Sept 4 2007 - Kelly Johnson 
--					- Changed it so that on the first, the script first runs
--					- by setting the day back one in its checks.  This will
--					- ensure that all batches are grabbed on the date change.
--				Sept 17 2007 - Kelly Johnson
--					- changed the DB to the live DB and added cc and bcc fields to email
--				April 17 2008 - Kelly Johnson
--					- changed query to not query by fiscalno, rather to get all pjtran records created 
--					- after this stored procedure was put into use
-- =============================================
CREATE PROCEDURE [dbo].[xAPSPutUnallocatedBatchesIntoPJTRANWK] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON; 

    -- Insert unallocated APS time records into PJTRANWK 
--CyGen
--4/17/2008
--KJ
-- we are using "and t.crtd_datetime >= '9/17/2007'" in the query to get any batches
-- that were submitted after this stored procedure was put into service

    Insert into PJTRANWK 
(acct,alloc_flag,amount,BaseCuryId,batch_id,batch_type,bill_batch_id,CpnyId,crtd_datetime,crtd_prog, 
crtd_user,CuryEffDate,CuryId,CuryMultDiv,CuryRate,CuryRateType,CuryTranamt,data1,detail_num, 
employee,fiscalno,gl_acct,gl_subacct,lupd_datetime,lupd_prog,lupd_user,noteid,pjt_entity,post_date, 
project,Subcontract, system_cd,trans_date,tr_comment,tr_id01,tr_id02,tr_id03,tr_id04,tr_id05,tr_id06,tr_id07, 
tr_id08,tr_id09,tr_id10,tr_id23,tr_id24,tr_id25,tr_id26,tr_id27,tr_id28,tr_id29,tr_id30,tr_id31,tr_id32, 
tr_status,unit_of_measure,units,user1,user2,user3,user4,vendor_num,voucher_line,voucher_num,alloc_batch) 
    Select acct,'A',amount,BaseCuryId,batch_id,batch_type,bill_batch_id,CpnyId,crtd_datetime,crtd_prog, 
crtd_user,CuryEffDate,CuryId,CuryMultDiv,CuryRate,CuryRateType,CuryTranamt,data1,detail_num, 
employee,fiscalno,gl_acct,gl_subacct,lupd_datetime,lupd_prog,lupd_user,noteid,pjt_entity,post_date, 
project,Subcontract,system_cd,trans_date,tr_comment,tr_id01,tr_id02,tr_id03,tr_id04,tr_id05,tr_id06,tr_id07, 
tr_id08,tr_id09,tr_id10,tr_id23,tr_id24,tr_id25,tr_id26,tr_id27,tr_id28,tr_id29,tr_id30,tr_id31,tr_id32, 
tr_status,unit_of_measure,units,user1,user2,user3,user4,vendor_num,voucher_line,voucher_num,space(16) 
    from pjtran t 
    where  
t.project like '%APS'  
and t.acct = 'labor' 
and t.crtd_prog = 'ADDLAB' 
and t.crtd_prog = t.lupd_prog 
and t.crtd_datetime >= '9/17/2007'
AND (NOT EXISTS (SELECT batch_id FROM xAPSAllocatedBatchID nt where t.batch_ID = nt.batch_ID)) 

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-- Insert the updated batch_id's into our tracking table "xAPSAllocatedBatchID"
     Insert into xAPSAllocatedBatchID
(batch_id)
     Select DISTINCT batch_id
     From pjtran t
     Where
t.project like '%APS'  
and t.acct = 'labor' 
and t.crtd_prog = 'ADDLAB' 
and t.crtd_prog = t.lupd_prog 
and t.crtd_datetime >= '9/17/2007'
AND (NOT EXISTS (SELECT batch_id FROM xAPSAllocatedBatchID nt where t.batch_ID = nt.batch_ID)) 
-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-- Send email about job

Declare @batch_ids varchar(1500)
set @batch_ids=''
SELECT @batch_ids = @batch_ids + batch_ID + CHAR(13) + CHAR(10) FROM xAPSAllocatedBatchID  
          WHERE DATEDIFF(dd, crtd_datetime, getdate()) =0  

--build the body of the email
Declare @strBody varchar(1600)
set @strBody = 'The following APS time batches have been submitted for allocation: ' + CHAR(13) + CHAR(10) + @batch_ids + CHAR(13) + CHAR(10) + ' Thank you' + CHAR(13) + CHAR(10)
   
EXEC msdb.dbo.sp_send_dbmail  
     @profile_name = 'Database Mail',  
     @recipients = 'denversqlserveroperators@integer.com', 
	 @copy_recipients = 'mbrady@integer.com',
	 @blind_copy_recipients = '',
	 @body = @strBody,
     @subject = 'Allocate APS Time';
-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
END
GO
