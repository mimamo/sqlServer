USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcSoAddr_grid]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcSoAddr_grid] @custid varchar(15), @oldshiptoid varchar(10),  @linenberbeg smallint, @linenberend smallint as
select * from xkcsoaddr  x, customer c where
x.custid = c.custid
and x.custid like @custid
and oldshiptoid like @Oldshiptoid
and linenbr between @linenberbeg and @linenberend
order by x.custid, oldshiptoid, linenbr
GO
