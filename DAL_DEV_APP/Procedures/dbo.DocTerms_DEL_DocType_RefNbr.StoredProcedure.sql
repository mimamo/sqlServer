USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DocTerms_DEL_DocType_RefNbr]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DocTerms_DEL_DocType_RefNbr    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[DocTerms_DEL_DocType_RefNbr] @parm1 varchar ( 2), @parm2 varchar( 10) As
     Delete from DocTerms
         Where DocType = @parm1
           and RefNbr  = @parm2
GO
