USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_Recurring_Chk]    Script Date: 12/21/2015 16:13:04 ******/
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
