USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_Sdoceq]    Script Date: 12/16/2015 15:55:29 ******/
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
