USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_Sdoceq]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMDET_Sdoceq]  @parm1 varchar (10)   as
select *
from   PJTIMDET
where docnbr     =      @parm1
and equip_id <> ' '
order by docnbr, linenbr
GO
