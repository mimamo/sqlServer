USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_DocType_RefNbr]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_DocType_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_DocType_RefNbr] @parm1 varchar ( 2), @parm2 varchar ( 10) as
Select * from APDoc where DocType = @parm1
and RefNbr like @parm2
Order by DocType, RefNbr
GO
