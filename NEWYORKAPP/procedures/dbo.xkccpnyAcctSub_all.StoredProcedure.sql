USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkccpnyAcctSub_all]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkccpnyAcctSub_all] as
select * from xkccpnyAcctSub
order by  gridorder
GO
