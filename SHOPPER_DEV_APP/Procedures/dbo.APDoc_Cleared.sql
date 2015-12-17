USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_Cleared]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_Cleared    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[APDoc_Cleared] @parm1 varchar ( 6) as
  Select * from apdoc
  Where  perent > @parm1
   and  status = 'C'
   Order by cpnyid, acct, sub, doctype, refnbr
GO
