USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRAutoBatchNbr]    Script Date: 12/21/2015 13:45:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRAutoBatchNbr] as
       Select LastBatNbr from PRSetup order by SetupId
GO
