USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_VendId_DocClass]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_VendId_DocClass    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APDoc_VendId_DocClass] @parm1 varchar ( 15), @parm2 varchar ( 10) As
Select * from APDoc where VendId = @parm1
and RefNbr like @parm2
and DocClass = 'N'
and OpenDoc = 1
and Rlsed = 1
and Selected = 0
Order by VendId, RefNbr
GO
