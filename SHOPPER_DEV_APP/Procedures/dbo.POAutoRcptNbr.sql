USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAutoRcptNbr]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAutoRcptNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[POAutoRcptNbr] as
    Select LastRcptNbr from POSetup order by SetupId
GO
