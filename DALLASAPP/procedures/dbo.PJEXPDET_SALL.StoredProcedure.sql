USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEXPDET_SALL]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEXPDET_SALL]  @parm1 varchar (10) , @parm2beg smallint , @parm2end smallint   as
select * from PJEXPDET, PJEXPTYP
where    PJEXPDET.docnbr  =  @parm1 and
PJEXPDET.linenbr  between  @parm2beg and @parm2end  and
PJEXPDET.exp_type = PJEXPTYP.exp_type
order by PJEXPDET.docnbr, PJEXPDET.linenbr
GO
