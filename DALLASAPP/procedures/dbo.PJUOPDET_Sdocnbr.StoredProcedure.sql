USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJUOPDET_Sdocnbr]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUOPDET_Sdocnbr]  @parm1 varchar (10)   as
select  *
from   PJUOPDET
where   docnbr     =      @parm1
order by  docnbr,  linenbr
GO
