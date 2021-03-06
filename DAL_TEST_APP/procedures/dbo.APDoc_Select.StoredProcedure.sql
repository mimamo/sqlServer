USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Select]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Select    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[APDoc_Select] @parm1 varchar(10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 smalldatetime, @parm5 smalldatetime as
  Select * from apdoc
  Where cpnyid = @parm1 and acct = @parm2 and sub = @parm3
   and ((status = 'O' and DocDate <= @parm5)
   or (status = 'C' and (DocDate <= @parm5 and ClearDate > @parm5)
   or (docdate <= @parm4 and docdate > @parm5)))
   and rlsed = 1
  Order by cpnyid, acct, sub, doctype, refnbr
GO
