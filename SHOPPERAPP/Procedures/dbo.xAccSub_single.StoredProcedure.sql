USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_single]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_single]  as
select * from xAccSub
where global <>1
order by xfromacct, xfromsub, gridorder
GO
