USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRHeader_New]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_BRHeader_New]
@cpnyid char(10),
@parm1 char(10),
@parm2 char(6)
AS
Select *
from BRHeader
where CpnyID = @Cpnyid
and AcctID = @parm1
and ReconPerNbr = @parm2
order by AcctID, ReconPerNbr
GO
