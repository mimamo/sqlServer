USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[KeepAPCheckTran]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.KeepAPCheckTran    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[KeepAPCheckTran] @parm1 varchar ( 10), @parm2 varchar ( 15) As
Select * From APCheckDet Where
BatNbr = @parm1 and
CheckRefNbr = @parm2
Order By RefNbr, DocType
GO
