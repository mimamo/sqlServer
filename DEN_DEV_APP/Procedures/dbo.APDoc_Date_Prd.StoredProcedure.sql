USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Date_Prd]    Script Date: 12/21/2015 14:05:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Date_Prd    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[APDoc_Date_Prd] @parm1 varchar (10), @parm2 varchar (10), @parm3 varchar (24), @parm4 smalldatetime, @parm5 varchar (6) as
Select * from apdoc
Where cpnyid = @parm1
and acct = @parm2
and sub = @parm3
and (status = 'O' or status = 'C' or status = 'V' or DocType = 'VC')
and DocType <> 'SC'
and DocDate = @parm4
and PerPost = @parm5
and rlsed = 1
Order by acct, sub, doctype, refnbr
option (fast 100)
GO
