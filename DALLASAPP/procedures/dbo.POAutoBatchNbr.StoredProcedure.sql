USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POAutoBatchNbr]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAutoBatchNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[POAutoBatchNbr] as
    Select LastBatNbr from POSetup order by SetupId
GO
