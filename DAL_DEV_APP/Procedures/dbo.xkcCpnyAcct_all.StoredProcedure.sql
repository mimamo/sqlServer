USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcCpnyAcct_all]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcCpnyAcct_all] as
select * from xkcCpnyAcct
order by gridorder
GO
