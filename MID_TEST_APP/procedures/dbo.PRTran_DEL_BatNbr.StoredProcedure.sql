USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_DEL_BatNbr]    Script Date: 12/21/2015 15:49:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_DEL_BatNbr] @parm1 varchar ( 10) as
       Delete prtran from PRTran
           where PRTran.BatNbr  =  @parm1
GO
