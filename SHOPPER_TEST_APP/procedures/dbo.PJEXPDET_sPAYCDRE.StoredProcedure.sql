USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_sPAYCDRE]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_sPAYCDRE]  @parm1 varchar (4) , @parm2 smalldatetime , @parm3 smalldatetime , @parm4 varchar (10) , @parm5 varchar (16) as
select *
	from PJEXPDET
		left outer join PJEXPTYP
			on PJEXPDET.exp_type = PJEXPTYP.exp_type
		, PJEXPHDR
		left outer join PJEMPLOY
			on PJEXPHDR.employee = PJEMPLOY.employee
	where PJEXPDET.docnbr  = PJEXPHDR.docnbr
		and PJEXPHDR.status_1 = 'P'
		and PJEXPDET.payment_cd = @parm1
		and (PJEXPDET.exp_date >= @parm2 and PJEXPDET.exp_date <= @parm3)
		and PJEXPHDR.employee like @parm4
		and (PJEXPDET.td_id03 like @parm5 and PJEXPDET.td_id03 <> ' ')
		and PJEXPDET.amt_employ <> 0
	order by PJEXPDET.exp_date
GO
