USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[POAutoOrderNbr]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAutoOrderNbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Proc [dbo].[POAutoOrderNbr] as
    Select LastPONbr from POSetup order by SetupId
GO
