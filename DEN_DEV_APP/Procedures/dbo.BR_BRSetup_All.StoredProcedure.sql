USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_BRSetup_All]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_BRSetup_All] @parm1 varchar (10)
AS
Select *
from BRSetup where CpnyID like @parm1
 order by CpnyId
GO
