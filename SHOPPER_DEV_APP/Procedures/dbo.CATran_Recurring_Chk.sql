USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_Recurring_Chk]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_Recurring_Chk    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[CATran_Recurring_Chk] @parm1 varchar ( 10) as
select * from CATran
where Recurid <> ''
and PerPost = ''
and Module = ''
and Refnbr = @parm1
and Rlsed = 0
GO
