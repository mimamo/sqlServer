USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SelectADDocs]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SelectADDocs    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[SelectADDocs] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 smalldatetime As
Select * from APDoc Where
APDoc.OpenDoc = 1
and APDoc.Rlsed = 1
and APDoc.Selected = 0
and APDoc.CuryDocBal <> 0.00
and APDoc.Status = 'A'
and APDoc.VendId like @parm1
and APDoc.DocType = 'AD'
and APDoc.RefNbr Like @parm2
and APDoc.DueDate <= @parm3
Order By APDoc.VendId, APDoc.DocType, APDoc.RefNbr
GO
