USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcWhseLoc_all]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcWhseLoc_all] as
select * from xkcWhseLoc
order by gridorder
GO
