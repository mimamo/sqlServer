USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APSetup_All]    Script Date: 12/21/2015 14:34:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APSetup_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APSetup_All] as
Select * from APSetup
GO
