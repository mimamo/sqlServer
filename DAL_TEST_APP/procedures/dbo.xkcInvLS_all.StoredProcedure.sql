USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcInvLS_all]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcInvLS_all]  as
select * from xkcInvLS
order by gridorder
GO
