USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcWhseLoc_all]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcWhseLoc_all] as
select * from xkcWhseLoc
order by gridorder
GO
