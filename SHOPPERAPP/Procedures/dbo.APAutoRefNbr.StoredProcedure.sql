USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APAutoRefNbr]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APAutoRefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APAutoRefNbr] as
Select LastRefNbr from APSetup
GO
