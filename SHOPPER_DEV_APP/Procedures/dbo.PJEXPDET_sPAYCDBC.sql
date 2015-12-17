USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_sPAYCDBC]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_sPAYCDBC]  @parm1 varchar (4) , @parm2 smalldatetime , @parm3 smalldatetime , @parm4 varchar (10) as
select *
	from PJEXPDET
		left outer join PJEXPTYP
			on PJEXPDET.exp_type = PJEXPTYP.exp_type
		, PJEXPHDR left outer join PJEMPLOY
			on PJEXPHDR.employee = PJEMPLOY.employee
	where PJEXPDET.docnbr = PJEXPHDR.docnbr
		and PJEXPHDR.status_1 = 'P'
		and PJEXPDET.payment_cd = @parm1
		and (PJEXPDET.exp_date >= @parm2 and PJEXPDET.exp_date <= @parm3)
		and PJEXPHDR.employee like @parm4
		and PJEXPDET.amt_company <> 0
	order by PJEXPDET.exp_date
GO
