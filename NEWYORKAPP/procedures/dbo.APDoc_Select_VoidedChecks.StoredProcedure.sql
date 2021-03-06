USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Select_VoidedChecks]    Script Date: 12/21/2015 16:00:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Select_VoidedChecks    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[APDoc_Select_VoidedChecks] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 smalldatetime as
Select * from apdoc
Where cpnyid = @parm1
and acct = @parm2
and sub = @parm3
and status = 'V'
and DocType <> 'VC'
and refnbr = @parm4
and DocDate <= @parm5
and rlsed = 1
Order by refnbr, Docdate
GO
