USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_Sgrid]    Script Date: 12/21/2015 14:17:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMDET_Sgrid]  @parm1 varchar (10) , @parm2beg smallint , @parm2end smallint   as
select *
from   PJTIMDET
where (docnbr     =      @parm1 and
linenbr  between  @parm2beg and @parm2end)
order by PJTIMDET.docnbr, PJTIMDET.linenbr
GO
