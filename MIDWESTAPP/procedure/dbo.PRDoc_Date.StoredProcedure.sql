USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_Date]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PRDoc_Date    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[PRDoc_Date] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime as
  Select * from PRdoc
  Where cpnyid like @parm1 and acct like @parm2 and sub like @parm3
   and (status = 'O' or status = 'C' or status = 'V' or DocType = 'VC')
   and ChkDate = @parm4
  Order by cpnyid, acct, sub, chknbr, doctype
  option (fast 100)
GO
