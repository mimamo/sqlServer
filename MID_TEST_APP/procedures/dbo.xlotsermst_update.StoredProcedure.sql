USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xlotsermst_update]    Script Date: 12/21/2015 15:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xlotsermst_update] @userid varchar(47)  as
delete from xlotsermst where userid = @userid
insert into xlotsermst ( invtid, invtid_descr, lotsernbr, userid)
select DISTINCT invtid, '', lotsernbr, @userid
from lotsermst
GO
