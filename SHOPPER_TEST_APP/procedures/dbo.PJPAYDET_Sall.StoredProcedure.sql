USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYDET_Sall]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYDET_Sall]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (4) , @parm4 varchar (4)   as
select * from PJPAYDET
where
PJPAYDET.project       =    @parm1 and
PJPAYDET.subcontract   =    @parm2 and
	PJPAYDET.payreqnbr = @parm3 and
	PJPAYDET.sub_line_item like @parm4
order by PJPAYDET.project, PJPAYDET.subcontract, PJPAYDET.payreqnbr, PJPAYDET.sub_line_item
GO
