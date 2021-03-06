USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Insert_PJInvDet]    Script Date: 12/21/2015 16:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xWRKMG_Insert_PJInvDet] 

	@APSAGYCOS varchar(100),
	@APSAGYBILL varchar(100),
	@BATNBR varchar(100),
	@SYSTEMCD varchar(100),
	@PERPOST varchar(100),
	@ERRORNBR int OUTPUT,
  @ERRORMSG varchar(100) OUTPUT
	
AS

SET NOCOUNT ON

BEGIN TRY 
 BEGIN TRANSACTION 


INSERT INTO PJInvDet (
			acct,
			acct_rev,
			adj_amount,
			adj_units,
			amount,
			bill_status,
			burdened_amt,
			comment,
			cost_amt,
			CpnyId,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			CuryAdj_amount,
			CuryHold_amount,
			CuryId,
			CuryMultDiv,
			CuryOrig_amount,
			CuryRate,
			CuryTranamt,
			data1,
			data2,
			data3,
			draft_num,
			employee,
			entry_type,
			equip_id,
			fee_rate,
			fiscalno,
			gl_acct,
			gl_offset_acct,
			gl_offset_cpnyid,
			gl_offset_subacct,
			gl_subacct,
			hold_status,
			hold_amount,
			hold_units,
			in_id01,
			in_id02,
			in_id03,
			in_id04,
			in_id05,
			in_id06,
			in_id07,
			in_id08,
			in_id09,
			in_id10,
			in_id11,
			in_id12,
			in_id13,
			in_id14,
			in_id15,
			in_id16,
			in_id17,
			in_id18,
			in_id19,
			in_id20,
			in_id21,
			in_id22,
			in_id23,
			labor_class_cd,
			li_type,
			linenbr,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			noteid,
			offset_cd,
			orig_amount,
			orig_rate,
			orig_units,
			pjt_entity,
			post_to_cd,
			project,
			project_billwith,
			rate_type_cd,
			source_trx_date,
			Subcontract,
			taxcatid,
			taxId,
			taxitembasis,
			unit_of_measure,
			units,
			user1,
			user2,
			user3,
			user4,
			vendor_num)
			
	SELECT 
		acct = @APSAGYCOS,
		acctrev = @APSAGYBILL,
		adj_amt = 0.0,
		adj_units = 0.0,
		amount = t.amount,
		billStatus = 'U',
		burdened_amt	=	0.00,
		comment = t.tr_comment,                                                                                                                                                                                                                                     
   	cost_amt = t.amount,
		CpnyId		=	'DALLAS',    
		crtd_datetime	=	t.crtd_datetime,
		crtd_prog	=	t.crtd_prog,   
		crtd_user	=	t.crtd_user,  
		cury_adj_amt = 0.0,
		CuryHold_amount	=	0.00,
		CuryId		=	'USD', 
		CuryMultDiv	=	'M',
		curyorig_amt = t.amount,
		CuryRate	=	1.00,
		cury_tranamount = t.amount,
		data1		=	' ',	          
		data2		=	' ',	                        
		data3		=	' ',	
		draft_num	=	space(10),	          
		employee	=	' ',	          
		entry_type	=	' ',	 
		equip_id    =   ' ',
		fee_rate	=	0.00,  
		fiscalno		=	t.fiscalno,	          
		gl_acct		=	' ',	          
		gl_offset_cpnyid = 'DALLAS',
		gl_offset_acct	=	' ',	          
		gl_offset_subacct	=	' ',	                        
		gl_subacct = ' ',
		hold_status	=	'A',
		hold_amount	=	0.00,
		hold_units	=	0.00,
		in_id01		=	' ',	                              
		in_id02		=	' ',	                              
		in_id03		=	' ',	                
		in_id04		=	' ',	                
		in_id05		=	' ',    
		in_id06		=	0,
		in_id07		=	0,
		in_id08		=	0,
		in_id09		=	0,
		in_id10		=	0,
		' '  as in_id11,	
		in_id12		=	(t.fiscalno + t.system_cd + t.batch_id + dbo.xFncIncrChar (str(t.detail_num),0,10)),	                              
		in_id13		=	' ',	                              
		in_id14		=	' ',	                    
		in_id15		=	' ',	               
		in_id16		=	' ',	          
		in_id17		=	' ',	          
		in_id18		=	' ',	    
		in_id19		=	0,
		in_id20		=	0,
		in_id21		=	t.amount,
		in_id22		=	0.00,		
		in_id23		=	t.amount,	
		labor_class_cd	=	' ',	    
		li_type		=	'I',
		linenbr		=	0,
		lupd_datetime	=	t.lupd_datetime,
		lupd_prog	=	t.lupd_prog,   
		lupd_user	=	t.lupd_user,  
		noteid		=	0,
		offset_cd	=	' ',	    
		orig_amt	= t.amount,
		orig_rate	=	0.00,
		orig_units	=	0.00,
		pjt_entity	=	t.pjt_entity,
		post_to_cd	=	' ',	    
		project		=	t.project,
		project_billwith	=	 b.project_billwith, 
		rate_type_cd	=	' ',  
		source_trx_date = t.trans_Date,
		Subcontract = ' ',
		taxcatid	=	' ',	          
		taxId		=	' ',	          
		taxitembasis	=	0,
		unit_of_measure = ' ',
		units		=	0.00,
		user1		=	' ',                              
		user2		=	' ',	                              
		user3		=	0,
		user4		=	0,
		vendor_num	=	' '	 
	FROM
		pjtran as t JOIN PJBILL b ON t.project = b.project 
	WHERE 
		t.acct = @APSAGYBILL and
		t.batch_id = @BATNBR and
		t.system_cd = @SYSTEMCD and
		t.fiscalNo = @PERPOST
		
	COMMIT TRANSACTION 
	
SET @ERRORNBR = 0
SET @ERRORMSG = 'No Error'

END TRY 

BEGIN CATCH 
  IF (XACT_STATE())=-1 ROLLBACK TRANSACTION 
  SET @ERRORNBR = -1
  SET @ERRORMSG = 'ROLLBACK'
END CATCH 

SELECT @ERRORNBR, @ERRORMSG
GO
