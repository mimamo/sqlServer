USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAutoBatchNbr]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAutoBatchNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[POAutoBatchNbr] as
    Select LastBatNbr from POSetup order by SetupId
GO
