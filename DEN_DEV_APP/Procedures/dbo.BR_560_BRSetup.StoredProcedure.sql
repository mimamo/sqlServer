USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BR_560_BRSetup]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BR_560_BRSetup]
AS
Select *
from BRSetup
order by SetupID
GO
