USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_VendId]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_VendId    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APDoc_VendId] @parm1 varchar ( 15) As
Select * from APDoc where VendId = @parm1
Order by VendID, RefNbr
GO
