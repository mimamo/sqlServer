USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PFT_Check]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PFT_Check] as
IF exists (select * from dbo.sysobjects where id = object_id('dbo.XRPSETUP') and sysstat & 0xf = 3) 
	Select 1
ELSE
	Select 0
GO
