USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CAAutoBatchNbr]    Script Date: 12/21/2015 16:06:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CAAutoBatchNbr    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[CAAutoBatchNbr] as
Select LastBatNbr from CASetup order by SetupId
GO
