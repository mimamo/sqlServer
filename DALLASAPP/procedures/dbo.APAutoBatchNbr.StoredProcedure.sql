USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[APAutoBatchNbr]    Script Date: 12/21/2015 13:44:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APAutoBatchNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APAutoBatchNbr] as
Select LastBatNbr from APSetup
GO
