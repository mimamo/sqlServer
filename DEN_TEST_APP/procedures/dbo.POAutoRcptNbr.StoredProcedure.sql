USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAutoRcptNbr]    Script Date: 12/21/2015 15:37:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAutoRcptNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[POAutoRcptNbr] as
    Select LastRcptNbr from POSetup order by SetupId
GO
