USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SelectTempAPCheckDoc1]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SelectTempAPCheckDoc1    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[SelectTempAPCheckDoc1] @parm1 varchar ( 15), @parm2 varchar ( 15) As
Select * From APCheck
Where VendId = @parm1 and
CheckRefNbr = @parm2 and
Status = 'T'
GO
