USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARSetup_All]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARSetup_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[ARSetup_All] as
    Select * from ARSetup
GO
