USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAutoBatchNbr]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAutoBatchNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[POAutoBatchNbr] as
    Select LastBatNbr from POSetup order by SetupId
GO
