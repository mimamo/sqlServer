USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[GLAutoBatchNbr]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLAutoBatchNbr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[GLAutoBatchNbr] as
    Select LastBatNbr from GLSetup order by SetupId
GO
