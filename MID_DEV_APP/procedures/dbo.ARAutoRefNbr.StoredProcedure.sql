USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARAutoRefNbr]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARAutoRefNbr    Script Date: 4/7/98 12:30:32 PM ******/
Create Proc [dbo].[ARAutoRefNbr] as
    Select LastRefNbr from ARSetup order by SetupId
GO
