USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BR_560_BRSetup]    Script Date: 12/21/2015 15:42:44 ******/
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
