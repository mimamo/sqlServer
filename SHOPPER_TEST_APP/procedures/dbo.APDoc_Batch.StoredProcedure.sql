USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Batch]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Batch    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_Batch] @parm1 varchar ( 10) as
Select * from APDoc Where
APDoc.BatNbr = @parm1 and
APDoc.Rlsed = 0
Order by APDoc.BatNbr, APDoc.RefNbr
GO
