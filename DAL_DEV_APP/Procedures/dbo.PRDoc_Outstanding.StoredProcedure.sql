USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_Outstanding]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PRDoc_Outstanding    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[PRDoc_Outstanding] @parm1 varchar(10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 smalldatetime as
  Select * from prdoc
  Where cpnyID like @parm1 and acct like @parm2 and sub like @parm3
   and (status = 'O'  and
  chkDate <= @parm4) or
  (chkdate <= @parm4  and cleardate > @parm4)
  Order by CpnyID, Acct, sub, chknbr, doctype
GO
