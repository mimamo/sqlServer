USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_Cleared]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PRDoc_Cleared    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[PRDoc_Cleared] @parm1 varchar ( 6) as
  Select * from prdoc
  Where  perent > @parm1
   and  status = 'C'
   Order by CpnyId, acct, sub, chknbr, doctype
GO
