USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APSetup_All]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APSetup_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APSetup_All] as
Select * from APSetup
GO
