USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APAutoRefNbr]    Script Date: 12/21/2015 14:05:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APAutoRefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APAutoRefNbr] as
Select LastRefNbr from APSetup
GO
