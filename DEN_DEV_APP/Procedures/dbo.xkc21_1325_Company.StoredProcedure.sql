USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkc21_1325_Company]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xkc21_1325_Company] @cpnyid1 varchar(10) , @cpnyid2 varchar(10) as
select count(*) from company c1, company c2 where
c1.cpnyid = @cpnyid1
and c2.cpnyid = @cpnyid2
and c1.databasename <> c2.databasename
GO
