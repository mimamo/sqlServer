USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcShipper_delete2]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcShipper_delete2] @cpnyid varchar(10), @databasename varchar(30) as
set nocount on create table #oldrecship  ( oldshipperID char(15))
insert into #oldrecShip (oldshipperID) select X2.oldshipperID from xkcshipper X1, xkcshipper X2, VS_company V where
x1.cpnyid = @cpnyid and x2.cpnyid <> x1.cpnyid and x1.oldshipperID = x2.oldshipperID and x2.cpnyid = V.cpnyid and V.databasename = @databasename
delete xkcshipper from xkcshipper X, #oldrecShip O where X.oldshipperID = O.oldshipperID
drop table #oldrecShip set nocount off
GO
