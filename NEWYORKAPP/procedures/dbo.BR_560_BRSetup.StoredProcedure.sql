USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_560_BRSetup]    Script Date: 12/21/2015 16:00:50 ******/
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
