USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcTask_all]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcTask_all] as
select * from xkcTask
order by gridorder
GO
