USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcCpnySub_all]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcCpnySub_all] as
select * from xkcCpnySub
order by gridorder
GO
