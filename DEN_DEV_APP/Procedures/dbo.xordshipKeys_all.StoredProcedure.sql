USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xordshipKeys_all]    Script Date: 12/21/2015 14:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xordshipKeys_all] @type varchar(1) as
select * from xordshipkeys where
type = @type
order by type, updseq
GO
