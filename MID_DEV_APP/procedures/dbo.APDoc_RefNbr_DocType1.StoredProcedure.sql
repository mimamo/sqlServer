USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_RefNbr_DocType1]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_RefNbr_DocType1    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_RefNbr_DocType1] @parm1 varchar ( 10) As
Select * from APDoc Where RefNbr = @parm1 and (DocType = 'VO' or
        DocType = 'AD' or DocType = 'AC' or DocType = 'PP') and Rlsed = 1
        and Selected = 1
Order By RefNbr, DocType
GO
