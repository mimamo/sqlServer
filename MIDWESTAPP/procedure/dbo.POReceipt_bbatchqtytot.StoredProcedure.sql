USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_bbatchqtytot]    Script Date: 12/21/2015 15:55:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POReceipt_bbatchqtytot    Script Date: 4/16/98 7:50:26 PM ******/
Create Procedure [dbo].[POReceipt_bbatchqtytot] @parm1 varchar ( 10) As
Select sum(rcptctrlqty) From POReceipt
   Where POReceipt.BatNbr = @parm1
GO
