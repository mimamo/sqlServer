USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYDET_ssumamt]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYDET_ssumamt]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (4), @parm4 varchar (4)   as
select sum(curr_total_amt) from PJPAYDET
where
PJPAYDET.project       =    @parm1 and
PJPAYDET.subcontract   =    @parm2 and
	PJPAYDET.sub_line_item = @parm3 and
pjpaydet.payreqnbr <> @parm4
GO
