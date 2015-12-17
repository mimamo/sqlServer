USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DocTerms_DocType_RefNbr]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DocTerms_DocType_RefNbr    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc  [dbo].[DocTerms_DocType_RefNbr]
@parm1 varchar ( 2), @parm2 varchar ( 10), @parm3beg smallint, @parm3end smallint as
       Select * from DocTerms
           where DocType = @parm1
             and RefNbr  = @parm2
             and LineNbr BETWEEN @parm3beg and @parm3end
           order by LineNbr
GO
