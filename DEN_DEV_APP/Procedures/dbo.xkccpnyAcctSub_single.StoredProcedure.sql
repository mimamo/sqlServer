USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkccpnyAcctSub_single]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkccpnyAcctSub_single]  as
select * from xkccpnyAcctSub
where global <>1
order by xfromacct, xfromsub, gridorder
GO
