USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xlotsermst_all]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xlotsermst_all] @userid varchar(47), @invtid varchar(30), @lotsernbr varchar(25) as
select * from xlotsermst where 
userid = @userid
and invtid like @invtid
and lotsernbr like @lotsernbr
order by userid, invtid, lotsernbr
GO
