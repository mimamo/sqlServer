USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_RefNbr]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 2) As
Select * from APDoc Where RefNbr = @parm1 and DocType = @parm2
GO
