USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INSetup_All_NoLock]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INSetup_All_NoLock    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INSetup_All_NoLock    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INSetup_All_NoLock] as
    Select * from INSetup(NoLock) order by SetupId
GO
