USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_sDocNbr]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_sDocNbr]  @parm1 varchar (10) , @parm2beg smallint , @parm2end smallint   as
select * from PJEXPDET , PJEXPTYP
where    PJEXPDET.docnbr  =  @parm1 and
PJEXPDET.linenbr  between  @parm2beg and @parm2end  and
PJEXPDET.exp_type = PJEXPTYP.exp_type
order by PJEXPDET.docnbr, PJEXPDET.linenbr
GO
