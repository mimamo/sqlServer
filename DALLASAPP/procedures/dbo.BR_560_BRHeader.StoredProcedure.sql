USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_560_BRHeader]    Script Date: 12/21/2015 13:44:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_560_BRHeader]
@parm1 char(10),
@parm2 char(10),
@parm3 char(6)
AS
Select *
from BRHeader
where AcctID = @parm1 and
cpnyID = @parm2
and ReconPerNbr = @parm3
order by AcctID, cpnyid, ReconPerNbr
GO
