USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkccpnyAcctSub_grid]    Script Date: 12/21/2015 14:18:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkccpnyAcctSub_grid] @xfromacct varchar(10) , @xfromsub varchar(24), @gridorderbeg smallint, @gridorderend smallint as
select * from xkccpnyAcctSub
where xfromacct like @xfromacct
and xfromsub like @xfromsub
and gridorder between @gridorderbeg and @gridorderend
order by xfromacct, xfromsub, gridorder
GO
