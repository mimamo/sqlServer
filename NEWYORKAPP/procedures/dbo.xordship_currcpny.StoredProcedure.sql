USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xordship_currcpny]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xordship_currcpny] @cpnyid varchar(10),@DatabaseName varchar(30) as
select count(*) from VS_company where
cpnyid = @cpnyid
and databasename = @databasename
GO
