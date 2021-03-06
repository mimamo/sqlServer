USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkcorder_delete2]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcorder_delete2] @cpnyid varchar(10), @databasename varchar(30) as
set nocount on create table #oldrec  ( oldordnbr char(15))
insert into #oldrec (oldordnbr) select X2.oldordnbr from xkcorder X1, xkcorder X2, VS_company V where
x1.cpnyid = @cpnyid and x2.cpnyid <> x1.cpnyid and x1.oldordnbr = x2.oldordnbr and x2.cpnyid = V.cpnyid and V.databasename = @databasename
delete xkcorder from xkcorder X, #oldrec O where X.oldordnbr = O.oldordnbr
drop table #oldrec set nocount off
GO
