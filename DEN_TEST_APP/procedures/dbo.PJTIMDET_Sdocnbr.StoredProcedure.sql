USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_Sdocnbr]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMDET_Sdocnbr]  @parm1 varchar (10)   as
select *
from   PJTIMDET
where docnbr     =      @parm1
and tl_status <> 'P'
order by docnbr, linenbr
GO
