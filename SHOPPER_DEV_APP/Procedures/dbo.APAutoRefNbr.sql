USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APAutoRefNbr]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APAutoRefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APAutoRefNbr] as
Select LastRefNbr from APSetup
GO
