USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_all]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_all] as
select * from xaccsub
order by gridorder
GO
