USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_single]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_single]  as
select * from xAccSub
where global <>1
order by xfromacct, xfromsub, gridorder
GO
