USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xardoc_all]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xardoc_all] @userid varchar(47), @refnbr varchar(10) as
select * from xardoc where 
userid = @userid
and refnbr like @refnbr
order by userid, refnbr
GO
